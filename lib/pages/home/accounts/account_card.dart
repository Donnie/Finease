import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:intl/intl.dart';
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
    final DateFormat dateFormat = DateFormat.yMMM();
    final String symbol = SupportedCurrency[account.currency]!;

    return AspectRatio(
      aspectRatio: 16 / 5,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            // show transactions
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    (account.type == AccountType.asset ||
                            account.type == AccountType.income)
                        ? MdiIcons.arrowBottomLeft
                        : MdiIcons.arrowTopRight,
                    color: (account.type == AccountType.asset ||
                            account.type == AccountType.income)
                        ? Colors.green
                        : Colors.red,
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
                Divider(
                    color: (account.type == AccountType.asset ||
                            account.type == AccountType.income)
                        ? Colors.green
                        : Colors.red),
                Expanded(
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    children: [
                      Text(
                        '$symbol ${account.balance}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      infoTile(
                        'Created At',
                        dateFormat.format(account.createdAt!),
                        Theme.of(context).textTheme.bodyMedium,
                      ),
                      infoTile(
                        'Updated At',
                        dateFormat.format(account.updatedAt!),
                        Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoTile(String? title, dynamic value, TextStyle? textStyle,
      {bool isIcon = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? ""),
        isIcon
            ? Icon(value as IconData)
            : Text(
                value.toString(),
                style: textStyle ?? const TextStyle(fontSize: 12),
              ),
      ],
    );
  }
}
