import 'package:finease/core/extensions/color_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

    return AppCard(
      elevation: 0,
      color: context.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                account.liquid ? Icons.invert_colors : Icons.invert_colors_off,
              ),
            ),
            Divider(color: green ? Colors.green : Colors.red),
            Flexible(
              child: Text(
                '$symbol ${account.balance / 100}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
