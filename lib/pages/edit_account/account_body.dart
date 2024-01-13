import 'package:finease/db/accounts.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditAccountBody extends StatelessWidget {
  const EditAccountBody({
    super.key,
    required this.formState,
    required this.accountType,
    required this.accountName,
    required this.accountLiquid,
    required this.accountHidden,
    required this.onChangeLiquid,
    required this.onChangeHidden,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController accountName;
  final ValueChanged<bool> onChangeLiquid;
  final ValueChanged<bool> onChangeHidden;
  final bool accountLiquid;
  final bool accountHidden;
  final AccountType accountType;

  @override
  Widget build(BuildContext context) {
    bool trackLiquid = [
      AccountType.asset,
      AccountType.liability,
    ].contains(accountType);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formState,
        child: ListView(
          children: [
            Visibility(
              visible: trackLiquid,
              child: Column(children: [
                SwitchListTile(
                  value: accountLiquid,
                  key: const Key('account_liquidity'),
                  title: const Text('Liquid'),
                  onChanged: (bool value) => onChangeLiquid.call(value),
                ),
                const SizedBox(height: 16),
              ]),
            ),
            SwitchListTile(
              value: accountHidden,
              key: const Key('account_hidden'),
              title: const Text('Hidden'),
              onChanged: (bool value) {
                if (value) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return SwitchAlert(
                        onChangeHidden: onChangeHidden,
                      );
                    },
                  );
                }
                onChangeHidden.call(false);
              },
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}

class SwitchAlert extends StatelessWidget {
  const SwitchAlert({
    super.key,
    required this.onChangeHidden,
  });

  final ValueChanged<bool> onChangeHidden;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: const Text(
          'Once you hide an account, you would never get it back, unless you know SQLite'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.pop();
            onChangeHidden(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            onChangeHidden(true);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
