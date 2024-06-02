import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';

class EditEntryBody extends StatefulWidget {
  const EditEntryBody({
    super.key,
    required this.creditAccount,
    required this.debitAccount,
    required this.dateTime,
    required this.onDateTimeChanged,
    required this.entryAmount,
    required this.entryNotes,
    required this.formState,
  });

  final Account creditAccount;
  final Account debitAccount;
  final DateTime dateTime;
  final GlobalKey<FormState> formState;
  final String entryAmount;
  final TextEditingController entryNotes;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  EditEntryBodyState createState() => EditEntryBodyState();
}

class EditEntryBodyState extends State<EditEntryBody> {
  @override
  Widget build(BuildContext context) {
    final String debitCurrencyISO = widget.debitAccount.currency;
    final String debitCurrency = SupportedCurrency[debitCurrencyISO]!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formState,
        child: ListView(
          children: [
            AccountChoiceFormField(
              key: const Key('from_account'),
              title: "From Account",
              accounts: [widget.debitAccount],
              selectedAccount: widget.debitAccount,
            ),
            AccountChoiceFormField(
              key: const Key('to_account'),
              title: "To Account",
              accounts: [widget.creditAccount],
              selectedAccount: widget.creditAccount,
            ),
            const SizedBox(height: 32),
            TextFormField(
              key: const Key('entry_notes'),
              controller: widget.entryNotes,
              decoration: const InputDecoration(
                hintText: 'Enter transaction notes',
                label: Text('Enter transaction notes'),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('entry_amount'),
              initialValue: widget.entryAmount,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Text(debitCurrency),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            DateTimePicker(
              dateTime: widget.dateTime,
              onDateTimeChanged: widget.onDateTimeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
