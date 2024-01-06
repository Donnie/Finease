import 'package:currency_picker/currency_picker.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/pill_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAccountBody extends StatefulWidget {
  const AddAccountBody({
    super.key,
    required this.formState,
    required this.accountName,
    required this.accountBalance,
    required this.accountCurrency,
    this.onAccountType,
    this.onLiquidAssetsSaved,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController accountName;
  final TextEditingController accountBalance;
  final TextEditingController accountCurrency;
  final ValueChanged<AccountType>? onAccountType;
  final ValueChanged<bool>? onLiquidAssetsSaved;

  @override
  AddAccountBodyState createState() => AddAccountBodyState();
}

class AddAccountBodyState extends State<AddAccountBody> {
  bool _isAccountTrack = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formState,
        child: ListView(
          children: [
            AccountTypeSelectionFormField(
              key: const Key('account_type'),
              onSaved: (AccountType? value) => widget.onAccountType?.call(value!),
            ),
            const SizedBox(height: 16),
            SwitchFormField(
              key: const Key('account_liquidity'),
              title: const Text('Liquid Assets'),
              onSaved: (bool? value) =>
                  widget.onLiquidAssetsSaved?.call(value!),
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('account_name'),
              controller: widget.accountName,
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
            Visibility(
              visible: _isAccountTrack,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AppTextFormField(
                    key: const Key('account_balance'),
                    controller: widget.accountBalance,
                    hintText: 'Enter current balance',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                        } catch (_) {}
                        return oldValue;
                      }),
                    ],
                    label: 'Enter current balance',
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter current balance';
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => showCurrencyPicker(
                context: context,
                currencyFilter: SupportedCurrency.keys.toList(),
                showFlag: true,
                onSelect: (Currency currency) =>
                    widget.accountCurrency.text = currency.code,
              ),
              child: AbsorbPointer(
                child: AppTextFormField(
                  key: const Key('account_currency'),
                  controller: widget.accountCurrency,
                  hintText: 'Select currency',
                  label: 'Currency',
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
    );
  }
}

class AccountTypeSelectionFormField extends FormField<AccountType> {
  AccountTypeSelectionFormField({
    Key? key,
    FormFieldSetter<AccountType>? onSaved,
    bool initialValue = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: AccountType.asset,
          builder: (FormFieldState<AccountType> state) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
              children: AccountType.values.map((type) {
                final isSelected = state.value == type;
                return Expanded(
                  child: AppPillChip(
                    isSelected: isSelected,
                    title: type.name,
                    onPressed: () => state.didChange(type),
                  ),
                );
              }).toList(),
            ),
            );
          },
        );
}

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    Key? key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    ValueChanged<bool>? onChanged, // Add this line
    bool initialValue = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            final value = state.value ?? initialValue;
            return SwitchListTile(
              title: title,
              value: value,
              onChanged: (bool newValue) {
                state.didChange(newValue);
                if (onChanged != null) {
                  onChanged(newValue); // Use the provided onChanged callback
                }
              },
            );
          },
        );
}
