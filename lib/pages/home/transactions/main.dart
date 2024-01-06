import 'package:finease/db/entries.dart';
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
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    List<Entry> entriesList = await EntryService().getAllEntries();
    setState(() {
      entries = entriesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: entries.map((e) => Container()).toList(),
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          await context.pushNamed(RoutesName.addAccount.name);
          loadEntries();
        },
        icon: Icons.add,
      ),
    );
  }
}
