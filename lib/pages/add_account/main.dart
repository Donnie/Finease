import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/pages/add_account/account_body.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

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
        body: AddAccountForm(
          formState: _formState,
          accountName: _accountName,
          accountBalance: _accountBalance,
          accountCurrency: _accountCurrency,
          onAccountType: _accountType,
          onLiquidAssetsSaved: _accountLiquid,
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
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

  int accountBalance(TextEditingController value) {
    int balance = int.tryParse(value.text) ?? 0;
    return balance * 100;
  }

  void _submitForm() async {
    String accountName = _accountName.text;
    String accountCurrency = _accountCurrency.text;
    int balance = accountBalance(_accountBalance);
    if (_formState.currentState?.validate() ?? false) {
      _formState.currentState?.save();
      Account account = Account(
        name: accountName,
        currency: accountCurrency,
        balance: balance,
        liquid: accountLiquid,
        type: accountType,
      );
      await _accountService.createAccount(account);
    }
  }
}

class AddAccountForm extends StatelessWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController accountName;
  final TextEditingController accountBalance;
  final TextEditingController accountCurrency;
  final Function(AccountType) onAccountType;
  final Function(bool) onLiquidAssetsSaved;

  const AddAccountForm({
    super.key,
    required this.formState,
    required this.accountName,
    required this.accountBalance,
    required this.accountCurrency,
    required this.onAccountType,
    required this.onLiquidAssetsSaved,
  });

  @override
  Widget build(BuildContext context) {
    return AddAccountBody(
      formState: formState,
      accountName: accountName,
      accountBalance: accountBalance,
      accountCurrency: accountCurrency,
      onAccountType: onAccountType,
      onLiquidAssetsSaved: onLiquidAssetsSaved,
    );
  }
}
