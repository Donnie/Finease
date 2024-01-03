import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';
import 'package:finease/core/theme/custom_color.dart';

class ExpenseTotalForMonthWidget extends StatelessWidget {
  const ExpenseTotalForMonthWidget({
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
        Text(
          language["total"],
          style: context.titleMedium?.copyWith(
            color: context.onPrimaryContainer.withOpacity(0.85),
          ),
        ),
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
