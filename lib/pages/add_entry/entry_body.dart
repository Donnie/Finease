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
    required this.formState,
    required this.entryNotes,
    required this.entryAmount,
    required this.accounts,
    required this.onCreditAccountSelected,
    required this.onDebitAccountSelected,
    required this.addNewRoute,
    required this.routeArg,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController entryNotes;
  final TextEditingController entryAmount;
  final List<Account> accounts;
  final ValueChanged<Account?> onCreditAccountSelected;
  final ValueChanged<Account?> onDebitAccountSelected;
  final String addNewRoute;
  final Object routeArg;

  @override
  AddEntryBodyState createState() => AddEntryBodyState();
}

class AddEntryBodyState extends State<AddEntryBody> {
  DateTime selectedDateTime = DateTime.now();

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
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter amount';
                }
              },
            ),
            const SizedBox(height: 16),
            DateTimePicker(
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  selectedDateTime = newDateTime;
                });
              },
            ),
            const SizedBox(height: 16),
            AccountChoice(
              title: "Debit Account",
              accounts: widget.accounts,
              onAccountSelected: widget.onDebitAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: widget.routeArg,
              ),
            ),
            const SizedBox(height: 16),
            AccountChoice(
              title: "Credit Account",
              accounts: widget.accounts,
              onAccountSelected: widget.onCreditAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: widget.routeArg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
