import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/pages/home/accounts/account_card.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

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
    List<Account> accountsList = await AccountService().getAllAccounts();
    setState(() {
      accounts = accountsList;
    });

  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: IndexedStack(
          children: [
            AccountCard(
              accounts: accounts,
            ),
          ],
        ),
      ),
    );
  }
}
