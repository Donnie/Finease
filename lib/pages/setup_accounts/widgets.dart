import 'package:finease/core/export.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountChoiceFormField extends FormField<Account> {
  AccountChoiceFormField({
    super.key,
    required List<Account> accounts,
    Account? selectedAccount,
    super.onSaved,
    super.validator,
    ValueChanged<Account?>? onAccountSelected,
    VoidCallback? onAddNew,
    required String title,
  }) : super(
          initialValue: selectedAccount,
          builder: (FormFieldState<Account?> state) {
            return AccountChoice(
              accounts: accounts,
              errorMessage: state.errorText,
              onAccountSelected: (Account? account) {
                state.didChange(account);
                onAccountSelected?.call(account);
              },
              onAddNew: onAddNew,
              selectedAccount: state.value,
              title: title,
            );
          },
        );
}

class AccountChoice extends StatelessWidget {
  final Account? selectedAccount;
  final Function? onAddNew;
  final List<Account> accounts;
  final String title;
  final String? errorMessage;
  final ValueChanged<Account?>? onAccountSelected;

  const AccountChoice({
    super.key,
    required this.accounts,
    required this.title,
    this.errorMessage,
    this.onAccountSelected,
    this.onAddNew,
    this.selectedAccount,
  });

  void _handleAccountSelection(Account account, bool isSelected) {
    Account? selectedAccount = isSelected ? account : null;

    onAccountSelected?.call(selectedAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: context.titleMedium,
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == accounts.length) {
                return AddNewAccount(onSelected: (val) => onAddNew?.call());
              }
              Account account = accounts[index];
              return AccountChip(
                invisible: (selectedAccount?.id != null &&
                    selectedAccount?.id != account.id),
                selected: selectedAccount?.id == account.id,
                avatar: Text(
                  SupportedCurrency[account.currency]!,
                  style: context.bodyLarge,
                ),
                onSelected: (val) => _handleAccountSelection(account, val),
                label: Text(
                  account.name,
                  style: TextStyle(color: context.primary),
                ),
              );
            },
          ),
        ),
        if (errorMessage != null)
          ListTile(
            title: Text(
              errorMessage!,
              style: TextStyle(color: context.error),
            ),
          ),
      ],
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
    this.invisible,
    this.avatar,
    required this.label,
    super.key,
  });

  final Function(bool value)? onSelected;
  final Widget? avatar;
  final Widget label;
  final bool? selected;
  final bool? invisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !(invisible ?? false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
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
        ),
      ),
    );
  }
}
