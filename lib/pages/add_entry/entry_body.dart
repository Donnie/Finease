import 'package:finease/pages/add_entry/date_time.dart';
import 'package:finease/pages/setup_accounts/default_account.dart';
import 'package:finease/pages/setup_accounts/widgets.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AddEntryBody extends StatefulWidget {
  const AddEntryBody({
    super.key,
    required this.formState,
    required this.entryNotes,
    required this.entryAmount,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController entryNotes;
  final TextEditingController entryAmount;

  @override
  AddEntryBodyState createState() => AddEntryBodyState();
}

class AddEntryBodyState extends State<AddEntryBody> {
  DateTime? selectedDateTime;

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
              accounts: defaultAccountsData("EUR"),
              onAccountSelected: (account) {
                if (account != null) {
                  print("Account chosen ${account.name}");
                }
              },
              onAddNew: () {
                context.pushNamed(RoutesName.addAccount.name, extra: () => {});
              },
            ),
            const SizedBox(height: 16),
            AccountChoice(
              title: "Credit Account",
              accounts: defaultAccountsData("EUR"),
              onAccountSelected: (val) {
                if (val != null) {
                  print("Account chosen ${val.name}");
                }
              },
              onAddNew: () {
                context.pushNamed(RoutesName.addAccount.name, extra: () => {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
