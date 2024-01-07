import 'package:finease/db/currency.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';

// ignore: constant_identifier_names
const String Accounts = 'Accounts';

class AccountService {
  final DatabaseHelper _databaseHelper;
  final SettingService _settingService = SettingService();
  final CurrencyBoxService currencyBoxService = CurrencyBoxService();

  AccountService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Account?> createAccount(Account account) async {
    final dbClient = await _databaseHelper.db;
    int balance = account.balance;
    account.balance = 0;
    final id = await dbClient.insert(Accounts, account.toJson());
    account.id = id;
    if (account.currency == 'EUR') {
      await EntryService().adjustFirstBalance(id, balance);
    } else {
      await EntryService().adjustFirstForexBalance(id, balance);
    }
    return account;
  }

  Future<Account?> createForexAccountIfNotExist(
    String currency, {
    int balance = 0,
    bool liquid = true,
    name = "Forex",
    type = AccountType.expense,
  }) async {
    final dbClient = await _databaseHelper.db;
    // Check if the account already exists
    final List<Map<String, dynamic>> existingAccounts = await dbClient.query(
      Accounts,
      where: 'currency = ? AND name = ? AND hidden = ?',
      whereArgs: [currency, name, 1],
    );
    if (existingAccounts.isNotEmpty) {
      // Account already exists, return the existing account
      return Account.fromJson(existingAccounts.first);
    } else {
      // Account does not exist, create a new one
      Account newAccount = Account(
        balance: balance,
        currency: currency,
        name: name,
        hidden: true,
        type: type,
        liquid: liquid,
      );
      // Persist the new account and return it
      return await createAccount(newAccount);
    }
  }

  Future<Account?> getAccount(int id) async {
    final dbClient = await _databaseHelper.db;
    final List<Map<String, dynamic>> accounts = await dbClient.query(
      Accounts,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (accounts.isNotEmpty) {
      return Account.fromJson(accounts.first);
    }
    return null;
  }

  Future<List<Account>> getAllAccounts(bool hidden) async {
    final dbClient = await _databaseHelper.db;

    String? whereClause = hidden ? null : "hidden = 0";

    final List<Map<String, dynamic>> accounts = await dbClient.query(
      Accounts,
      where: whereClause,
    );

    return accounts.map((json) => Account.fromJson(json)).toList();
  }

  Future<int> updateAccount(Account account) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.update(
      Accounts,
      account.toJson(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> deleteAccount(int id) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.delete(
      Accounts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalLiquidBalance() async {
    final dbClient = await _databaseHelper.db;

    String sql = '''
      SELECT 
        (
          SUM(CASE WHEN type = 'asset' THEN balance ELSE 0 END) - 
          SUM(CASE WHEN type = 'liability' THEN balance ELSE 0 END)
        ) as total_balance,
        currency
      FROM Accounts
      WHERE
        liquid = 1
      GROUP BY currency;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    double totalBalance = 0;

    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Loop through each currency and convert the balance to preferred currency
    await currencyBoxService.init();
    for (var row in result) {
      String currency = row['currency'];
      int balance = row['total_balance'];

      // Convert balance to preferred currency
      double convertedBalance =
          await _convertCurrency(currency, balance, prefCurrency);
      totalBalance += convertedBalance;
    }

    return totalBalance / 100;
  }

  Future<double> getTotalBalance() async {
    final dbClient = await _databaseHelper.db;

    String sql = '''
      SELECT 
        (
          SUM(CASE WHEN type = 'asset' THEN balance ELSE 0 END) - 
          SUM(CASE WHEN type = 'liability' THEN balance ELSE 0 END)
        ) as total_balance,
        currency
      FROM Accounts
      GROUP BY currency;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    double totalBalance = 0;

    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Loop through each currency and convert the balance to preferred currency
    await currencyBoxService.init();
    for (var row in result) {
      String currency = row['currency'];
      int balance = row['total_balance'];

      // Convert balance to preferred currency
      double convertedBalance =
          await _convertCurrency(currency, balance, prefCurrency);
      totalBalance += convertedBalance;
    }

    return totalBalance / 100;
  }

  Future<double> getTotalBalanceByType(AccountType type) async {
    final dbClient = await _databaseHelper.db;
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Adjust the WHERE clause based on the type value
    String accountType = type.name;

    // SQL query to calculate the total balance based on the debit flag
    String sql = '''
      SELECT 
        SUM(balance) as total_balance,
        currency
      FROM Accounts
      WHERE
        type = '$accountType'
      GROUP BY currency;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    double totalBalance = 0;

    await currencyBoxService.init();
    for (var row in result) {
      String currency = row['currency'];
      int balance = row['total_balance'];

      // Convert balance to preferred currency
      double convertedBalance =
          await _convertCurrency(currency, balance, prefCurrency);
      totalBalance += convertedBalance;
    }

    return totalBalance / 100;
  }

  Future<double> _convertCurrency(
    String fromCurrency,
    int balance,
    String toCurrency,
  ) async {
    double rate =
        await currencyBoxService.getSingleRate(fromCurrency, toCurrency);
    return balance * rate;
  }
}

enum AccountType {
  income,
  expense,
  asset,
  liability,
}

class Account {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int balance;
  String currency;
  bool liquid;
  bool hidden;
  String name;
  AccountType type;

  Account({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.balance,
    required this.currency,
    required this.liquid,
    this.hidden = false,
    required this.name,
    required this.type,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      balance: json['balance'],
      currency: json['currency'],
      liquid: json['liquid'] == 1,
      hidden: json['hidden'] == 1,
      name: json['name'],
      type: AccountType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': DateTime.now().toIso8601String(),
      'balance': balance,
      'currency': currency,
      'liquid': liquid ? 1 : 0,
      'hidden': hidden ? 1 : 0,
      'name': name,
      'type': type.toString().split('.').last,
    };
  }
}
