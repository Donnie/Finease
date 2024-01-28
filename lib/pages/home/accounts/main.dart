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
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    List<Account> accountsList = await AccountService().getAllAccounts(true);
    accountsList.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      accounts = accountsList;
    });
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

    return Scaffold(
      key: scaffoldStateKey,
      appBar: appBar(context, "accounts"),
      body: RefreshIndicator(
        onRefresh: loadAccounts,
        child: BankAccounts(
          accounts: accounts,
          onEdit: loadAccounts,
        ),
      ),
      drawer: AppDrawer(
        onRefresh: loadAccounts,
        scaffoldKey: scaffoldStateKey,
        selectedIndex: 1,
        destinations: destinations,
        onDestinationSelected: updateBody,
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () => context.pushNamed(
          RoutesName.addAccount.name,
          extra: (Account ac) => loadAccounts(),
        ),
        icon: Icons.add,
      ),
    );
  }
}
