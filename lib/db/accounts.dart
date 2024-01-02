import 'package:finease/db/db.dart';

const String Accounts = 'Accounts';

class AccountService {
  final DatabaseHelper _databaseHelper;

  AccountService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Account?> createAccount(Account account) async {
    final dbClient = await _databaseHelper.db;
    final id = await dbClient.insert(Accounts, account.toJson());
    account.id = id;
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
    final List<Map<String, dynamic>> accounts = await dbClient.query(
      Accounts,
      where: 'deleted_at IS NULL',
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
    };
  }
}
