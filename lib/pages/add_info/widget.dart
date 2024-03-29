import 'package:currency_picker/currency_picker.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';
import 'package:finease/parts/intro_top.dart';

class AddInfoBody extends StatelessWidget {
  const AddInfoBody({
    super.key,
    required this.formState,
    required this.name,
    required this.currency,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController name;
  final TextEditingController currency;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IntroTopWidget(
            titleWidget: RichText(
              text: TextSpan(
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onSurface,
                  letterSpacing: 0.8,
                ),
                text: language["welcome"],
                children: [
                  TextSpan(
                    text: ' ${language["appTitle"]}',
                    style: TextStyle(
                      color: context.primary,
                    ),
                  )
                ],
              ),
            ),
            icon: Icons.wallet,
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Form(
              key: formState,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const Key('user_name_textfield'),
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Enter name",
                      label: Text("Name"),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Enter name";
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () => showCurrencyPicker(
                      context: context,
                      currencyFilter: SupportedCurrency.keys.toList(),
                      showFlag: true,
                      onSelect: (Currency curr) => currency.text = curr.code,
                    ),
                    child: AbsorbPointer(
                      child: TextFormField(
                        key: const Key('pref_currency'),
                        controller: currency,
                        decoration: const InputDecoration(
                          hintText: "Enter Preferred Currency",
                          label: Text("Enter Preferred Currency"),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please select a currency';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
