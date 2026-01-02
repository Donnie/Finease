import 'dart:async';
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
import 'package:intl/intl.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  List<Entry> entries = [];
  String? prefCurrency;

  @override
  void initState() {
    super.initState();
    loadEntries();
    _loadPreferredCurrency();
    _searchController.addListener(() {
      _searchNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchNotifier.dispose();
    super.dispose();
  }

  List<Entry> get filteredEntries {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return entries;
    }
    
    return entries.where((entry) {
      final fromAccount = entry.debitAccount?.name ?? '';
      final toAccount = entry.creditAccount?.name ?? '';
      final notes = entry.notes ?? '';
      final dateStr = entry.date != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(entry.date!)
          : '';
      
      return fromAccount.toLowerCase().contains(query) ||
          toAccount.toLowerCase().contains(query) ||
          notes.toLowerCase().contains(query) ||
          dateStr.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildSearchField() {
    return ValueListenableBuilder<String>(
      valueListenable: _searchNotifier,
      builder: (context, searchValue, child) {
        return TextField(
          key: const Key('search_field'),
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            // ValueNotifier will trigger rebuild of ValueListenableBuilder
            // but TextField itself maintains focus
          },
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchValue.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadPreferredCurrency() async {
    final currency = await _settingService.getSetting(Setting.prefCurrency);
    setState(() {
      prefCurrency = currency;
    });
  }

  Future<void> loadEntries() async {
    // Use the improved merging algorithm from EntryService
    List<Entry> mergedEntries = await _entryService.getMergedEntries(
      startDate: widget.startDate,
      endDate: widget.endDate,
      accountId: widget.accountID,
    );

    // Update state
    setState(() {
      entries = mergedEntries;
    });
  }

  List<Map<String, dynamic>> getTopExpenses() {
    // Filter expense entries by preferred currency
    final expenseEntries = filteredEntries.where((entry) =>
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
      appBar: infoBar(
        context,
        "transactions",
        "Click to edit the transaction,\nand long press to duplicate the transaction.\nTap the delete icon to remove a transaction.\nUse the search field to find transactions.\n\nUse the + button at the bottom to add a new transaction.",
      ),
      body: RefreshIndicator(
        onRefresh: loadEntries,
        child: widget.startDate != null && widget.endDate != null
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Search input
                          _buildSearchField(),
                          const SizedBox(height: 8),
                          // Top Expenses Card
                          TopExpensesCard(topExpenses: getTopExpenses()),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: _searchNotifier,
                    builder: (context, searchValue, child) {
                      final filtered = filteredEntries;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return EntryCard(
                              entry: filtered[index],
                              onDelete: entryOnDelete,
                              onCardTap: loadEntries,
                            );
                          },
                          childCount: filtered.length,
                        ),
                      );
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  // Search input for non-date-filtered view
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSearchField(),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _searchNotifier,
                      builder: (context, searchValue, child) {
                        return EntriesListView(
                          entries: filteredEntries,
                          onDelete: entryOnDelete,
                          onEdit: loadEntries,
                        );
                      },
                    ),
                  ),
                ],
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
