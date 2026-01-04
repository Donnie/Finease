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
import 'package:flutter/services.dart';
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
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  List<Entry> entries = [];
  String? prefCurrency;
  Account? viewingAccount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadEntries();
    _loadPreferredCurrency();
    _loadViewingAccount();
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

  Future<void> _loadViewingAccount() async {
    if (widget.accountID != null) {
      final account = await _accountService.getAccount(widget.accountID!);
      setState(() {
        viewingAccount = account;
      });
    }
  }

  Future<void> loadEntries() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Use the improved merging algorithm from EntryService
      List<Entry> mergedEntries = await _entryService.getMergedEntries(
        startDate: widget.startDate,
        endDate: widget.endDate,
        accountId: widget.accountID,
      );

      // Update state
      if (mounted) {
        setState(() {
          entries = mergedEntries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  String _formatTransactionsForExport(List<Entry> entriesToExport) {
    if (entriesToExport.isEmpty) {
      return 'No transactions to export.';
    }

    // Calculate maximum column widths
    int maxDateWidth = 'Date'.length;
    int maxFromWidth = 'From'.length;
    int maxToWidth = 'To'.length;
    int maxAmountWidth = 'Amount'.length;
    
    final formattedRows = <Map<String, String>>[];
    
    for (var entry in entriesToExport) {
      final date = entry.date != null 
          ? DateFormat('yyyy-MM-dd HH:mm').format(entry.date!)
          : 'N/A';
      final from = entry.debitAccount?.name ?? 'N/A';
      final to = entry.creditAccount?.name ?? 'N/A';
      final notes = entry.notes ?? '';
      final symbol = SupportedCurrency[entry.debitAccount?.currency ?? ''] ?? '';
      final amountStr = '$symbol ${entry.amount}';
      
      maxDateWidth = maxDateWidth > date.length ? maxDateWidth : date.length;
      maxFromWidth = maxFromWidth > from.length ? maxFromWidth : from.length;
      maxToWidth = maxToWidth > to.length ? maxToWidth : to.length;
      maxAmountWidth = maxAmountWidth > amountStr.length ? maxAmountWidth : amountStr.length;
      
      formattedRows.add({
        'date': date,
        'from': from,
        'to': to,
        'amount': amountStr,
        'notes': notes,
      });
    }
    
    // Add padding (2 spaces between columns)
    final dateColWidth = maxDateWidth + 2;
    final fromColWidth = maxFromWidth + 2;
    final toColWidth = maxToWidth + 2;
    final amountColWidth = maxAmountWidth + 2;
    
    final totalWidth = dateColWidth + fromColWidth + toColWidth + amountColWidth + 5;

    final buffer = StringBuffer();
    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    
    buffer.writeln('Transactions Export');
    buffer.writeln('Exported: $now');
    buffer.writeln('');
    
    // Header
    buffer.writeln('${'Date'.padRight(dateColWidth)}${'From'.padRight(fromColWidth)}${'To'.padRight(toColWidth)}${'Amount'.padRight(amountColWidth)}Notes');
    buffer.writeln('=' * totalWidth);
    
    // Data rows
    for (var row in formattedRows) {
      buffer.writeln('${row['date']!.padRight(dateColWidth)}${row['from']!.padRight(fromColWidth)}${row['to']!.padRight(toColWidth)}${row['amount']!.padRight(amountColWidth)}${row['notes']}');
    }
    
    buffer.writeln('=' * totalWidth);
    buffer.writeln('Total: ${entriesToExport.length} transactions');
    
    return buffer.toString();
  }

  Future<void> _exportToClipboard() async {
    // If viewing a specific account, use SQL-based export with balance
    if (widget.accountID != null && viewingAccount != null) {
      await _exportAccountTransactionsWithBalance();
    } else {
      // Regular export without balance
      final entriesToExport = filteredEntries;
      final exportText = _formatTransactionsForExport(entriesToExport);
      
      await Clipboard.setData(ClipboardData(text: exportText));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${entriesToExport.length} transactions copied to clipboard'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAccountTransactionsWithBalance() async {
    final entriesWithBalance = await _entryService.getEntriesWithBalance(
      accountId: widget.accountID!,
      startDate: widget.startDate,
      endDate: widget.endDate,
    );
    
    // Apply search filter if active
    final searchQuery = _searchController.text.toLowerCase();
    final filteredData = searchQuery.isEmpty
        ? entriesWithBalance
        : entriesWithBalance.where((row) {
            final fromAccount = row['debit_account_name'] as String? ?? '';
            final toAccount = row['credit_account_name'] as String? ?? '';
            final userNotes = row['user_notes'] as String? ?? '';
            final dateStr = row['date'] != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(row['date'] as String))
                : '';
            
            return fromAccount.toLowerCase().contains(searchQuery) ||
                toAccount.toLowerCase().contains(searchQuery) ||
                userNotes.toLowerCase().contains(searchQuery) ||
                dateStr.toLowerCase().contains(searchQuery);
          }).toList();
    
    if (filteredData.isEmpty) {
      await Clipboard.setData(const ClipboardData(text: 'No transactions to export.'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No transactions to export'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    
    final symbol = SupportedCurrency[viewingAccount!.currency] ?? viewingAccount!.currency;
    
    // Calculate maximum column widths
    int maxDateWidth = 'Date'.length;
    int maxFromWidth = 'From'.length;
    int maxToWidth = 'To'.length;
    int maxAmountWidth = 'Amount'.length;
    int maxBalanceWidth = 'Balance'.length;
    
    final formattedRows = <Map<String, String>>[];
    
    for (var row in filteredData) {
      final date = row['date'] != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(row['date'] as String))
          : 'N/A';
      final from = row['debit_account_name'] as String? ?? 'N/A';
      final to = row['credit_account_name'] as String? ?? 'N/A';
      final userNotes = row['user_notes'] as String? ?? '';
      final amount = (row['amount'] as int) / 100.0;
      final balance = (row['running_balance'] as int) / 100.0;
      final isForex = (row['is_forex'] as int) == 1;
      
      // Format notes like _mergeForexEntries: "user_notes (CreditCurrencySymbol+CreditAmount)"
      String notes;
      if (isForex) {
        final creditAmount = (row['credit_amount'] as int) / 100.0;
        final creditCurrency = row['credit_currency'] as String;
        final creditSymbol = SupportedCurrency[creditCurrency] ?? creditCurrency;
        final creditInfo = '$creditSymbol$creditAmount';
        
        notes = (userNotes.isNotEmpty) 
            ? '$userNotes ($creditInfo)'
            : creditInfo;
      } else {
        notes = userNotes;
      }
      
      final amountStr = '$symbol $amount';
      final balanceStr = '$symbol $balance';
      
      maxDateWidth = maxDateWidth > date.length ? maxDateWidth : date.length;
      maxFromWidth = maxFromWidth > from.length ? maxFromWidth : from.length;
      maxToWidth = maxToWidth > to.length ? maxToWidth : to.length;
      maxAmountWidth = maxAmountWidth > amountStr.length ? maxAmountWidth : amountStr.length;
      maxBalanceWidth = maxBalanceWidth > balanceStr.length ? maxBalanceWidth : balanceStr.length;
      
      formattedRows.add({
        'date': date,
        'from': from,
        'to': to,
        'amount': amountStr,
        'balance': balanceStr,
        'notes': notes,
      });
    }
    
    // Add padding (2 spaces between columns)
    final dateColWidth = maxDateWidth + 2;
    final fromColWidth = maxFromWidth + 2;
    final toColWidth = maxToWidth + 2;
    final amountColWidth = maxAmountWidth + 2;
    final balanceColWidth = maxBalanceWidth + 2;
    
    final totalWidth = dateColWidth + fromColWidth + toColWidth + amountColWidth + balanceColWidth + 5;
    
    final buffer = StringBuffer();
    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    
    buffer.writeln('Transactions Export');
    buffer.writeln('Exported: $now');
    buffer.writeln('Account: ${viewingAccount!.name} ($symbol)');
    buffer.writeln('');
    
    // Header
    buffer.writeln('${'Date'.padRight(dateColWidth)}${'From'.padRight(fromColWidth)}${'To'.padRight(toColWidth)}${'Amount'.padRight(amountColWidth)}${'Balance'.padRight(balanceColWidth)}Notes');
    buffer.writeln('=' * totalWidth);
    
    // Data rows
    for (var row in formattedRows) {
      buffer.writeln('${row['date']!.padRight(dateColWidth)}${row['from']!.padRight(fromColWidth)}${row['to']!.padRight(toColWidth)}${row['amount']!.padRight(amountColWidth)}${row['balance']!.padRight(balanceColWidth)}${row['notes']}');
    }
    
    buffer.writeln('=' * totalWidth);
    buffer.writeln('Total: ${filteredData.length} transactions');
    
    final finalBalance = (filteredData.last['running_balance'] as int) / 100.0;
    buffer.writeln('Final Balance: $symbol $finalBalance');
    
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${filteredData.length} transactions copied to clipboard'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        additionalActions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'export') {
                _exportToClipboard();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.copy),
                    const SizedBox(width: 12),
                    Text(_searchController.text.isNotEmpty 
                        ? 'Copy Filtered (${filteredEntries.length})'
                        : 'Copy All (${filteredEntries.length})'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadEntries,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.startDate != null && widget.endDate != null
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
