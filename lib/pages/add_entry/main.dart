import 'package:finease/db/accounts.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/error_dialog.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEntryScreen extends StatefulWidget {
  final Function onFormSubmitted;

  const AddEntryScreen({
    super.key,
    required this.onFormSubmitted,
  });

  @override
  AddEntryScreenState createState() => AddEntryScreenState();
}

class AddEntryScreenState extends State<AddEntryScreen> {
  final EntryService _entryService = EntryService();
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();

  final _formState = GlobalKey<FormState>();
  final _entryNotes = TextEditingController();
  final _entryAmount = TextEditingController();
  List<Account> _accounts = [];

  Account? _creditAccount;
  Account? _debitAccount;
  DateTime? _dateTime;
  String? _defaultCurrency;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    final accounts = await _accountService.getAllAccounts(false);
    final curr = await _settingService.getSetting(Setting.prefCurrency);

    setState(() {
      _accounts = accounts;
      _defaultCurrency = curr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: AddEntryBody(
        accounts: _accounts,
        creditAccount: _creditAccount,
        dateTime: _dateTime,
        debitAccount: _debitAccount,
        defaultCurrency: _defaultCurrency,
        entryAmount: _entryAmount,
        entryNotes: _entryNotes,
        formState: _formState,
        onCreditAccountSelected: _onCreditAccountSelected,
        onDateTimeChanged: _onDateTimeChanged,
        onDebitAccountSelected: _onDebitAccountSelected,
        addNewRoute: RoutesName.addAccount.name,
        routeArg: _fetchAccounts,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBigButton(
            onPressed: _submitForm,
            title: "Add",
          ),
        ),
      ),
    );
  }

  Future<void> _onDateTimeChanged(DateTime dateTime) async {
    setState(() {
      _dateTime = dateTime;
    });
  }

  Future<void> _onDebitAccountSelected(Account? account) async {
    setState(() {
      _debitAccount = account;
    });
  }

  Future<void> _onCreditAccountSelected(Account? account) async {
    setState(() {
      _creditAccount = account;
    });
  }

  Future<void> _submitForm() async {
    String entryNotes = _entryNotes.text;
    double amount = double.tryParse(_entryAmount.text) ?? 0;
    if (_formState.currentState?.validate() ?? false) {
      context.pop();
      Entry entry = Entry(
        debitAccountId: _debitAccount!.id!,
        creditAccountId: _creditAccount!.id!,
        amount: amount,
        notes: entryNotes,
        date: _dateTime,
      );
      try {
        if (_debitAccount!.currency != _creditAccount!.currency) {
          await _entryService.createForexEntry(entry);
        } else {
          await _entryService.createEntry(entry);
        }
        widget.onFormSubmitted();
      } catch (e) {
        _showError(e);
      }
    }
  }

  Future<void> _showError(e) async => showErrorDialog(e.toString(), context);
}
