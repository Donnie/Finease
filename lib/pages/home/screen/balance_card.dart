import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/accounts.dart';
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
  String currency = "USD";

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    String prefCurrency = await _settingService.getSetting(Setting.prefCurrency);
    double fetchedAmount = await accountService.getTotalBalance();
    setState(() {
      currency = prefCurrency;
      balanceAmount = fetchedAmount;
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
              title: language["totalBalance"],
              currency: currency,
              amount: balanceAmount, // Use the fetched balance amount
            ),
            const SizedBox(height: 24),
            const TotalCreditDebit(
              credit: 42109,
              debit: 102231.12,
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
    required this.title,
    required this.amount,
  });

  final double amount;
  final String title;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleMedium?.copyWith(
            color: context.onPrimaryContainer.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$currency ${amount.toStringAsFixed(2)}",
          style: context.headlineMedium?.copyWith(
            color: context.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class TotalCreditDebit extends StatelessWidget {
  const TotalCreditDebit({
    super.key,
    required this.debit,
    required this.credit,
  });

  final double debit;
  final double credit;

  @override
  Widget build(BuildContext context) {
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
                    '\$ $debit',
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    '\$ $credit',
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
