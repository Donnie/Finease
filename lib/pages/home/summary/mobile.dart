import 'package:finease/pages/home/summary/net_worth_card.dart';
import 'package:flutter/material.dart';

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
        return const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: NetWorthCard(),
        );
      },
    );
  }
}
