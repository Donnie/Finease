import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SummaryBody extends StatelessWidget {
  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;
  final bool isLoading;

  const SummaryBody({
    super.key,
    required this.networthAmount,
    required this.assetAmount,
    required this.liabilitiesAmount,
    required this.liquidAmount,
    required this.currency,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => SummaryMobile(
        isLoading: isLoading,
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
      ),
      tablet: (p0) => SummaryMobile(
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
      ),
      desktop: (p0) => SummaryMobile(
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
      ),
    );
  }
}

class SummaryMobile extends StatelessWidget {
  const SummaryMobile({
    super.key,
    required this.networthAmount,
    required this.assetAmount,
    required this.liabilitiesAmount,
    required this.liquidAmount,
    required this.currency,
    this.isLoading = false,
  });

  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (liabilitiesAmount == 0 && assetAmount == 0) {
      return const Center(
        child: Text('Enter your first transaction with the plus (+) button below.'),
      );
    }

    return ListView.builder(
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
    );
  }
}
