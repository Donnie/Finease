import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accounts,
  });

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ...accounts.map((ac) => AccountWidget(account: ac)),
        ],
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    final String symbol = SupportedCurrency[account.currency]!;
    final bool green =
        [AccountType.asset, AccountType.income].contains(account.type);

    return AspectRatio(
      aspectRatio: 16 / 4,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            // show transactions
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  
                  leading: Icon(
                    green ? MdiIcons.arrowBottomLeft : MdiIcons.arrowTopRight,
                    color: green ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    account.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    account.liquid
                        ? Icons.invert_colors
                        : Icons.invert_colors_off,
                  ),
                ),
                Divider(color: green ? Colors.green : Colors.red),
                Expanded(
                  child: Text(
                    '$symbol ${account.balance / 100}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
