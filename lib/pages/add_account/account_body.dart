import 'package:finease/parts/export.dart';
import 'package:finease/parts/pill_chip.dart';
import 'package:flutter/material.dart';

class AddAccountBody extends StatelessWidget {
  const AddAccountBody({
    super.key,
    required this.formState,
    required this.accountName,
    required this.accountCurrency,
    this.onCreditDebitSaved,
    this.onLiquidAssetsSaved,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController accountName;
  final TextEditingController accountCurrency;
  final ValueChanged<bool>? onCreditDebitSaved;
  final ValueChanged<bool>? onLiquidAssetsSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formState,
        child: ListView(
          children: [
            CreditDebitSelectionFormField(
              key: const Key('account_debit'),
              onSaved: (bool? value) {
                onCreditDebitSaved?.call(value!);
              },
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('account_name_textfield'),
              controller: accountName,
              hintText: 'Enter account name',
              label: 'Enter account name',
              keyboardType: TextInputType.name,
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter account name';
                }
              },
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('account_currency_textfield'),
              controller: accountCurrency,
              hintText: 'Enter currency',
              label: 'Enter currency',
              keyboardType: TextInputType.name,
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter currency';
                }
              },
            ),
            const SizedBox(height: 16),
            LiquidAssetsSwitchFormField(
              key: const Key('account_liquidity'),
              onSaved: (bool? value) {
                onLiquidAssetsSaved?.call(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CreditDebitSelectionFormField extends FormField<bool> {
  CreditDebitSelectionFormField({
    Key? key,
    FormFieldSetter<bool>? onSaved,
    bool initialValue = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            final isDebit = state.value ?? initialValue;
            return Row(
              children: [
                AppPillChip(
                  isSelected: !isDebit,
                  title: "Credit",
                  onPressed: () => state.didChange(false),
                ),
                AppPillChip(
                  isSelected: isDebit,
                  title: "Debit",
                  onPressed: () => state.didChange(true),
                ),
              ],
            );
          },
        );
}

class LiquidAssetsSwitchFormField extends FormField<bool> {
  LiquidAssetsSwitchFormField({
    Key? key,
    FormFieldSetter<bool>? onSaved,
    bool initialValue = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            final isLiquidAssets = state.value ?? initialValue;
            return SwitchListTile(
              title: const Text('Liquid Assets'),
              value: isLiquidAssets,
              onChanged: (bool value) => state.didChange(value),
            );
          },
        );
}
