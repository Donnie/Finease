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

  Future<Account> createAccount(Account account) async {
    final dbClient = await _databaseHelper.db;
    double balance = account.balance;
    account.balance = 0;
    final id = await dbClient.insert(Accounts, account.toJson());
    account.id = id;

    if (balance == 0) {
      return account;
    }

    // adjustments for new account with non zero balance
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);
    String pastAccount = await _settingService.getSetting(Setting.pastAccount);
    int pastAccountId = int.parse(pastAccount);
    if (account.currency == prefCurrency) {
      await EntryService().adjustFirstBalance(id, pastAccountId, balance);
    } else {
      await EntryService().adjustFirstForexBalance(id, pastAccountId, balance);
    }
    return account;
  }

  Future<Account> createForexAccountIfNotExist(
    String currency, {
    double balance = 0,
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

    final List<Map<String, dynamic>> accounts = await dbClient.rawQuery('''
      SELECT 
        Accounts.*,
        CASE
          WHEN (SELECT COUNT(*) FROM Entries 
                WHERE Entries.debit_account_id = Accounts.id 
                OR Entries.credit_account_id = Accounts.id) = 0 THEN 1
          ELSE 0
        END AS deletable
      FROM Accounts
      WHERE Accounts.id = ?
    ''', [id]);

    if (accounts.isNotEmpty) {
      return Account.fromJson(accounts.first);
    }
    return null;
  }

  Future<List<Account>> getAllAccounts(bool hidden) async {
    final dbClient = await _databaseHelper.db;

    var whereClause = hidden ? '' : 'WHERE hidden = 0';

    String rawQuery = '''
      SELECT
        Accounts.*,
        CASE
          WHEN (SELECT COUNT(*) FROM Entries 
                WHERE Entries.debit_account_id = Accounts.id 
                OR Entries.credit_account_id = Accounts.id) = 0 THEN 1
          ELSE 0
        END AS deletable
      FROM Accounts
      $whereClause
    ''';

    final List<Map<String, dynamic>> accounts =
        await dbClient.rawQuery(rawQuery);

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

  Future<double> getTotalBalance({
    bool liquid = false,
    AccountType? type,
  }) async {
    final dbClient = await _databaseHelper.db;
    List<String> conditions = ['hidden = 0'];

    if (liquid) {
      conditions.add('liquid = 1');
    }

    if (type != null) {
      conditions.add("type = '${type.name}'");
    }

    String whereClause = conditions.join(' AND ');

    String sql = '''
      SELECT 
        SUM(balance) as total_balance,
        currency
      FROM Accounts
      WHERE $whereClause
        AND type NOT IN ('income', 'expense')
      GROUP BY currency;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    // result is like:
    // [{total_balance: 9880057, currency: EUR}]

    int totalBalance = 0;
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Determine if conversion is needed and initialize currencyBoxService once if true
    bool needsConversion = result.any((row) => row['currency'] != prefCurrency);
    if (needsConversion) {
      await currencyBoxService.init();
    }

    // Loop through each currency and convert the balance to preferred currency
    for (var row in result) {
      String currency = row['currency'];
      int balance = row['total_balance'];

      // If the currency is not the preferred currency, convert it
      if (currency != prefCurrency) {
        double rate = await currencyBoxService.getSingleRate(
          currency,
          prefCurrency,
        );
        totalBalance += (balance * rate).round();
      } else {
        // Already in preferred currency, no conversion needed
        totalBalance += balance;
      }
    }

    return totalBalance / 100;
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
  double balance;
  String currency;
  bool liquid;
  bool hidden;
  String name;
  AccountType type;
  bool deletable;

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
    this.deletable = false,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    AccountType type = AccountType.values
        .firstWhere((e) => e.toString().split('.').last == json['type']);
    return Account(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      balance: json['balance'] / 100,
      currency: json['currency'],
      liquid: json['liquid'] == 1,
      hidden: json['hidden'] == 1,
      name: json['name'],
      type: type,
      // readonly
      deletable: json['deletable'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': DateTime.now().toIso8601String(),
      'balance': (balance * 100).round().toInt(),
      'currency': currency,
      'liquid': liquid ? 1 : 0,
      'hidden': hidden ? 1 : 0,
      'name': name,
      'type': type.toString().split('.').last,
    };
  }
}
