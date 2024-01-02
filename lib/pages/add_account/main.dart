import 'package:finease/core/common.dart';
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
  final _formState = GlobalKey<FormState>();
  final _accountName = TextEditingController();
  final _accountCurrency = TextEditingController();
  bool _creditDebitValue = true;
  bool _liquidAssetsValue = true;

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Account')),
        body: AddAccountForm(
          formState: _formState,
          accountName: _accountName,
          accountCurrency: _accountCurrency,
          onCreditDebitSaved: _accountDebit,
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
          onPressed: _submitForm,
          title: "Add",
        ),
      ),
    );
  }

  void _accountDebit(bool value) {
    setState(() {
      _creditDebitValue = value;
    });
  }

  void _accountLiquid(bool value) {
    setState(() {
      _liquidAssetsValue = value;
    });
  }

  void _submitForm() {
    String accountName = _accountName.text;
    String accountCurrency = _accountCurrency.text;
    if (_formState.currentState?.validate() ?? false) {
      _formState.currentState?.save();

      // Handle form submission logic
      print('''
Debit: $_creditDebitValue
Liquid Assets: $_liquidAssetsValue
_accountName: $accountName
_accountCurrency: $accountCurrency
''');
      context.pop();
    }
  }
}

class AddAccountForm extends StatelessWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController accountName;
  final TextEditingController accountCurrency;
  final Function(bool) onCreditDebitSaved;
  final Function(bool) onLiquidAssetsSaved;

  const AddAccountForm({
    super.key,
    required this.formState,
    required this.accountName,
    required this.accountCurrency,
    required this.onCreditDebitSaved,
    required this.onLiquidAssetsSaved,
  });

  @override
  Widget build(BuildContext context) {
    return AddAccountBody(
      formState: formState,
      accountName: accountName,
      accountCurrency: accountCurrency,
      onCreditDebitSaved: onCreditDebitSaved,
      onLiquidAssetsSaved: onLiquidAssetsSaved,
    );
  }
}
