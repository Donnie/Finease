import 'package:finease/db/accounts.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/add_entry/entry_body.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DuplicateEntryScreen extends StatefulWidget {
  final int entryID;

  const DuplicateEntryScreen({
    super.key,
    required this.entryID,
  });

  @override
  DuplicateEntryScreenState createState() => DuplicateEntryScreenState();
}

class DuplicateEntryScreenState extends State<DuplicateEntryScreen> {
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntryAndAccounts();
  }

  Future<void> _loadEntryAndAccounts() async {
    // Load accounts
    final accounts = await _accountService.getAllAccounts(hidden: false);
    accounts.sort((a, b) => a.name.compareTo(b.name));

    // Load entry
    final entry = await _entryService.getEntry(widget.entryID);
    if (entry == null) {
      // Entry not found, pop and return
      if (mounted) {
        context.pop();
      }
      return;
    }

    // Get default currency
    final curr = await _settingService.getSetting(Setting.prefCurrency);

    // Calculate new date: same day but in current month
    final now = DateTime.now();
    final originalDate = entry.date ?? DateTime.now();
    
    // Handle edge cases: if original day doesn't exist in current month
    // (e.g., original was 31st but current month has 30 days)
    int targetDay = originalDate.day;
    int targetMonth = now.month;
    int targetYear = now.year;
    
    // Find the last day of the current month
    final lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    if (targetDay > lastDayOfMonth) {
      targetDay = lastDayOfMonth;
    }
    
    final newDate = DateTime(
      targetYear,
      targetMonth,
      targetDay,
      originalDate.hour,
      originalDate.minute,
      originalDate.second,
    );

    // Find accounts from the loaded accounts list
    final debitAccount = accounts.firstWhere(
      (account) => account.id == entry.debitAccountId,
      orElse: () => accounts.first,
    );
    final creditAccount = accounts.firstWhere(
      (account) => account.id == entry.creditAccountId,
      orElse: () => accounts.first,
    );

    // Calculate debit amount if multi-currency
    String debitAmountText = '';
    if (debitAccount.currency != creditAccount.currency) {
      // For multi-currency, we need to find the debit entry
      // Since entries are stored separately for multi-currency transactions,
      // we'll need to search for the corresponding debit entry
      // For now, we'll set it to the same amount and let the user adjust
      debitAmountText = entry.amount.toString();
    }

    setState(() {
      _accounts = accounts;
      _defaultCurrency = curr;
      _debitAccount = debitAccount;
      _creditAccount = creditAccount;
      _dateTime = newDate;
      _entryNotes.text = entry.notes ?? '';
      _creditAmount.text = entry.amount.toString();
      _debitAmount.text = debitAmountText;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Duplicate Transaction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Duplicate Transaction')),
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
    );
  }

  Future<void> _fetchAccounts() async {
    final accounts = await _accountService.getAllAccounts(hidden: false);
    accounts.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _accounts = accounts;
    });
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
        context.pop(true);
      }
    }
  }
}

