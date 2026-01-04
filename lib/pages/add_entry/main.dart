import 'package:finease/db/accounts.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEntryScreen extends StatefulWidget {
  final int? initialDebitAccountId;

  const AddEntryScreen({
    super.key,
    this.initialDebitAccountId,
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
  final _creditAmount = TextEditingController();
  final _debitAmount = TextEditingController();
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
    final accounts = await _accountService.getAllAccounts(hidden: false);
    accounts.sort((a, b) => a.name.compareTo(b.name));

    final curr = await _settingService.getSetting(Setting.prefCurrency);

    setState(() {
      _accounts = accounts;
      _defaultCurrency = curr;
      if (widget.initialDebitAccountId != null) {
        _debitAccount = accounts.firstWhere(
          (account) => account.id == widget.initialDebitAccountId,
          orElse: () => accounts.first,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('add a transaction')),
        body: AddEntryBody(
          accounts: _accounts,
          creditAccount: _creditAccount,
          dateTime: _dateTime,
          debitAccount: _debitAccount,
          defaultCurrency: _defaultCurrency,
          creditAmount: _creditAmount,
          debitAmount: _debitAmount,
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
      ),
    );
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _dateTime = dateTime;
    });
  }

  void _onDebitAccountSelected(Account? account) {
    setState(() {
      _debitAccount = account;
    });
  }

  void _onCreditAccountSelected(Account? account) {
    setState(() {
      _creditAccount = account;
    });
  }

  Future<void> _submitForm() async {
    String entryNotes = _entryNotes.text.trim();
    double creditAmount = double.tryParse(_creditAmount.text) ?? 0;
    if (_formState.currentState?.validate() ?? false) {
      Entry entry = Entry(
        debitAccountId: _debitAccount!.id!,
        creditAccountId: _creditAccount!.id!,
        amount: creditAmount,
        notes: entryNotes,
        date: _dateTime ?? DateTime.now(),
      );
      if (_debitAccount!.currency != _creditAccount!.currency) {
        double debitAmount = double.tryParse(_debitAmount.text) ?? 0;
        await _entryService.createMultiCurrencyEntry(entry, debitAmount);
      } else {
        await _entryService.createEntry(entry);
      }
      if (mounted) {
        context.pop(true); // Return true to indicate successful submission
      }
    }
  }
}
