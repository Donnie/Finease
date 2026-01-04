import 'dart:ui';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/months.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthCards extends StatelessWidget {
  final List<Month> months;
  final bool isLoading;
  final double networth;
  final Future<void> Function() onChange;

  const MonthCards({
    super.key,
    required this.months,
    this.isLoading = false,
    required this.networth,
    required this.onChange,
  });

  Future<void> _showConfirmationDialog(
    BuildContext context,
    double unrealised,
  ) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Foreign Currency Retranslation'),
        content: const Text(
            'Unrealised gains or losses occur when the value of your accounts in different currencies changes due to exchange rate fluctuations, even though you haven\'t made any transactions.\n\nDo you want to adjust the unrealised amount as Capital Gains?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await EntryService().addCurrencyRetranslation(unrealised);
        onChange();
      } catch (e) {
        // ignore: use_build_context_synchronously
        await showErrorDialog('Error: $e', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    final blur = context.watch<GlassmorphicBlurProvider>().blurAmount;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (months.isEmpty) {
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
              child: const Text('No data available'),
            ),
          ),
        ),
      );
    }

    String currency = SupportedCurrency[months[0].currency!]!;
    double unrealised = (networth - (months[0].networth ?? 0));
    bool showUnrealised = unrealised.round().abs() > 0;
    String gains = (unrealised > 0) ? "gains" : "losses";

    return SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible: showUnrealised,
            child: Center(
              child: UnrealisedAlert(
                gains: gains,
                currency: currency,
                unrealised: unrealised,
                onTap: () => _showConfirmationDialog(context, unrealised),
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
