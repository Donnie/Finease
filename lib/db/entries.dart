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
      creditAccountId: forexAccountDebit!.id!,
      amount: debitAmount.floor(),
      notes: "Auto Adjusted by App",
    ));

    await createEntry(Entry(
      debitAccountId: forexAccountCredit!.id!,
      creditAccountId: entry.creditAccountId,
      amount: entry.amount.ceil(),
      notes: "Auto Adjusted by App",
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

  Future<List<Entry>> getAllEntries() async {
    final dbClient = await _databaseHelper.db;

    final List<Map<String, dynamic>> entries = await dbClient.query(
      'Entries',
    );
    return entries.map((json) => Entry.fromJson(json)).toList();
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

  Future adjustFirstBalance(int accountId, int balance) async {
    if (balance == 0) {
      return;
    }

    final dbClient = await _databaseHelper.db;
    Entry entry = Entry(
      debitAccountId: 1,
      creditAccountId: accountId,
      amount: balance,
      notes: "Auto Adjusted by App",
    );

    await dbClient.insert('Entries', entry.toJson());
  }

  Future adjustFirstForexBalance(int accountId, int balance) async {
    if (balance == 0) {
      return;
    }

    Entry entry = Entry(
      debitAccountId: 1,
      creditAccountId: accountId,
      amount: balance,
      notes: "Auto Adjusted by App",
    );

    await createForexEntry(entry);
  }
}

class Entry {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int debitAccountId;
  int creditAccountId;
  int amount;
  DateTime? date;
  String? notes;

  Entry({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.debitAccountId,
    required this.creditAccountId,
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
      amount: json['amount'],
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
      'amount': amount,
      'date': (date ?? DateTime.now()).toIso8601String(),
      'notes': notes,
    };
  }
}
