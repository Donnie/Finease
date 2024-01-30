import 'package:finease/db/currency.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/months.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

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
            'Do you want to adjust the unrealised amount as Capital Gains?'),
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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (months.isEmpty) {
      return const Center(
        child: Text('No data available'),
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
