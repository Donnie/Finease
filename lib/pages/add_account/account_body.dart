import 'package:currency_picker/currency_picker.dart';
import 'package:finease/core/extensions/color_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/account_item.dart';
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
              onChanged: (AccountType? value) {
                widget.onAccountType?.call(value!);
                setState(() {
                  _trackBalance = [AccountType.asset, AccountType.liability]
                      .contains(value);
                  _isLiability = [AccountType.liability].contains(value);
                });
              },
            ),
            Visibility(
              visible: _trackBalance,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  SwitchFormField(
                    key: const Key('account_liquidity'),
                    title: const Text('Liquid Assets'),
                    onChanged: (bool? value) =>
                        widget.onLiquidAssetsSaved?.call(value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('account_name'),
              controller: widget.accountName,
              decoration: const InputDecoration(
                hintText: 'Enter account name',
                label: Text('Enter account name'),
              ),
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
                    child: ListTile(
                      title: Text(
                        "Liabilities should be input in negative",
                        style: TextStyle(color: context.error),
                      ),
                    ),
                  ),
                  TextFormField(
                    key: const Key('account_balance'),
                    controller: widget.accountBalance,
                    decoration: const InputDecoration(
                      hintText: 'Enter current balance',
                      label: Text('Enter current balance'),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]")),
                    ],
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
            InkWell(
              onTap: () => showCurrencyPicker(
                context: context,
                currencyFilter: SupportedCurrency.keys.toList(),
                showFlag: true,
                onSelect: (Currency currency) =>
                    widget.accountCurrency.text = currency.code,
              ),
              child: AbsorbPointer(
                child: TextFormField(
                  key: const Key('account_currency'),
                  controller: widget.accountCurrency,
                  decoration: const InputDecoration(
                    hintText: 'Select currency',
                    label: Text('Currency'),
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
    );
  }
}
