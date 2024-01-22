import 'package:finease/core/export.dart';
import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/card.dart';
import 'package:fl_chart/fl_chart.dart';
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
    final String symbol = SupportedCurrency[currency]!;

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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Net Worth",
                            style: context.titleMedium?.copyWith(
                              color:
                                  context.onPrimaryContainer.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$symbol${networthAmount.toStringAsFixed(2)}",
                            style: context.headlineMedium?.copyWith(
                              color: context.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Liquid",
                            style: context.titleMedium?.copyWith(
                              color:
                                  context.onPrimaryContainer.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$symbol${liquidAmount.toStringAsFixed(2)}",
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: assetAmount,
                              title: '${(100*(networthAmount/assetAmount)).toStringAsFixed(0)}%',
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: liabilitiesAmount * -1,
                              title: '${(100*(liabilitiesAmount * -1)/assetAmount).toStringAsFixed(0)}%',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Column(
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
                                color: Theme.of(context)
                                    .extension<CustomColors>()!
                                    .green,
                              ),
                              children: [
                                TextSpan(
                                  text: "Assets",
                                  style: context.labelLarge?.copyWith(
                                    color: context.onPrimaryContainer
                                        .withOpacity(0.75),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '$symbol${assetAmount.toStringAsFixed(2)}',
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
                                color: Theme.of(context)
                                    .extension<CustomColors>()!
                                    .red,
                              ),
                              children: [
                                TextSpan(
                                  text: "Liabilities",
                                  style: context.labelLarge?.copyWith(
                                    color: context.onPrimaryContainer
                                        .withOpacity(0.75),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '$symbol${(liabilitiesAmount * -1).toStringAsFixed(2)}',
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
            ),
          ],
        ),
      ),
    );
  }
}
