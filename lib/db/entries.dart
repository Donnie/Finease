import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/db.dart';

class EntryService {
  final DatabaseHelper _databaseHelper;
  final CurrencyBoxService _currencyBoxService = CurrencyBoxService();

  EntryService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Entry?> createEntry(Entry entry) async {
    final dbClient = await _databaseHelper.db;

    final id = await dbClient.insert('Entries', entry.toJson());
    entry.id = id;

    return entry;
  }

  Future<void> createForexEntry(Entry entry) async {
    final creditAccount =
        await AccountService().getAccount(entry.creditAccountId);
    final debitAccount =
        await AccountService().getAccount(entry.debitAccountId);

    await _currencyBoxService.init();
    final rate = await _currencyBoxService.getSingleRate(
      creditAccount!.currency,
      debitAccount!.currency,
    );
    final debitAmount = entry.amount * rate;

    final forexAccountDebit = await AccountService()
        .createForexAccountIfNotExist(debitAccount.currency);
    final forexAccountCredit = await AccountService()
        .createForexAccountIfNotExist(creditAccount.currency);

    await createEntry(Entry(
      debitAccountId: entry.debitAccountId,
      creditAccountId: forexAccountDebit.id!,
      amount: debitAmount,
      notes: "Forex transaction by App",
    ));

    await createEntry(Entry(
      debitAccountId: forexAccountCredit.id!,
      creditAccountId: entry.creditAccountId,
      amount: entry.amount,
      notes: entry.notes,
    ));
  }

  Future<Entry?> getEntry(int id) async {
    final dbClient = await _databaseHelper.db;
    final List<Map<String, dynamic>> entries = await dbClient.query(
      'Entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (entries.isNotEmpty) {
      return Entry.fromJson(entries.first);
    }
    return null;
  }

  Future<List<Entry>> getAllEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dbClient = await _databaseHelper.db;

    String whereClause = '';
    List<dynamic> whereArguments = [];

    // If startDate is provided, add it to the where clause
    if (startDate != null) {
      whereClause += 'date >= ?';
      whereArguments.add(startDate.toIso8601String());
    }

    // If endDate is provided, add it to the where clause
    if (endDate != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'date <= ?';
      whereArguments.add(endDate.toIso8601String());
    }

    // Fetch all entries according to the provided start and end dates
    final List<Map<String, dynamic>> entriesData = await dbClient.query(
      'Entries',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArguments.isEmpty ? null : whereArguments,
    );

    final List<Account> allAccounts =
        await AccountService().getAllAccounts(true);

    // Create a map for quick account lookup by ID
    var accountsMap = {for (var account in allAccounts) account.id: account};

    // Map each entry to its corresponding debit and credit accounts
    List<Entry> entries = entriesData.map((json) {
      Entry entry = Entry.fromJson(json);
      entry.creditAccount = accountsMap[json['credit_account_id']];
      entry.debitAccount = accountsMap[json['debit_account_id']];
      return entry;
    }).toList();

    return entries;
  }

  Future<int> updateEntry(Entry entry) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.update(
      'Entries',
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.delete(
      'Entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future adjustFirstBalance(
      int toAccountId, int fromAccountId, double balance) async {
    if (balance == 0) {
      return;
    }

    final dbClient = await _databaseHelper.db;
    Entry entry = Entry(
      debitAccountId: fromAccountId,
      creditAccountId: toAccountId,
      amount: balance,
      notes: "Carry In By App",
    );

    await dbClient.insert('Entries', entry.toJson());
  }

  Future adjustFirstForexBalance(
      int toAccountId, int fromAccountId, double balance) async {
    if (balance == 0) {
      return;
    }

    Entry entry = Entry(
      debitAccountId: fromAccountId,
      creditAccountId: toAccountId,
      amount: balance,
      notes: "Carry In By App",
    );

    await createForexEntry(entry);
  }
}

class Entry {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int debitAccountId;
  Account? debitAccount;
  int creditAccountId;
  Account? creditAccount;
  double amount;
  DateTime? date;
  String? notes;

  Entry({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.debitAccountId,
    this.debitAccount,
    required this.creditAccountId,
    this.creditAccount,
    required this.amount,
    this.date,
    this.notes,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      debitAccountId: json['debit_account_id'],
      creditAccountId: json['credit_account_id'],
      amount: json['amount'] / 100,
      date: DateTime.tryParse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': DateTime.now().toIso8601String(),
      'debit_account_id': debitAccountId,
      'credit_account_id': creditAccountId,
      'amount': (amount * 100).round().toInt(),
      'date': (date ?? DateTime.now()).toIso8601String(),
      'notes': notes,
    };
  }
}
