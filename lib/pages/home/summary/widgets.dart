import 'package:finease/core/common.dart';
import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';

class NetWorthCard extends StatelessWidget {
  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;

  const NetWorthCard({
    super.key,
    required this.networthAmount,
    required this.assetAmount,
    required this.liabilitiesAmount,
    required this.liquidAmount,
    required this.currency,
  });

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
                    "$symbol${amount.toStringAsFixed(2)}",
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
                    "$symbol$liquid",
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
                    '$symbol$asset',
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
                    '$symbol${(liabilities * -1)}',
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
