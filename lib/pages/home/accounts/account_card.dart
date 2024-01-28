import 'package:finease/core/extensions/color_extension.dart';
import 'package:finease/core/extensions/text_style_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BankAccounts extends StatelessWidget {
  const BankAccounts({
    super.key,
    required this.accounts,
    required this.onEdit,
  });

  final List<Account> accounts;
  final Future<void> Function() onEdit;

  @override
  Widget build(BuildContext context) {
    List<Account> mainAccounts = accounts
        .where((a) => [
              AccountType.asset,
              AccountType.liability,
            ].contains(a.type))
        .where((a) => !a.hidden)
        .toList();

    List<Account> extAccounts = accounts
        .where((a) => [
              AccountType.income,
              AccountType.expense,
            ].contains(a.type))
        .where((a) => !a.hidden)
        .toList();

    List<Account> hiddenAccounts = accounts.where((a) => a.hidden).toList();

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Assets and Liabilities"),
        ),
        Visibility(
          visible: mainAccounts.isEmpty,
          child: const Center(
            child: Text('Accounts yet to be set up'),
          ),
        ),
        ...mainAccounts.map(
          (a) => BankAccountCardClickable(
            account: a,
            onTap: () => context.pushNamed(
              RoutesName.editAccount.name,
              pathParameters: {'id': a.id.toString()},
              extra: onEdit,
            ),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Incomes and Expenses"),
        ),
        Visibility(
          visible: extAccounts.isEmpty,
          child: const Center(
            child: Text('Accounts yet to be set up'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              ...extAccounts.map(
                (a) => BankAccountChipClickable(
                  account: a,
                  onTap: () => context.pushNamed(
                    RoutesName.editAccount.name,
                    pathParameters: {'id': a.id.toString()},
                    extra: onEdit,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Hidden Accounts"),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              ...hiddenAccounts.map(
                (a) => BankAccountChipClickable(
                  account: a,
                  onTap: () => context.pushNamed(
                    RoutesName.editAccount.name,
                    pathParameters: {'id': a.id.toString()},
                    extra: onEdit,
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

class BankAccountCardClickable extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;

  const BankAccountCardClickable({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BankAccountCard(account: account),
    );
  }
}

class BankAccountCard extends StatelessWidget {
  final Account account;

  const BankAccountCard({
    super.key,
    required this.account,
  });

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
                  "$symbol${account.balance.toStringAsFixed(2)}",
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

class BankAccountChipClickable extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;

  const BankAccountChipClickable({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BankAccountChip(account: account),
    );
  }
}

class BankAccountChip extends StatelessWidget {
  final Account account;

  const BankAccountChip({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: account.hidden
          ? const EdgeInsets.all(6.0)
          : const EdgeInsets.all(12.0),
      avatar: Text(
        SupportedCurrency[account.currency]!,
        style: context.bodyLarge,
      ),
      label: Text(account.name, style: context.bodyLarge),
      shape: RoundedRectangleBorder(
        borderRadius: account.hidden
            ? BorderRadius.circular(14)
            : BorderRadius.circular(28),
        side: BorderSide(
          width: 1,
          color: context.primary,
        ),
      ),
    );
  }
}
