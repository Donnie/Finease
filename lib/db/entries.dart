import 'package:finease/db/accounts.dart';
import 'package:finease/db/db.dart';

class EntryService {
  final DatabaseHelper _databaseHelper;

  EntryService({DatabaseHelper? databaseHelper, AccountService? accountService})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Entry?> createEntry(Entry entry) async {
    final dbClient = await _databaseHelper.db;

    // Insert the new entry
    final id = await dbClient.insert('Entries', entry.toJson());
    entry.id = id;

    return entry;
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
      where: 'deleted_at IS NULL',
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
    final currentTime = DateTime.now();
    return await dbClient.update(
      'Entries',
      {
        'deleted_at': currentTime.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> hardDeleteEntry(int id) async {
    final dbClient = await _databaseHelper.db;
    return await dbClient.delete(
      'Entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Entry {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int debitAccountId;
  int creditAccountId;
  int amount;
  DateTime? date;
  String? notes;

  Entry({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
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
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      debitAccountId: json['debit_account_id'],
      creditAccountId: json['credit_account_id'],
      amount: json['amount'],
      date: DateTime.tryParse(json['date'] ?? ''),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'debit_account_id': debitAccountId,
      'credit_account_id': creditAccountId,
      'amount': amount,
      'date': date?.toIso8601String(),
      'notes': notes,
    };
  }
}
