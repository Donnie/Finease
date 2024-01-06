import 'package:finease/core/common.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: IndexedStack(
          children: [
            AccountCard(),
          ],
        ),
      ),
    );
  }
}
