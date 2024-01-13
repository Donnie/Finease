import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/parts/card.dart';
import 'package:finease/parts/pill_chip.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AccountItemWidget extends StatelessWidget {
  const AccountItemWidget({
    super.key,
    required this.account,
    required this.onPress,
  });

  final Account account;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final icon = (account.type == AccountType.asset ||
            account.type == AccountType.income)
        ? MdiIcons.arrowBottomLeft
        : MdiIcons.arrowTopRight;

    final color = (account.type == AccountType.asset ||
            account.type == AccountType.income)
        ? Color(Colors.green.shade200.value)
        : Color(Colors.red.shade200.value);

    final tileColor = account.liquid
        ? Color(Colors.brown.shade900.value)
        : Color(Colors.grey.shade800.value);

    return ScreenTypeLayout.builder(
      mobile: (p0) => ListTile(
        splashColor: tileColor,
        subtitleTextStyle: const TextStyle(fontSize: 12),
        onTap: onPress,
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(account.name),
        subtitle: Text(account.currency),
        trailing: Icon(MdiIcons.delete),
      ),
      tablet: (p0) => AppCard(
        color: tileColor,
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: context.titleMedium,
                      ),
                      Text(
                        account.currency,
                        style: context.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountTypeSelectionFormField extends FormField<AccountType> {
  AccountTypeSelectionFormField({
    super.key,
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
                      onChanged?.call(type);
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
    ValueChanged<bool>? onChanged,
    bool initialValue = true,
  }) : super(
          builder: (FormFieldState<bool> state) {
            final value = state.value ?? initialValue;
            return SwitchListTile(
              title: title,
              value: value,
              onChanged: (bool newValue) {
                state.didChange(newValue);
                onChanged?.call(newValue);
              },
            );
          },
        );
}
