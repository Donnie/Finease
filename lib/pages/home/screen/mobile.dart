import 'package:finease/pages/home/screen/credit_debit.dart';
import 'package:finease/pages/home/screen/total_balance_widget.dart';
import 'package:finease/parts/card.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class SummaryMobileWidget extends StatelessWidget {
  const SummaryMobileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      padding: const EdgeInsets.only(bottom: 124),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: AppCard(
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
                    amount: 543012.43,
                  ),
                  const SizedBox(height: 24),
                  const ExpenseTotalForMonthWidget(
                    credit: 42109,
                    debit: 102231.12,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
