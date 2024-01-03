import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({
    super.key,
    required this.title,
    required this.amount,
  });

  final double amount;
  final String title;

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
          "\$ $amount",
          style: context.headlineMedium?.copyWith(
            color: context.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
