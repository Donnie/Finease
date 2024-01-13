import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/pages/add_account/account_body.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAccountScreen extends StatefulWidget {
  final Function(Account) onFormSubmitted;
  const AddAccountScreen({
    super.key,
    required this.onFormSubmitted,
  });

  @override
  AddAccountScreenState createState() => AddAccountScreenState();
}

class AddAccountScreenState extends State<AddAccountScreen> {
  final AccountService _accountService = AccountService();

  final _formState = GlobalKey<FormState>();
  final _accountName = TextEditingController();
  final _accountBalance = TextEditingController();
  final _accountCurrency = TextEditingController();
  AccountType accountType = AccountType.asset;
  bool accountLiquid = true;

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Account')),
        body: AddAccountBody(
          formState: _formState,
          accountName: _accountName,
          accountBalance: _accountBalance,
          accountCurrency: _accountCurrency,
          onAccountType: _accountType,
          onLiquidAssetsSaved: _accountLiquid,
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

  void _accountType(AccountType value) {
    setState(() {
      accountType = value;
    });
  }

  void _accountLiquid(bool value) {
    setState(() {
      accountLiquid = value;
    });
  }

  void _submitForm() async {
    String accountName = _accountName.text;
    String accountCurrency = _accountCurrency.text;
    double balance = double.tryParse(_accountBalance.text) ?? 0;

    if (_formState.currentState?.validate() ?? false) {
      _formState.currentState?.save();
      context.pop();
      Account account = Account(
        name: accountName,
        currency: accountCurrency,
        balance: balance,
        liquid: accountLiquid,
        type: accountType,
      );
      account = await _accountService.createAccount(account);
      widget.onFormSubmitted(account);
    }
  }
}
