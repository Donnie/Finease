import 'package:finease/db/entries.dart';
import 'package:finease/pages/export.dart';
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
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
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
        child: EntriesListView(
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
        ),
        icon: Icons.add,
      ),
    );
  }
}
