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
  bool _trackBalance = true;
  bool _isLiability = false;

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
              onSaved: (AccountType? value) =>
                  widget.onAccountType?.call(value!),
              onChanged: (AccountType? value) => setState(() {
                _trackBalance =
                    [AccountType.asset, AccountType.liability].contains(value);
                _isLiability = [AccountType.liability].contains(value);
              }),
            ),
            Visibility(
              visible: _trackBalance,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  SwitchFormField(
                    key: const Key('account_liquidity'),
                    title: const Text('Liquid Assets'),
                    onSaved: (bool? value) =>
                        widget.onLiquidAssetsSaved?.call(value!),
                  ),
                ],
              ),
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
              visible: _trackBalance,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _isLiability,
                    child: const ListTile(
                      title: Text("Liabilities should be accounted in negative"),
                    ),
                  ),
                  AppTextFormField(
                    key: const Key('account_balance'),
                    controller: widget.accountBalance,
                    hintText: 'Enter current balance',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]")),
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
    super.key,
    super.onSaved,
    FormFieldSetter<AccountType>? onChanged,
    AccountType initialValue = AccountType.asset,
  }) : super(
          initialValue: AccountType.asset,
          builder: (FormFieldState<AccountType> state) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: AccountType.values.map((type) {
                  final isSelected = state.value == type;
                  return AppPillChip(
                    isSelected: isSelected,
                    title: type.name,
                    onPressed: () {
                      state.didChange(type);
                      if (onChanged != null) {
                        onChanged(type);
                      }
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
}

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    super.key,
    Widget? title,
    super.onSaved,
    ValueChanged<bool>? onChanged,
    bool super.initialValue = true,
  }) : super(
          builder: (FormFieldState<bool> state) {
            final value = state.value ?? initialValue;
            return SwitchListTile(
              title: title,
              value: value,
              onChanged: (bool newValue) {
                state.didChange(newValue);
                if (onChanged != null) {
                  onChanged(newValue);
                }
              },
            );
          },
        );
}
