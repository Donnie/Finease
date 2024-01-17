import 'package:currency_picker/currency_picker.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/parts/account_item.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditAccountBody extends StatelessWidget {
  const EditAccountBody({
    super.key,
    required this.formState,
    required this.account,
    required this.accountCurrency,
    required this.accountName,
    required this.onChangeAccountType,
    required this.onChangeHidden,
    required this.onChangeLiquid,
    this.onDelete,
  });

  final GlobalKey<FormState> formState;
  final Account account;
  final TextEditingController accountCurrency;
  final TextEditingController accountName;
  final ValueChanged<AccountType> onChangeAccountType;
  final ValueChanged<bool> onChangeHidden;
  final ValueChanged<bool> onChangeLiquid;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    bool trackLiquid = [
      AccountType.asset,
      AccountType.liability,
    ].contains(account.type);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formState,
        child: ListView(
          children: [
            AccountTypeSelectionFormField(
              key: const Key('account_type'),
              initialValue: account.type,
              onChanged: (AccountType value) => onChangeAccountType.call(value),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: trackLiquid,
              child: Column(children: [
                SwitchListTile(
                  value: account.liquid,
                  key: const Key('account_liquidity'),
                  title: const Text('Liquid'),
                  onChanged: (bool value) => onChangeLiquid.call(value),
                ),
                const SizedBox(height: 16),
              ]),
            ),
            AppTextFormField(
              key: const Key('account_name'),
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
            Visibility(
              visible: account.deletable,
              child: Column(children: [
                GestureDetector(
                  onTap: () => showCurrencyPicker(
                    context: context,
                    currencyFilter: SupportedCurrency.keys.toList(),
                    showFlag: true,
                    onSelect: (Currency currency) =>
                        accountCurrency.text = currency.code,
                  ),
                  child: AbsorbPointer(
                    child: AppTextFormField(
                      key: const Key('account_currency'),
                      controller: accountCurrency,
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
                const SizedBox(height: 16),
              ]),
            ),
            SwitchListTile(
              value: account.hidden,
              key: const Key('account_hidden'),
              title: const Text('Hide account!'),
              onChanged: (bool value) {
                if (value) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return SwitchAlert(
                        word: "hide",
                        onChange: onChangeHidden,
                      );
                    },
                  );
                }
                onChangeHidden.call(false);
              },
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: account.deletable && (onDelete != null),
              child: Column(children: [
                SwitchListTile(
                  value: false,
                  key: const Key('account_delete'),
                  title: const Text('Delete account!'),
                  onChanged: (bool value) {
                    if (value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return SwitchAlert(
                            word: "delete",
                            onChange: (val) => val ? onDelete?.call() : {},
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchAlert extends StatelessWidget {
  const SwitchAlert({
    super.key,
    required this.onChange,
    required this.word,
  });

  final ValueChanged<bool> onChange;
  final String word;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: Text(
          'Once you $word an account, you would never get it back, unless you restore from a backup!'),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            onChange(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            onChange(true);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
