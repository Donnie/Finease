import 'package:finease/core/export.dart';
import 'package:finease/core/theme/custom_color.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/months.dart';
import 'package:finease/parts/card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                              value: networthAmount,
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

class NetWorthGraphCard extends StatelessWidget {
  final List<Month> months;
  final String currency;
  final double currentNetWorth;

  const NetWorthGraphCard({
    super.key,
    required this.months,
    required this.currency,
    required this.currentNetWorth,
  });

  @override
  Widget build(BuildContext context) {
    final String symbol = SupportedCurrency[currency]!;
    
    if (months.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort months by date (oldest first)
    final sortedMonths = List<Month>.from(months)
      ..sort((a, b) => (a.date ?? DateTime.now())
          .compareTo(b.date ?? DateTime.now()));

    final List<FlSpot> spots = [];
    final List<String> monthLabels = [];
    
    // Add actual data points
    for (int i = 0; i < sortedMonths.length; i++) {
      final month = sortedMonths[i];
      if (month.date != null && month.networth != null) {
        spots.add(FlSpot(i.toDouble(), month.networth!.toDouble()));
        final dateFormat = DateFormat('MMM yyyy');
        monthLabels.add(dateFormat.format(month.date!));
      }
    }

    // Find min and max for y-axis
    double minY = spots.isNotEmpty ? spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) : 0;
    double maxY = spots.isNotEmpty ? spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) : 1000;
    
    // Add some padding
    minY = minY * 0.9;
    maxY = maxY * 1.1;

    return AppCard(
      elevation: 0,
      color: context.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Net Worth Over Time",
              style: context.titleMedium?.copyWith(
                color: context.onPrimaryContainer.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: context.onSurface.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: (maxY - minY) / 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '$symbol${(value / 1000).toStringAsFixed(0)}k',
                            style: context.bodySmall?.copyWith(
                              color: context.onSurface.withOpacity(0.6),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: context.onSurface.withOpacity(0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: spots.isNotEmpty ? spots.last.x : 10,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: context.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: spots.length <= 12, // Only show dots if not too many points
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: context.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final index = touchedSpot.x.toInt();
                          return LineTooltipItem(
                            '$symbol${touchedSpot.y.toStringAsFixed(2)}\n${monthLabels[index]}',
                            (context.bodyMedium ?? const TextStyle()).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
