import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountChoice extends StatelessWidget {
  const AccountChoice({
    super.key,
    required this.title,
    this.onSelected,
    required this.accounts,
  });

  final Function(bool value)? onSelected;
  final String title;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: context.titleMedium,
            ),
          ),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              ...accounts.map(
                (account) => AccountChip(
                  selected: true,
                  avatar: Text(
                    SupportedCurrency[account.currency]!,
                    style: context.bodyLarge,
                  ),
                  onSelected: (val) => {},
                  label: Text(
                    account.name,
                    style: TextStyle(color: context.primary),
                  ),
                ),
              ),
              AddNewAccount(onSelected: onSelected),
            ],
          ),
        ],
      ),
    );
  }
}

class AddNewAccount extends StatelessWidget {
  const AddNewAccount({
    this.onSelected,
    super.key,
  });

  final Function(bool value)? onSelected;

  @override
  Widget build(BuildContext context) {
    return AccountChip(
      avatar: Icon(
        color: context.primary,
        MdiIcons.plus,
      ),
      onSelected: onSelected,
      label: Text(
        "Add new",
        style: TextStyle(color: context.primary),
      ),
    );
  }
}

class AccountChip extends StatelessWidget {
  const AccountChip({
    this.selected,
    this.onSelected,
    this.avatar,
    required this.label,
    super.key,
  });

  final Function(bool value)? onSelected;
  final Widget? avatar;
  final Widget label;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected ?? false,
      onSelected: onSelected,
      avatar: avatar,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          width: 1,
          color: context.primary,
        ),
      ),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: label,
      labelStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: context.onSurfaceVariant),
      padding: const EdgeInsets.all(12),
    );
  }
}
