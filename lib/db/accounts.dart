import 'package:finease/db/db.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';

// ignore: constant_identifier_names
const String Accounts = 'Accounts';

class AccountService {
  final DatabaseHelper _databaseHelper;

  AccountService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Account?> createAccount(Account account) async {
    final dbClient = await _databaseHelper.db;
    int balance = account.balance;
    account.balance = 0;
    final id = await dbClient.insert(Accounts, account.toJson());
    account.id = id;
    if (account.owned) {
      await adjustFirstBalance(account, balance);
    }
    return account;
  }

  Future adjustFirstBalance(Account account, int balance) async {
    final dbClient = await _databaseHelper.db;
    if (balance != 0) {
      // Check if an account named "Past-3666" already exists
      List<Map> accounts = await dbClient.query(
        Accounts,
        where: 'name = ?',
        whereArgs: ['Past-3666'],
      );

      int pastId;
      if (accounts.isEmpty) {
        // If "Past-3666" doesn't exist, create it
        Account past = Account(
          name: "Past-3666",
          currency: account.currency,
          balance: balance,
          liquid: false,
          debit: false,
          owned: false,
        );
        pastId = await dbClient.insert(Accounts, past.toJson());
      } else {
        // If it exists, use the existing account's ID
        pastId = accounts
            .first['id'];
      }

      await SettingService().setSetting(Setting.startAccount, "$pastId");
      Entry firstTransaction = Entry(
        debitAccountId: account.id!,
        creditAccountId: pastId,
        amount: balance,
        notes: "Auto Adjusted by App"
      );
      await EntryService().createEntry(firstTransaction);
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

  Future<List<Account>> getAllAccounts() async {
    final dbClient = await _databaseHelper.db;
    String startAccountId =
        await SettingService().getSetting(Setting.startAccount);

    final List<Map<String, dynamic>> accounts = await dbClient.query(
      Accounts,
      where: 'deleted_at IS NULL AND id != ?',
      whereArgs: [startAccountId],
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
        ) as total_balance 
      FROM Accounts 
      WHERE
        owned = 1 AND
        deleted_at IS NULL;
    ''';

    // Execute the query
    List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    // Extract the total balance
    int totalBalance = 0;
    if (result.isNotEmpty && result.first['total_balance'] != null) {
      totalBalance = result.first['total_balance'];
    }

    return totalBalance/100;
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
  bool owned;

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
    required this.owned,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      balance: json['balance'],
      currency: json['currency'],
      liquid: json['liquid'] == 1,
      name: json['name'],
      debit: json['debit'] == 1,
      owned: json['owned'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'balance': balance,
      'currency': currency,
      'liquid': liquid ? 1 : 0,
      'name': name,
      'debit': debit ? 1 : 0,
      'owned': owned ? 1 : 0,
    };
  }
}
