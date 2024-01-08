import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class NetWorthCard extends StatefulWidget {
  const NetWorthCard({super.key});

  @override
  State<NetWorthCard> createState() => _NetWorthCardState();
}

class _NetWorthCardState extends State<NetWorthCard> {
  final AccountService accountService = AccountService();
  final SettingService _settingService = SettingService();
  double networthAmount = 0.0;
  double assetAmount = 0.0;
  double liabilitiesAmount = 0.0;
  double liquidAmount = 0.0;
  String currency = "USD";

  @override
  void initState() {
    super.initState();
    _fetchNetWorth();
  }

  Future<void> _fetchNetWorth() async {
    String prefCurrency =
        await _settingService.getSetting(Setting.prefCurrency);
    double asset = await accountService.getTotalBalance(type: AccountType.asset);
    double liabilities = await accountService.getTotalBalance(type: AccountType.liability);
    double liquid = await accountService.getTotalBalance(liquid: true);
    setState(() {
      currency = prefCurrency;
      networthAmount = (asset + liabilities);
      liabilitiesAmount = liabilities;
      assetAmount = asset;
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
            TotalNetWorthWidget(
              currency: currency,
              amount: networthAmount,
              liquid: liquidAmount,
            ),
            const SizedBox(height: 24),
            TotalLiabilitiesAsset(
              currency: currency,
              liabilities: liabilitiesAmount,
              asset: assetAmount,
            ),
          ],
        ),
      ),
    );
  }
}

class TotalNetWorthWidget extends StatelessWidget {
  const TotalNetWorthWidget({
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
                    "Net Worth",
                    style: context.titleMedium?.copyWith(
                      color: context.onPrimaryContainer.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$symbol $amount",
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
                    "$symbol $liquid",
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

class TotalLiabilitiesAsset extends StatelessWidget {
  const TotalLiabilitiesAsset({
    super.key,
    required this.currency,
    required this.asset,
    required this.liabilities,
  });

  final String currency;
  final double asset;
  final double liabilities;

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
                          text: "Assets",
                          style: context.labelLarge?.copyWith(
                            color: context.onPrimaryContainer.withOpacity(0.75),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '$symbol $asset',
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
                          text: "Liabilities",
                          style: context.labelLarge?.copyWith(
                            color: context.onPrimaryContainer.withOpacity(0.75),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '$symbol ${(liabilities * -1)}',
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
