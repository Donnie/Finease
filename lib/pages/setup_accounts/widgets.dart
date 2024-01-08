import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountChoice extends StatefulWidget {
  final String title;
  final List<Account> accounts;
  final ValueChanged<Account?>? onAccountSelected;
  final Function? onAddNew;

  const AccountChoice({
    super.key,
    required this.title,
    required this.accounts,
    this.onAccountSelected,
    this.onAddNew,
  });

  @override
  State<AccountChoice> createState() => _AccountChoiceState();
}

class _AccountChoiceState extends State<AccountChoice> {
  Account? selectedAccount;

  void _handleAccountSelection(Account account, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedAccount = account;
      } else {
        if (selectedAccount == account) {
          selectedAccount = null;
        }
      }
    });

    widget.onAccountSelected?.call(selectedAccount);
  }

  void _handleAddNew() {
    setState(() {
      selectedAccount = null;
    });

    widget.onAddNew?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: context.titleMedium,
            ),
          ),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              ...widget.accounts.map(
                (account) => AccountChip(
                  selected: selectedAccount == account,
                  avatar: Text(
                    SupportedCurrency[account.currency]!,
                    style: context.bodyLarge,
                  ),
                  onSelected: (val) => _handleAccountSelection(account, val),
                  label: Text(
                    account.name,
                    style: TextStyle(color: context.primary),
                  ),
                ),
              ),
              AddNewAccount(onSelected: (val) => _handleAddNew()),
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
