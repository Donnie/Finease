import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
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
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
    loadEntries();
  }

  Future<void> loadEntries() async {
    List<Entry> entriesList = await EntryService().getAllEntries();
    setState(() {
      entries = entriesList;
    });
  }

  Future<void> loadAccounts() async {
    List<Account> accountsList = await AccountService().getAllAccounts();
    setState(() {
      accounts = accountsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: entries
            .map((e) => EntryCard(
                  entry: e,
                  accounts: accounts,
                ))
            .toList(),
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

class EntryCard extends StatelessWidget {
  final Entry entry;
  final List<Account> accounts;

  const EntryCard({
    Key? key,
    required this.entry,
    required this.accounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account creditAccount =
        accounts.firstWhere((a) => a.id == entry.creditAccountId);
    final debitAccount =
        accounts.firstWhere((a) => (a.id! == entry.debitAccountId));
    final String symbol = SupportedCurrency[debitAccount.currency]!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Entry ID: ${entry.id}', style: const TextStyle(fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Debit Account: ${debitAccount.name}'),
                Text('Credit Account: ${creditAccount.name}'),
              ],
            ),
            Text('Amount: $symbol ${entry.amount}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Date: ${entry.date}'),
            const SizedBox(height: 4),
            Text('Notes: ${entry.notes}',
                style:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
