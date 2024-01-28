import 'package:finease/db/currency.dart';
import 'package:finease/db/months.dart';
import 'package:finease/parts/card.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

DateFormat formatter = DateFormat('MMMM yyyy');

class MonthCards extends StatelessWidget {
  final List<Month> months;
  final bool isLoading;
  final double networth;

  const MonthCards({
    super.key,
    required this.months,
    this.isLoading = false,
    required this.networth,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (months.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    String currency = SupportedCurrency[months[0].currency!]!;
    double unrealised = (networth- (months[0].networth ?? 0));
    bool showUnrealised = unrealised.round().abs() > 0;
    String gains = (unrealised > 0) ? "gains" : "losses";

    return SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible: showUnrealised,
            child: Center(
              child: Text(
                'Unrealised $gains: $currency${unrealised.toStringAsFixed(2)}',
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: months.length,
            itemBuilder: (context, index) => MonthCard(
              month: months[index],
            ),
          ),
        ],
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  const MonthCard({
    super.key,
    required this.month,
  });

  final Month month;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = month.date!;
    DateTime endDate = DateTime(month.date!.year, month.date!.month + 1, 1)
        .subtract(const Duration(seconds: 1));
    String currency = SupportedCurrency[month.currency!]!;
    String networth = '$currency${month.networth!.toStringAsFixed(2)}';
    String effect = '$currency${month.effect!.toStringAsFixed(2)}';
    String income = '$currency${month.income!.toStringAsFixed(2)}';
    String expense = '$currency${month.expense!.toStringAsFixed(2)}';

    return InkWell(
      onTap: () {
        context.pushNamed(
          RoutesName.transactionsByDate.name,
          extra: {
            'startDate': startDate.toIso8601String(),
            'endDate': endDate.toIso8601String(),
          },
        );
      },
      child: AppCard(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    formatter.format(month.date!),
                    style: context.titleSmall,
                  )
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: month.factor,
                minHeight: 2.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  month.good ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: MonthWidget(
                      title: "Net Worth",
                      content: networth,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MonthWidget(
                      title: "Effect",
                      content: effect,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: MonthWidget(
                      title: "Income",
                      content: income,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MonthWidget(
                      title: "Expense",
                      content: expense,
                    ),
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

class MonthWidget extends StatelessWidget {
  const MonthWidget({
    super.key,
    required this.title,
    required this.content,
  });

  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(
          content,
          style: context.titleLarge,
        ),
      ],
    );
  }
}
