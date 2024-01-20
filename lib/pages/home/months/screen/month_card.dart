import 'package:finease/db/months.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';
import 'package:intl/intl.dart';

DateFormat formatter = DateFormat('MMMM yyyy');

class MonthCards extends StatelessWidget {
  final List<Month> months;

  const MonthCards({
    super.key,
    required this.months,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) => MonthCard(
        month: months[index],
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
    return AppCard(
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
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: MonthWidget(
                    title: "Net Worth",
                    content: month.networth!.toStringAsFixed(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MonthWidget(
                    title: "Effect",
                    content: month.effect!.toStringAsFixed(2),
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
                    content: month.income!.toStringAsFixed(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MonthWidget(
                    title: "Expense",
                    content: month.expense!.toStringAsFixed(2),
                  ),
                ),
              ],
            ),
          ],
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
