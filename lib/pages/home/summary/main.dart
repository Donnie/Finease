import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:finease/db/months.dart';
import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class SummaryBody extends StatelessWidget {
  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;
  final bool isLoading;
  final List<Month> months;

  const SummaryBody({
    super.key,
    required this.networthAmount,
    required this.assetAmount,
    required this.liabilitiesAmount,
    required this.liquidAmount,
    required this.currency,
    this.isLoading = false,
    this.months = const [],
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
        months: months,
      ),
      tablet: (p0) => SummaryMobile(
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
        months: months,
      ),
      desktop: (p0) => SummaryMobile(
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
        months: months,
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
    this.months = const [],
  });

  final double networthAmount;
  final double assetAmount;
  final double liabilitiesAmount;
  final double liquidAmount;
  final String currency;
  final bool isLoading;
  final List<Month> months;

  @override
  Widget build(BuildContext context) {
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    final blur = context.watch<GlassmorphicBlurProvider>().blurAmount;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (liabilitiesAmount == 0 && assetAmount == 0) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(opacity * 0.8),
                    Theme.of(context).colorScheme.surface.withOpacity(opacity * 0.4),
                    Theme.of(context).colorScheme.surface.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                  radius: 1.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text('Enter your first transaction with the plus (+) button below.'),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      padding: const EdgeInsets.only(bottom: 124),
      itemBuilder: (context, index) {
        if (index == 0) {
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
        } else {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: NetWorthGraphCard(
              months: months,
              currency: currency,
              currentNetWorth: networthAmount,
            ),
          );
        }
      },
    );
  }
}
