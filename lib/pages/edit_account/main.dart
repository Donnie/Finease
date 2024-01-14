import 'package:finease/core/extensions/text_style_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditAccountScreen extends StatefulWidget {
  final Function() onFormSubmitted;
  final int accountID;

  const EditAccountScreen({
    super.key,
    required this.accountID,
    required this.onFormSubmitted,
  });

  @override
  EditAccountScreenState createState() => EditAccountScreenState();
}

class EditAccountScreenState extends State<EditAccountScreen> {
  final AccountService _accountService = AccountService();

  final _formState = GlobalKey<FormState>();
  final _accountName = TextEditingController();
  final _accountCurrency = TextEditingController();
  double _accountBalance = 0;
  bool accountHidden = false;
  Account? _account;

  @override
  void initState() {
    super.initState();
    loadAccount(widget.accountID);
  }

  Future<void> loadAccount(int id) async {
    Account? account = await _accountService.getAccount(id);
    setState(() {
      _account = account!;
      _accountBalance = account.balance;
      _accountName.text = _account?.name ?? "";
      _accountCurrency.text = _account?.currency ?? "";
    });
  }

  void _accountLiquid(bool value) {
    setState(() {
      _account!.liquid = value;
    });
  }

  void _accountHidden(bool value) {
    setState(() {
      _account!.hidden = value;
    });
  }

  void _onDelete() async {
    context.pop();
    await _accountService.deleteAccount(_account!.id!);
    widget.onFormSubmitted();
  }

  void _submitForm() async {
    setState(() {
      _account!.name = _accountName.text;
      _account!.currency = _accountCurrency.text;
    });
    if (_formState.currentState?.validate() ?? false) {
      context.pop();
      await _accountService.updateAccount(_account!);
      widget.onFormSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit account", style: context.titleMedium),
      ),
      body: EditAccountBody(
        accountType: _account?.type ?? AccountType.asset,
        formState: _formState,
        accountName: _accountName,
        accountBalance: _accountBalance,
        accountCurrency: _accountCurrency,
        accountLiquid: _account?.liquid ?? true,
        accountHidden: _account?.hidden ?? false,
        onChangeLiquid: _accountLiquid,
        onChangeHidden: _accountHidden,
        onDelete: _onDelete,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBigButton(
            onPressed: _submitForm,
            title: "Update",
          ),
        ),
      ),
    );
  }
}
