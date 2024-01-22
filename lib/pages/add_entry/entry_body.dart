import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/pages/export.dart';
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
    this.defaultCurrency,
    required this.creditAmount,
    required this.debitAmount,
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
  final Function routeArg;
  final String addNewRoute;
  final TextEditingController creditAmount;
  final TextEditingController debitAmount;
  final TextEditingController entryNotes;
  final String? defaultCurrency;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueChanged<Account?> onCreditAccountSelected;
  final ValueChanged<Account?> onDebitAccountSelected;

  @override
  AddEntryBodyState createState() => AddEntryBodyState();
}

class AddEntryBodyState extends State<AddEntryBody> {
  creditRouteArg(Account account) async {
    await widget.routeArg();
    widget.onCreditAccountSelected(account);
  }

  debitRouteArg(Account account) async {
    await widget.routeArg();
    widget.onDebitAccountSelected(account);
  }

  @override
  Widget build(BuildContext context) {
    String? creditCurrencyISO =
        widget.creditAccount?.currency ?? widget.defaultCurrency;
    String? creditCurrency = SupportedCurrency[creditCurrencyISO];
    String? debitCurrencyISO =
        widget.debitAccount?.currency ?? widget.defaultCurrency;
    String? debitCurrency = SupportedCurrency[debitCurrencyISO];
    bool showDebitAmount = creditCurrency != debitCurrency;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formState,
        child: ListView(
          children: [
            AccountChoiceFormField(
              key: UniqueKey(),
              title: "From Account",
              accounts: widget.accounts,
              selectedAccount: widget.debitAccount,
              onAccountSelected: widget.onDebitAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: debitRouteArg,
              ),
              validator: (Account? account) {
                if (account == null) {
                  return 'Please select an account';
                }
                return null;
              },
            ),
            AccountChoiceFormField(
              key: UniqueKey(),
              title: "To Account",
              accounts: widget.accounts,
              selectedAccount: widget.creditAccount,
              onAccountSelected: widget.onCreditAccountSelected,
              onAddNew: () => context.pushNamed(
                widget.addNewRoute,
                extra: creditRouteArg,
              ),
              validator: (Account? account) {
                if (account == null) {
                  return 'Please select an account';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            TextFormField(
              key: const Key('entry_notes'),
              controller: widget.entryNotes,
              decoration: const InputDecoration(
                hintText: 'Enter entry notes',
                label: Text('Enter entry notes'),
              ),
              keyboardType: TextInputType.text,
            ),
            Visibility(
              visible: showDebitAmount,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('entry_amount_debit'),
                    controller: widget.debitAmount,
                    decoration: InputDecoration(
                      hintText: 'Enter $debitCurrencyISO amount',
                      label: Text('Enter $debitCurrencyISO amount'),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        child: Text("$debitCurrency"),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
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
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('entry_amount_credit'),
              controller: widget.creditAmount,
              decoration: InputDecoration(
                hintText: 'Enter $creditCurrencyISO amount',
                label: Text('Enter $creditCurrencyISO amount'),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Text("$creditCurrency"),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
              ),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
          ],
        ),
      ),
    );
  }
}
