import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(seedColor: const Color(0xFF795548));
    final Color color = colorScheme.primaryContainer;
    final Color onPrimary = colorScheme.onPrimaryContainer;
    const num expense = 26000;
    const num income = 65400;
    const num savings = income - expense;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 16 / 5,
        child: AppCard(
          elevation: 4,
          color: color,
          child: InkWell(
            onTap: () {
              // show transactions
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ThisAccountTransactionWidget(
                          title: "Mar 2023",
                          content: "N26",
                          color: onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ThisAccountTransactionWidget(
                          title: "Savings",
                          content: savings.toString(),
                          color: onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ThisAccountTransactionWidget(
                          title: "Income",
                          content: income.toString(),
                          color: onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ThisAccountTransactionWidget(
                          title: "Expense",
                          color: onPrimary,
                          content: expense.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThisAccountTransactionWidget extends StatelessWidget {
  const ThisAccountTransactionWidget({
    super.key,
    required this.title,
    required this.content,
    required this.color,
  });

  final Color color;
  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: context.titleLarge?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
