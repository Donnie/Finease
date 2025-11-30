import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/card.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntriesPage extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? accountID;
  const EntriesPage({
    super.key,
    this.accountID,
    this.startDate,
    this.endDate,
  });

  @override
  EntriesPageState createState() => EntriesPageState();
}

class EntriesPageState extends State<EntriesPage> {
  final EntryService _entryService = EntryService();
  final SettingService _settingService = SettingService();
  List<Entry> entries = [];
  String? prefCurrency;

  @override
  void initState() {
    super.initState();
    loadEntries();
    _loadPreferredCurrency();
  }

  Future<void> _loadPreferredCurrency() async {
    final currency = await _settingService.getSetting(Setting.prefCurrency);
    setState(() {
      prefCurrency = currency;
    });
  }

  Future<void> loadEntries() async {
    List<Entry> entriesList = await _entryService.getAllEntries(
      startDate: widget.startDate,
      endDate: widget.endDate,
      accountId: widget.accountID,
    );
    entriesList.sort((a, b) => (b.date!.compareTo(a.date!)));

    List<Entry> mergedEntries = [];
    for (int i = 0; i < entriesList.length; i++) {
      Entry creditEntry = entriesList[i];
      bool merged = false;

      // Check if the next entry exists and if it's within a 1-second interval
      if (i < entriesList.length - 1) {
        Entry debitEntry = entriesList[i + 1];
        if ((creditEntry.date! == debitEntry.date!) &&
            // name because in multi currency trans only name is same, ids are diff.
            debitEntry.creditAccount!.name == creditEntry.debitAccount!.name) {
          Entry mergedEntry = mergeEntries(debitEntry, creditEntry);
          mergedEntries.add(mergedEntry);
          i++; // Skip the next entry as it's merged
          merged = true;
        }
      }

      // Add the current entry if it's not merged
      if (!merged) {
        mergedEntries.add(creditEntry);
      }
    }

    // Update state
    setState(() {
      entries = mergedEntries;
    });
  }

  Entry mergeEntries(Entry entry1, Entry entry2) {
    return Entry(
      id: entry1.id,
      debitAccountId: entry1.debitAccountId,
      debitAccount: entry1.debitAccount,
      creditAccountId: entry2.creditAccountId,
      creditAccount: entry2.creditAccount,
      amount: entry2.amount,
      date: entry1.date,
      notes: entry2.notes,
    );
  }

  List<Map<String, dynamic>> getTopExpenses() {
    // Filter expense entries by preferred currency
    final expenseEntries = entries.where((entry) =>
        entry.creditAccount?.type == AccountType.expense &&
        entry.creditAccount != null &&
        (prefCurrency == null || entry.creditAccount!.currency == prefCurrency)).toList();

    // Group by account name and currency, sum amounts
    final Map<String, Map<String, dynamic>> expenseMap = {};
    for (var entry in expenseEntries) {
      final accountName = entry.creditAccount!.name;
      final currency = entry.creditAccount!.currency;
      final key = '$accountName|$currency';

      if (expenseMap.containsKey(key)) {
        expenseMap[key]!['amount'] += entry.amount;
      } else {
        expenseMap[key] = {
          'accountName': accountName,
          'currency': currency,
          'amount': entry.amount,
        };
      }
    }

    // Convert to list, sort by amount descending, take top 5
    final topExpenses = expenseMap.values.toList()
      ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    return topExpenses.toList();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldStateKey =
        GlobalKey<ScaffoldState>();
    int destIndex = 0;

    void updateBody(int index) {
      setState(() {
        destIndex = index;
      });
      context.goNamed(
        destinations[destIndex].routeName.name,
        extra: () => {},
      );
    }

    void entryOnDelete(int id) {
      _entryService.deleteEntry(id);
      loadEntries();
    }

    return Scaffold(
      key: scaffoldStateKey,
      appBar: appBar(
        context,
        "transactions",
      ),
      body: RefreshIndicator(
        onRefresh: loadEntries,
        child: widget.startDate != null && widget.endDate != null
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TopExpensesCard(topExpenses: getTopExpenses()),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return EntryCard(
                          entry: entries[index],
                          onDelete: entryOnDelete,
                          onCardTap: loadEntries,
                        );
                      },
                      childCount: entries.length,
                    ),
                  ),
                ],
              )
            : EntriesListView(
                entries: entries,
                onDelete: entryOnDelete,
                onEdit: loadEntries,
              ),
      ),
      drawer: AppDrawer(
        onRefresh: loadEntries,
        scaffoldKey: scaffoldStateKey,
        selectedIndex: 2,
        destinations: destinations,
        onDestinationSelected: updateBody,
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () => context.pushNamed(
          RoutesName.addEntry.name,
          extra: loadEntries,
          queryParameters: widget.accountID != null
              ? {'debit_account_id': widget.accountID.toString()}
              : {},
        ),
        icon: Icons.add,
      ),
    );
  }
}

class TopExpensesCard extends StatelessWidget {
  final List<Map<String, dynamic>> topExpenses;

  const TopExpensesCard({
    super.key,
    required this.topExpenses,
  });

  @override
  Widget build(BuildContext context) {
    if (topExpenses.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                // Header row
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Account',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Amount',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                // Data rows (up to 5)
                ...topExpenses.map((expense) {
                  final accountName = expense['accountName'] as String;
                  final currency = expense['currency'] as String;
                  final amount = expense['amount'] as double;
                  final symbol = SupportedCurrency[currency] ?? currency;

                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          accountName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '$symbol ${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
