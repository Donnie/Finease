import 'package:finease/db/entries.dart';
import 'package:finease/pages/home/entries/entry_card.dart';
import 'package:finease/parts/variable_fab_size.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntriesPage extends StatefulWidget {
  const EntriesPage({
    super.key,
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
    List<Entry> entriesList = await _entryService.getAllEntries();
    entriesList.sort((a, b) => (b.date!.compareTo(a.date!)));

    List<Entry> mergedEntries = [];
    for (int i = 0; i < entriesList.length; i++) {
      Entry creditEntry = entriesList[i];
      bool merged = false;

      // Check if the next entry exists and if it's within a 1-second interval
      if (i < entriesList.length - 1) {
        Entry debitEntry = entriesList[i + 1];
        if (creditEntry.date!.difference(debitEntry.date!).inSeconds <= 0.5 &&
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
    return Scaffold(
      body: ListView(
        children: entries
            .map((e) => EntryCard(
                  entry: e,
                  onDelete: (int id) {
                    _entryService.deleteEntry(id);
                    loadEntries();
                  },
                ))
            .toList(),
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          await context.pushNamed(
            RoutesName.addEntry.name,
            extra: loadEntries,
          );
        },
        icon: Icons.add,
      ),
    );
  }
}
