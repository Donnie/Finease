import 'package:finease/db/accounts.dart';
import 'package:finease/pages/home/accounts/account_card.dart';
import 'package:finease/parts/variable_fab_size.dart';
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
    List<Account> accountsList = await AccountService().getAllAccounts(false);
    setState(() {
      accounts = accountsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: accounts.map((a) => AccountWidget(account: a)).toList(),
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          await context.pushNamed(
            RoutesName.addAccount.name,
            extra: loadAccounts,
          );
        },
        icon: Icons.add,
      ),
    );
  }
}
