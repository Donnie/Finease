import 'dart:ui';
import 'package:finease/core/export.dart';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    final blur = context.watch<GlassmorphicBlurProvider>().blurAmount;

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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      context.surface.withOpacity(opacity * 0.8),
                      context.surface.withOpacity(opacity * 0.4),
                      context.surface.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                    radius: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text("Assets and Liabilities"),
              ),
            ),
          ),
        ),
        Visibility(
          visible: mainAccounts.isEmpty,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        context.surface.withOpacity(opacity * 0.8),
                        context.surface.withOpacity(opacity * 0.4),
                        context.surface.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                      radius: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text('Accounts yet to be set up'),
                ),
              ),
            ),
          ),
        ),
        ...mainAccounts.map(
          (a) => BankAccountCardClickable(
            account: a,
            onLongPress: () async {
              final result = await context.pushNamed(
                RoutesName.editAccount.name,
                pathParameters: {'id': a.id.toString()},
              );
              if (result == true) {
                onEdit();
              }
            },
            onTap: () async {
              await context.pushNamed(
                RoutesName.transactionsByAccount.name,
                pathParameters: {RoutesName.transactionsByAccount.accountParam: a.id.toString()},
              );
              // Refresh accounts when returning from transaction screen
              onEdit();
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      context.surface.withOpacity(opacity * 0.8),
                      context.surface.withOpacity(opacity * 0.4),
                      context.surface.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                    radius: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text("Incomes and Expenses"),
              ),
            ),
          ),
        ),
        Visibility(
          visible: extAccounts.isEmpty,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        context.surface.withOpacity(opacity * 0.8),
                        context.surface.withOpacity(opacity * 0.4),
                        context.surface.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                      radius: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text('Accounts yet to be set up'),
                ),
              ),
            ),
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
                  onLongPress: () => context.pushNamed(
                    RoutesName.editAccount.name,
                    pathParameters: {'id': a.id.toString()},
                    extra: onEdit,
                  ),
                  onTap: () async {
                    await context.pushNamed(
                      RoutesName.transactionsByAccount.name,
                      pathParameters: {RoutesName.transactionsByAccount.accountParam: a.id.toString()},
                    );
                    // Refresh accounts when returning from transaction screen
                    onEdit();
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      context.surface.withOpacity(opacity * 0.8),
                      context.surface.withOpacity(opacity * 0.4),
                      context.surface.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                    radius: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text("Hidden Accounts"),
              ),
            ),
          ),
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
                  onLongPress: () => context.pushNamed(
                    RoutesName.editAccount.name,
                    pathParameters: {'id': a.id.toString()},
                    extra: onEdit,
                  ),
                  onTap: () async {
                    await context.pushNamed(
                      RoutesName.transactionsByAccount.name,
                      pathParameters: {RoutesName.transactionsByAccount.accountParam: a.id.toString()},
                    );
                    // Refresh accounts when returning from transaction screen
                    onEdit();
                  },
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
  final VoidCallback? onLongPress;

  const BankAccountCardClickable({
    super.key,
    required this.account,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
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
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    final blur = context.watch<GlassmorphicBlurProvider>().blurAmount;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: context.surface.withOpacity(opacity),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: context.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: context.shadow.withOpacity(0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
      ),
    );
  }
}

class BankAccountChipClickable extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BankAccountChipClickable({
    super.key,
    required this.account,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
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
