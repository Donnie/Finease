import 'package:finease/db/accounts.dart';
import 'package:finease/pages/add_entry/date_time.dart';
import 'package:finease/pages/setup_accounts/widgets.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AddEntryBody extends StatefulWidget {
  const AddEntryBody({
    super.key,
    required this.accounts,
    required this.addNewRoute,
    this.dateTime,
    this.creditAccount,
    this.debitAccount,
    required this.entryAmount,
    required this.entryNotes,
    required this.formState,
    required this.onCreditAccountSelected,
    required this.onDateTimeChanged,
    required this.onDebitAccountSelected,
    required this.routeArg,
  });

  final Account? creditAccount;
  final Account? debitAccount;
  final DateTime? dateTime;
  final GlobalKey<FormState> formState;
  final List<Account> accounts;
  final Object routeArg;
  final String addNewRoute;
  final TextEditingController entryAmount;
  final TextEditingController entryNotes;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueChanged<Account?> onCreditAccountSelected;
  final ValueChanged<Account?> onDebitAccountSelected;

  @override
  AddEntryBodyState createState() => AddEntryBodyState();
}

class AddEntryBodyState extends State<AddEntryBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formState,
        child: ListView(
          children: [
            AppTextFormField(
              key: const Key('entry_notes'),
              controller: widget.entryNotes,
              hintText: 'Enter entry notes',
              label: 'Enter entry notes',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('entry_amount'),
              controller: widget.entryAmount,
              hintText: 'Enter amount',
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
              label: 'Enter amount',
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null) {
                  return 'Enter an amount';
                }
                if (val.isEmpty) {
                  return 'Enter an amount';
                }
                if (double.tryParse(val) == 0) {
                  return 'Enter an amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DateTimePicker(
              dateTime: widget.dateTime,
              onDateTimeChanged: widget.onDateTimeChanged,
            ),
            const SizedBox(height: 16),
            AccountChoiceFormField(
              title: "From Account",
              accounts: widget.accounts,
              initialValue: widget.debitAccount,
              onAccountSelected: widget.onDebitAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: widget.routeArg,
              ),
              validator: (Account? account) {
                if (account == null) {
                  return 'Please select an account';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AccountChoiceFormField(
              title: "To Account",
              accounts: widget.accounts,
              initialValue: widget.creditAccount,
              onAccountSelected: widget.onCreditAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: widget.routeArg,
              ),
              validator: (Account? account) {
                if (account == null) {
                  return 'Please select an account';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
