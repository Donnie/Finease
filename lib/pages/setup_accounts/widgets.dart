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
              onAccountSelected: (onAccountSelected != null) ? (Account? account) {
                state.didChange(account);
                onAccountSelected.call(account);
              } : null,
              onAddNew: onAddNew,
              selectedAccount: state.value,
              title: title,
            );
          },
        );
}

class AccountChoice extends StatefulWidget {
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

  @override
  State<AccountChoice> createState() => AccountChoiceState();
}

class AccountChoiceState extends State<AccountChoice> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleAccountSelection(Account account, bool isSelected) {
    Account? selectedAccount = isSelected ? account : null;

    widget.onAccountSelected?.call(selectedAccount);
  }

  List<Account> get _filteredAccounts {
    if (_searchQuery.isEmpty) {
      return widget.accounts;
    }
    return widget.accounts.where((account) {
      return account.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAccounts = _filteredAccounts;
    
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: context.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search accounts',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredAccounts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == filteredAccounts.length) {
                return AddNewAccount(onSelected: (widget.onAddNew != null) ? (val) => widget.onAddNew?.call() : null);
              }
              Account account = filteredAccounts[index];
              return AccountChip(
                invisible: (widget.selectedAccount?.id != null &&
                    widget.selectedAccount?.id != account.id),
                selected: widget.selectedAccount?.id == account.id,
                avatar: Text(
                  SupportedCurrency[account.currency]!,
                  style: context.bodyMedium,
                ),
                onSelected: (widget.onAccountSelected != null) ? (val) => _handleAccountSelection(account, val) : null,
                label: Text(
                  account.name,
                  style: context.bodyMedium,
                ),
              );
            },
          ),
        ),
        if (widget.errorMessage != null)
          ListTile(
            title: Text(
              widget.errorMessage!,
              style: context.bodyMedium!.copyWith(
                color: context.error,
              ),
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
        style: context.bodyMedium,
      ),
    );
  }
}

class AccountChip extends StatelessWidget {
  const AccountChip({
    this.selected,
    this.onSelected,
    this.invisible = false,
    this.avatar,
    required this.label,
    super.key,
  });

  final Function(bool value)? onSelected;
  final Widget? avatar;
  final Widget label;
  final bool? selected;
  final bool invisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !invisible,
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
              color: (onSelected != null) ? context.primary : context.shadow,
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
