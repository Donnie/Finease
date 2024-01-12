import 'package:finease/core/extensions/color_extension.dart';
import 'package:finease/core/extensions/text_style_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BankAccounts extends StatelessWidget {
  const BankAccounts({
    super.key,
    required this.accounts,
  });

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    List<Account> mainAccounts = accounts
        .where((a) => [
              AccountType.asset,
              AccountType.liability,
            ].contains(a.type))
        .toList();

    List<Account> extAccounts = accounts
        .where((a) => [
              AccountType.income,
              AccountType.expense,
            ].contains(a.type))
        .toList();

    return ListView(
      children: [
        ...mainAccounts.map((a) => BankAccountCard(account: a)),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              ...extAccounts.map(
                (account) => Chip(
                  padding: const EdgeInsets.all(12.0),
                  avatar: Text(
                    SupportedCurrency[account.currency]!,
                    style: context.bodyLarge,
                  ),
                  label: Text(account.name),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      width: 1,
                      color: context.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BankAccountCard extends StatelessWidget {
  final Account account;

  const BankAccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final String symbol = SupportedCurrency[account.currency]!;
    final bool green =
        [AccountType.asset, AccountType.income].contains(account.type);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(account.name),
                Row(
                  children: [
                    Icon(
                      green ? MdiIcons.arrowBottomLeft : MdiIcons.arrowTopRight,
                      color: green ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 16),
                    Text(account.currency),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16.0),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$symbol ${account.balance.toStringAsFixed(2)}",
                  style: context.titleLarge,
                ),
                Row(
                  children: [
                    Chip(
                      label: Text(account.type.name),
                      backgroundColor:
                          context.secondaryContainer.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: BorderSide(
                          width: 1,
                          color: context.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(
                      account.liquid
                          ? Icons.invert_colors
                          : Icons.invert_colors_off,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
