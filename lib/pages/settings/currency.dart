import 'package:currency_picker/currency_picker.dart';
import 'package:finease/core/extensions/text_style_extension.dart';
import 'package:finease/db/settings.dart';
import 'package:flutter/material.dart';
import 'package:finease/db/currency.dart';
import 'package:go_router/go_router.dart';

class CurrencySelectorWidget extends StatefulWidget {
  final Function onChange;
  const CurrencySelectorWidget({
    super.key,
    required this.onChange,
  });

  @override
  CurrencySelectorWidgetState createState() => CurrencySelectorWidgetState();
}

class CurrencySelectorWidgetState extends State<CurrencySelectorWidget> {
  final SettingService _settingService = SettingService();
  String? currency;
  String? symbol;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  Future<void> onLoad() async {
    final curr = await _settingService.getSetting(Setting.prefCurrency);

    setState(() {
      currency = curr;
      symbol = SupportedCurrency[curr];
    });
  }

  void _showCurrencyPicker(BuildContext context) {
    showCurrencyPicker(
      context: context,
      currencyFilter: SupportedCurrency.keys.toList(),
      showFlag: true,
      onSelect: (Currency selectedCurrency) async {
        setState(() {
          currency = selectedCurrency.code;
          symbol = selectedCurrency.symbol;
        });
        await _settingService.setSetting(Setting.prefCurrency, currency!);
        // ignore: use_build_context_synchronously
        context.pop();
        widget.onChange();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Preferred Currency"),
      subtitle: Text(currency ?? ''),
      leading: Text(
        symbol ?? '',
        style: context.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () => _showCurrencyPicker(context),
    );
  }
}
