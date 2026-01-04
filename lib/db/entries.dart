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

    // If account id is provided, use SQL query to filter forex pairs
    if (accountId != null) {
      // only include forex entries that have a pair involving the account
      conditions.add('''
        (debit_account_id = ? OR credit_account_id = ?)
        OR
        (
          (debit_account_id IN (SELECT id FROM Accounts WHERE name = 'Forex' AND hidden = 1)
           OR credit_account_id IN (SELECT id FROM Accounts WHERE name = 'Forex' AND hidden = 1))
          AND
          EXISTS (
            SELECT 1 FROM Entries e2
            WHERE e2.id != Entries.id
            AND ABS(CAST(strftime('%s', e2.date) AS INTEGER) - CAST(strftime('%s', Entries.date) AS INTEGER)) <= 1
            AND (e2.debit_account_id = ? OR e2.credit_account_id = ?)
            AND (
              e2.debit_account_id IN (SELECT id FROM Accounts WHERE name = 'Forex' AND hidden = 1)
              OR e2.credit_account_id IN (SELECT id FROM Accounts WHERE name = 'Forex' AND hidden = 1)
            )
          )
        )
      ''');
      whereArguments.add(accountId); // Direct debit match
      whereArguments.add(accountId); // Direct credit match
      whereArguments.add(accountId); // Paired entry debit match
      whereArguments.add(accountId); // Paired entry credit match
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

    // Fetch all entries according to the provided filters
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

  /// Get entries with running balance for a specific account using SQL
  /// This properly handles forex transactions and calculates balance in account currency
  Future<List<Map<String, dynamic>>> getEntriesWithBalance({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dbClient = await _databaseHelper.db;
    
    List<dynamic> whereArguments = [accountId, accountId];
    String dateFilter = '';
    
    if (startDate != null) {
      dateFilter += ' AND e.date >= ?';
      whereArguments.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      dateFilter += ' AND e.date <= ?';
      whereArguments.add(endDate.toIso8601String());
    }
    
    // Add accountId for balance_change calculation and WHERE clause
    whereArguments.add(accountId);
    whereArguments.add(accountId);
    whereArguments.add(accountId);
    whereArguments.add(accountId);
    
    final String query = '''
      WITH ForexPairs AS (
        SELECT 
          ed.id AS debit_entry_id,
          ec.id AS credit_entry_id,
          ad.currency AS debit_currency,
          ac.currency AS credit_currency
        FROM entries ed
        JOIN entries ec ON ed.date = ec.date AND ed.id <> ec.id
        JOIN accounts ad ON ed.debit_account_id = ad.id
        JOIN accounts ac ON ec.credit_account_id = ac.id
        JOIN accounts adc ON ed.credit_account_id = adc.id AND adc.name = 'Forex'
        JOIN accounts acd ON ec.debit_account_id = acd.id AND acd.name = 'Forex'
      ),
      ConsolidatedForex AS (
        SELECT
          f.debit_entry_id AS id,
          e1.debit_account_id,
          e2.credit_account_id,
          e1.date,
          e2.notes AS user_notes,
          e2.amount AS credit_amount,
          ac.currency AS credit_currency,
          1 AS is_forex,
          -- Use debit amount if account is debit, credit amount if account is credit
          CASE 
            WHEN e1.debit_account_id = ? THEN e1.amount
            WHEN e2.credit_account_id = ? THEN e2.amount
            ELSE e1.amount
          END AS amount,
          ad.name AS debit_account_name,
          ad.currency AS debit_currency,
          ac.name AS credit_account_name
        FROM ForexPairs f
        JOIN entries e1 ON f.debit_entry_id = e1.id
        JOIN entries e2 ON f.credit_entry_id = e2.id
        JOIN accounts ad ON e1.debit_account_id = ad.id
        JOIN accounts ac ON e2.credit_account_id = ac.id
      ),
      NormalEntries AS (
        SELECT 
          e.id,
          e.debit_account_id,
          e.credit_account_id,
          e.date,
          e.notes AS user_notes,
          0 AS credit_amount,
          '' AS credit_currency,
          0 AS is_forex,
          e.amount,
          ad.name AS debit_account_name,
          ad.currency AS debit_currency,
          ac.name AS credit_account_name
        FROM entries e
        JOIN accounts ad ON e.debit_account_id = ad.id
        JOIN accounts ac ON e.credit_account_id = ac.id
        WHERE e.id NOT IN (SELECT debit_entry_id FROM ForexPairs)
          AND e.id NOT IN (SELECT credit_entry_id FROM ForexPairs)
      ),
      AllEntries AS (
        SELECT * FROM ConsolidatedForex
        UNION ALL
        SELECT * FROM NormalEntries
      ),
      FilteredEntries AS (
        SELECT 
          e.*,
          CASE 
            WHEN e.credit_account_id = ? THEN e.amount
            WHEN e.debit_account_id = ? THEN -e.amount
            ELSE 0
          END AS balance_change
        FROM AllEntries e
        WHERE (e.debit_account_id = ? OR e.credit_account_id = ?)
        $dateFilter
      )
      SELECT 
        id,
        date,
        debit_account_id,
        debit_account_name,
        debit_currency,
        credit_account_id,
        credit_account_name,
        credit_currency,
        amount,
        user_notes,
        credit_amount,
        is_forex,
        balance_change,
        SUM(balance_change) OVER (ORDER BY date ASC, id ASC) AS running_balance
      FROM FilteredEntries
      ORDER BY date ASC, id ASC
    ''';
    
    final result = await dbClient.rawQuery(query, whereArguments);
    return result;
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
