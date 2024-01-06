import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final AccountService accountService = AccountService();
  final SettingService _settingService = SettingService();
  double balanceAmount = 0.0;
  double debitAmount = 0.0;
  double creditAmount = 0.0;
  double liquidAmount = 0.0;
  String currency = "USD";

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);
    double debit = await accountService.getTotalBalanceByType(AccountType.asset);
    double credit = await accountService.getTotalBalanceByType(AccountType.liability);
    double liquid = await accountService.getTotalLiquidBalance();
    setState(() {
      currency = prefCurrency;
      balanceAmount = (debit - credit);
      creditAmount = credit;
      debitAmount = debit;
      liquidAmount = liquid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: 0,
      color: context.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TotalBalanceWidget(
              currency: currency,
              amount: balanceAmount,
              liquid: liquidAmount,
            ),
            const SizedBox(height: 24),
            TotalCreditDebit(
              currency: currency,
              credit: creditAmount,
              debit: debitAmount,
            ),
          ],
        ),
      ),
    );
  }
}

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({
    super.key,
    required this.currency,
    required this.amount,
    required this.liquid,
  });

  final double amount;
  final double liquid;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final String symbol = SupportedCurrency[currency]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language["totalBalance"],
                    style: context.titleMedium?.copyWith(
                      color: context.onPrimaryContainer.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$symbol ${amount.toStringAsFixed(2)}",
                    style: context.headlineMedium?.copyWith(
                      color: context.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Liquid",
                    style: context.titleMedium?.copyWith(
                      color: context.onPrimaryContainer.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$symbol ${liquid.toStringAsFixed(2)}",
                    style: context.headlineMedium?.copyWith(
                      color: context.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TotalCreditDebit extends StatelessWidget {
  const TotalCreditDebit({
    super.key,
    required this.currency,
    required this.debit,
    required this.credit,
  });

  final String currency;
  final double debit;
  final double credit;

  @override
  Widget build(BuildContext context) {
    String symbol = SupportedCurrency[currency]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▼',
                      style: context.labelLarge?.copyWith(
                        color:
                            Theme.of(context).extension<CustomColors>()!.green,
                      ),
                      children: [
                        TextSpan(
                          text: "Debit",
                          style: context.labelLarge?.copyWith(
                            color: context.onPrimaryContainer.withOpacity(0.75),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '$symbol ${debit.toStringAsFixed(2)}',
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▲',
                      style: context.labelLarge?.copyWith(
                        color: Theme.of(context).extension<CustomColors>()!.red,
                      ),
                      children: [
                        TextSpan(
                          text: "Credit",
                          style: context.labelLarge?.copyWith(
                            color: context.onPrimaryContainer.withOpacity(0.75),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '$symbol ${credit.toStringAsFixed(2)}',
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
