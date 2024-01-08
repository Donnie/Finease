import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/pages/add_entry/entry_body.dart';
import 'package:finease/pages/setup_accounts/default_account.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEntryScreen extends StatefulWidget {
  final Function onFormSubmitted;

  const AddEntryScreen({
    Key? key,
    required this.onFormSubmitted,
  }) : super(key: key);

  @override
  AddEntryScreenState createState() => AddEntryScreenState();
}

class AddEntryScreenState extends State<AddEntryScreen> {
  final EntryService _entryService = EntryService();

  final _formState = GlobalKey<FormState>();
  final _entryNotes = TextEditingController();
  final _entryAmount = TextEditingController();
  final _accounts = defaultAccountsData("EUR");
  Account? _creditAccount;
  Account? _debitAccount;

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Entry')),
        body: AddEntryForm(
          formState: _formState,
          entryNotes: _entryNotes,
          entryAmount: _entryAmount,
          accounts: _accounts,
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppBigButton(
          onPressed: () {
            _submitForm();
            context.pop();
          },
          title: "Add",
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    widget.onFormSubmitted();
    // String entryNotes = _entryNotes.text;
    // String entryCurrency = _entryCurrency.text;
    // double balance = double.tryParse(_entryAmount.text) ?? 0;
    if (_formState.currentState?.validate() ?? false) {
      _formState.currentState?.save();
      //   Entry entry = Entry(
      //     name: entryNotes,
      //     currency: entryCurrency,
      //     balance: balance,
      //     liquid: entryLiquid,
      //     type: entryType,
      //   );
      //   await _entryService.createEntry(entry);
    }
  }
}

class AddEntryForm extends StatelessWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController entryNotes;
  final TextEditingController entryAmount;
  final List<Account> accounts;

  const AddEntryForm({
    super.key,
    required this.formState,
    required this.entryNotes,
    required this.entryAmount,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    return AddEntryBody(
      formState: formState,
      entryNotes: entryNotes,
      entryAmount: entryAmount,
      accounts: accounts,
      onDebitAccountSelected: (account) {
        if (account != null) {
          print("Account chosen ${account.name}");
        }
      },
      onCreditAccountSelected: (account) {
        if (account != null) {
          print("Account chosen ${account.name}");
        }
      },
      addNewRoute: RoutesName.addAccount.name,
      routeArg: () => {},
    );
  }
}
