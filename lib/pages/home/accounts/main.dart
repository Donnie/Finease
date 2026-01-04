import 'package:finease/db/accounts.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({
    super.key,
  });

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    List<Account> accountsList = await AccountService().getAllAccounts();
    accountsList.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      accounts = accountsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: infoBar(context, "accounts",
          "Click to see transactions,\nand long press to edit the account.\n\nUse the + button at the bottom to add a new account."),
      body: RefreshIndicator(
        onRefresh: loadAccounts,
        child: BankAccounts(
          accounts: accounts,
          onEdit: loadAccounts,
        ),
      ),
      drawer: AppDrawer(
        onRefresh: loadAccounts,
        scaffoldKey: _scaffoldStateKey,
        destinations: destinations,
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          final result = await context.pushNamed(RoutesName.addAccount.name);
          if (result != null) {
            loadAccounts();
          }
        },
        icon: Icons.add,
      ),
    );
  }
}
