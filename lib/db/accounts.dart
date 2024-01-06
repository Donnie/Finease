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
    if (account.track) {
      await EntryService().adjustFirstBalance(id, balance);
    }
    return account;
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

  Future<List<Account>> getAllAccounts() async {
    final dbClient = await _databaseHelper.db;
    String pastAccountId =
        await SettingService().getSetting(Setting.pastAccount);

    final List<Map<String, dynamic>> accounts = await dbClient.query(
      Accounts,
      where: 'deleted_at IS NULL AND id != ?',
      whereArgs: [pastAccountId],
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
    final currentTime = DateTime.now();
    return await dbClient.update(
      Accounts,
      {
        'deleted_at': currentTime.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> hardDeleteAccount(int id) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.delete(
      Accounts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalBalance() async {
    final dbClient = await _databaseHelper.db;

    String sql = '''
      SELECT 
        (
          SUM(CASE WHEN debit = 1 THEN balance ELSE 0 END) - 
          SUM(CASE WHEN debit = 0 THEN balance ELSE 0 END)
        ) as total_balance,
        currency
      FROM Accounts
      WHERE
        track = 1 AND
        deleted_at IS NULL
      GROUP BY currency;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    double totalBalance = 0;

    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Loop through each currency and convert the balance to preferred currency
    for (var row in result) {
      String currency = row['currency'];
      int balance = row['total_balance'];

      // Convert balance to preferred currency
      double convertedBalance = await _convertCurrency(currency, balance, prefCurrency);
      totalBalance += convertedBalance;
    }

    return totalBalance / 100;
  }

  Future<double> getTotalBalanceByType(bool debit) async {
    final dbClient = await _databaseHelper.db;
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);

    // Adjust the WHERE clause based on the debit value
    String debitCondition = debit ? '1' : '0';

    // SQL query to calculate the total balance based on the debit flag
    String sql = '''
    SELECT 
      SUM(balance) as total_balance,
      currency
    FROM Accounts
    WHERE
      track = 1 AND
      debit = $debitCondition AND
      deleted_at IS NULL
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
      double convertedBalance = await _convertCurrency(currency, balance, prefCurrency);
      totalBalance += convertedBalance;
    }
    currencyBoxService.close();

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

class Account {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int balance;
  String currency;
  bool liquid;
  String name;
  bool debit;
  bool track;

  Account({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.balance,
    required this.currency,
    required this.liquid,
    required this.name,
    required this.debit,
    required this.track,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      deletedAt: DateTime.tryParse(json['deleted_at'] ?? ''),
      balance: json['balance'],
      currency: json['currency'],
      liquid: json['liquid'] == 1,
      name: json['name'],
      debit: json['debit'] == 1,
      track: json['track'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': DateTime.now().toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'balance': balance,
      'currency': currency,
      'liquid': liquid ? 1 : 0,
      'name': name,
      'debit': debit ? 1 : 0,
      'track': track ? 1 : 0,
    };
  }
}
