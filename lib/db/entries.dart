import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';

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

  Future<void> createMultiCurrencyEntry(Entry entry, double debitAmount) async {
    final creditAccount =
        await AccountService().getAccount(entry.creditAccountId);
    final debitAccount =
        await AccountService().getAccount(entry.debitAccountId);

    final forexAccountDebit = await AccountService()
        .createForexAccountIfNotExist(debitAccount!.currency);
    final forexAccountCredit = await AccountService()
        .createForexAccountIfNotExist(creditAccount!.currency);

    await createEntry(Entry(
      amount: debitAmount,
      creditAccountId: forexAccountDebit.id!,
      date: entry.date,
      debitAccountId: entry.debitAccountId,
      notes: "Forex transaction",
    ));

    await createEntry(Entry(
      amount: entry.amount,
      creditAccountId: entry.creditAccountId,
      date: entry.date,
      debitAccountId: forexAccountCredit.id!,
      notes: entry.notes,
    ));
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
      amount: debitAmount,
      creditAccountId: forexAccountDebit.id!,
      date: entry.date,
      debitAccountId: entry.debitAccountId,
      notes: "Forex transaction by App",
    ));

    await createEntry(Entry(
      amount: entry.amount,
      creditAccountId: entry.creditAccountId,
      date: entry.date,
      debitAccountId: forexAccountCredit.id!,
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
      Entry entry = Entry.fromJson(entries.first);
      final List<Account> allAccounts = await AccountService().getAllAccounts();

      // Create a map for quick account lookup by ID
      var accountsMap = {for (var account in allAccounts) account.id: account};

      entry.creditAccount = accountsMap[entry.creditAccountId];
      entry.debitAccount = accountsMap[entry.debitAccountId];

      return entry;
    }
    return null;
  }

  Future<List<Entry>> getAllEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? accountId,
  }) async {
    final dbClient = await _databaseHelper.db;

    List<String> conditions = [];
    List<dynamic> whereArguments = [];
    // If account id is provided, add it to the where clause
    if (accountId != null) {
      conditions.add('debit_account_id = ? OR credit_account_id = ?');
      whereArguments.add(accountId);
      whereArguments.add(accountId);
    }

    // If startDate is provided, add it to the where clause
    if (startDate != null) {
      conditions.add('date >= ?');
      whereArguments.add(startDate.toIso8601String());
    }

    // If endDate is provided, add it to the where clause
    if (endDate != null) {
      conditions.add('date <= ?');
      whereArguments.add(endDate.toIso8601String());
    }

    String whereClause = '';
    if (conditions.isNotEmpty) {
      whereClause += conditions.join(' AND ');
    }

    // Fetch all entries according to the provided start and end dates
    final List<Map<String, dynamic>> entriesData = await dbClient.query(
      'Entries',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArguments.isEmpty ? null : whereArguments,
    );

    final List<Account> allAccounts = await AccountService().getAllAccounts();

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

  /// Merges forex transaction pairs into single entries for display
  /// This method intelligently finds and merges forex pairs regardless of order
  Future<List<Entry>> getMergedEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? accountId,
  }) async {
    final allEntries = await getAllEntries(
      startDate: startDate,
      endDate: endDate,
      accountId: accountId,
    );

    // Sort by date descending
    allEntries.sort((a, b) => (b.date ?? DateTime(0))
        .compareTo(a.date ?? DateTime(0)));

    final List<Entry> mergedEntries = [];
    final Set<int> processedIds = {};

    for (var entry in allEntries) {
      // Skip if already processed
      if (processedIds.contains(entry.id)) continue;

      // Check if this is a forex pair entry
      if (isForexPairEntry(entry)) {
        // Try to find its pair
        final pairedEntry = await findForexPairEntry(entry, allEntries);

        if (pairedEntry != null) {
          // Merge the two entries
          final mergedEntry = _mergeForexEntries(entry, pairedEntry);
          mergedEntries.add(mergedEntry);
          processedIds.add(entry.id!);
          processedIds.add(pairedEntry.id!);
        } else {
          // No pair found, add as-is (shouldn't happen, but handle gracefully)
          mergedEntries.add(entry);
          processedIds.add(entry.id!);
        }
      } else {
        // Regular entry, add as-is
        mergedEntries.add(entry);
        processedIds.add(entry.id!);
      }
    }

    return mergedEntries;
  }

  /// Merges two forex entries into a single display entry
  Entry _mergeForexEntries(Entry entry1, Entry entry2) {
    // Determine which entry is the debit side and which is credit side
    final entry1IsDebitSide = _isForexAccount(entry1.creditAccount);
    final entry2IsCreditSide = _isForexAccount(entry2.debitAccount);
    final entry2IsDebitSide = _isForexAccount(entry2.creditAccount);
    final entry1IsCreditSide = _isForexAccount(entry1.debitAccount);

    Entry debitEntry, creditEntry;
    if (entry1IsDebitSide && entry2IsCreditSide) {
      debitEntry = entry1;
      creditEntry = entry2;
    } else if (entry2IsDebitSide && entry1IsCreditSide) {
      debitEntry = entry2;
      creditEntry = entry1;
    } else {
      // Fallback: use entry1 as debit, entry2 as credit
      debitEntry = entry1;
      creditEntry = entry2;
    }

    // Get the user's notes (from the credit side entry, which usually has user notes)
    String? userNotes = creditEntry.notes;
    // If credit side has no notes, try the debit side
    if (userNotes == null || userNotes.isEmpty) {
      userNotes = debitEntry.notes;
    }
    
    // Append credit account currency and amount to the notes
    final creditCurrencySymbol = SupportedCurrency[creditEntry.creditAccount?.currency] ?? creditEntry.creditAccount?.currency ?? '';
    final creditAmount = creditEntry.amount;
    final creditInfo = '$creditCurrencySymbol$creditAmount';
    
    // Combine user notes with credit currency/amount info
    final finalNotes = (userNotes != null && userNotes.isNotEmpty) 
        ? '$userNotes ($creditInfo)'
        : creditInfo;

    return Entry(
      id: debitEntry.id, // Use the debit entry's ID
      debitAccountId: debitEntry.debitAccountId,
      debitAccount: debitEntry.debitAccount,
      creditAccountId: creditEntry.creditAccountId,
      creditAccount: creditEntry.creditAccount,
      amount: debitEntry.amount,
      date: debitEntry.date ?? creditEntry.date,
      notes: finalNotes,
      createdAt: debitEntry.createdAt,
      updatedAt: creditEntry.updatedAt,
    );
  }

  Future<int> updateEntry(Entry entry) async {
    final dbClient = await _databaseHelper.db;
    
    // Check if this is a forex pair entry
    if (isForexPairEntry(entry)) {
      // Get all entries to find the pair
      final allEntries = await getAllEntries();
      final pairedEntry = await findForexPairEntry(entry, allEntries);
      
      if (pairedEntry != null) {
        // Update the paired entry's date to match
        if (entry.date != null && pairedEntry.date != entry.date) {
          pairedEntry.date = entry.date;
          await dbClient.update(
            'Entries',
            pairedEntry.toJson(),
            where: 'id = ?',
            whereArgs: [pairedEntry.id],
          );
        }
      }
    }
    
    return await dbClient.update(
      'Entries',
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  /// Updates both entries in a forex pair with the same date
  /// Only updates the credit entry's notes (user notes)
  Future<void> updateForexPair({
    required Entry debitEntry,
    required Entry creditEntry,
    required DateTime date,
    required String? creditNotes,
  }) async {
    final dbClient = await _databaseHelper.db;
    
    // Update both entries' dates
    debitEntry.date = date;
    creditEntry.date = date;
    
    // Only update credit entry's notes (user notes)
    if (creditNotes != null) {
      creditEntry.notes = creditNotes;
    }
    
    // Update both entries in the database
    await dbClient.update(
      'Entries',
      debitEntry.toJson(),
      where: 'id = ?',
      whereArgs: [debitEntry.id],
    );
    
    await dbClient.update(
      'Entries',
      creditEntry.toJson(),
      where: 'id = ?',
      whereArgs: [creditEntry.id],
    );
  }

  /// Checks if an account is a forex account (name="Forex" and hidden=true)
  bool _isForexAccount(Account? account) {
    return account != null &&
        account.name == "Forex" &&
        account.hidden == true;
  }

  /// Public method to check if an account is a forex account
  bool isForexAccount(Account? account) {
    return _isForexAccount(account);
  }


  /// Checks if an entry is part of a forex transaction pair
  bool isForexPairEntry(Entry entry) {
    return _isForexAccount(entry.debitAccount) ||
        _isForexAccount(entry.creditAccount);
  }

  /// Finds the paired entry for a forex transaction
  /// Returns null if no pair is found
  Future<Entry?> findForexPairEntry(Entry entry, List<Entry> allEntries) async {
    // Match by timestamp (within 1 second) and forex account pattern
    if (!isForexPairEntry(entry)) return null;

    final isDebitSide = _isForexAccount(entry.creditAccount);
    final isCreditSide = _isForexAccount(entry.debitAccount);

    if (!isDebitSide && !isCreditSide) return null;

    for (var otherEntry in allEntries) {
      if (otherEntry.id == entry.id) continue;
      if (!isForexPairEntry(otherEntry)) continue;

      // Check if timestamps match (within 1 second)
      if (entry.date != null && otherEntry.date != null) {
        final timeDiff = (entry.date!.millisecondsSinceEpoch -
                otherEntry.date!.millisecondsSinceEpoch)
            .abs();
        if (timeDiff > 1000) continue; // More than 1 second apart
      }

      // Match pattern: one entry has forex as credit, other has forex as debit
      final otherIsDebitSide = _isForexAccount(otherEntry.creditAccount);
      final otherIsCreditSide = _isForexAccount(otherEntry.debitAccount);

      if (isDebitSide && otherIsCreditSide) {
        // This entry: RealAccount -> ForexAccount
        // Other entry: ForexAccount -> RealAccount
        return otherEntry;
      } else if (isCreditSide && otherIsDebitSide) {
        // This entry: ForexAccount -> RealAccount
        // Other entry: RealAccount -> ForexAccount
        return otherEntry;
      }
    }

    return null;
  }

  Future<int> deleteEntry(int id) async {
    final dbClient = await _databaseHelper.db;
    
    // Get the entry first to check if it's part of a forex pair
    final entry = await getEntry(id);
    if (entry != null && isForexPairEntry(entry)) {
      // Get all entries to find the pair
      final allEntries = await getAllEntries();
      final pairedEntry = await findForexPairEntry(entry, allEntries);
      
      if (pairedEntry != null && pairedEntry.id != null) {
        // Delete both entries
        await dbClient.delete(
          'Entries',
          where: 'id = ?',
          whereArgs: [pairedEntry.id],
        );
      }
    }
    
    return await dbClient.delete(
      'Entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> adjustFirstBalance(
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

  Future<void> adjustFirstForexBalance(
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

  Future<void> addCurrencyRetranslation(
    double amount,
  ) async {
    Account forexReTrans =
        await AccountService().createForexRetransAccIfNotExist();

    String? capG = await SettingService().getSetting(Setting.capitalGains);
    int? capGains = int.tryParse(capG);
    if (capGains == null) {
      throw AccountLinkingException("Capital Gains account not linked");
    }

    Entry entry = Entry(
      debitAccountId: capGains,
      creditAccountId: forexReTrans.id!,
      amount: amount,
      notes: "Foreign Currency Retranslation",
    );

    await createEntry(entry);
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

class AccountLinkingException implements Exception {
  final String message;
  AccountLinkingException(this.message);

  @override
  String toString() => message;
}
