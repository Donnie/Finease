import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SummaryBody extends StatelessWidget {
  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;

  const SummaryBody({
    super.key,
    required this.networthAmount,
    required this.assetAmount,
    required this.liabilitiesAmount,
    required this.liquidAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        padding: const EdgeInsets.only(bottom: 124),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: NetWorthCard(
              networthAmount: networthAmount,
              assetAmount: assetAmount,
              liabilitiesAmount: liabilitiesAmount,
              liquidAmount: liquidAmount,
              currency: currency,
            ),
          );
        },
      ),
      // tablet: (p0) => const SummaryTabletWidget(),
      // desktop: (p0) => const SummaryDesktopWidget(),
    );
  }
}
