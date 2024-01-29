import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/account_search.dart';
import 'package:flutter/material.dart';

class CapGainsSelectorWidget extends StatefulWidget {
  const CapGainsSelectorWidget({
    super.key,
  });

  @override
  CapGainsSelectorWidgetState createState() => CapGainsSelectorWidgetState();
}

class CapGainsSelectorWidgetState extends State<CapGainsSelectorWidget> {
  final SettingService _settingService = SettingService();
  final AccountService _accountService = AccountService();
  Account? _account;
  String? subtitle;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  Future<void> onLoad() async {
    String settingId = await _settingService.getSetting(Setting.capitalGains);
    int? accountId = int.tryParse(settingId);
    if (accountId != null) {
      Account? account = await _accountService.getAccount(accountId);
      setState(() {
        _account = account;
        subtitle = "${account!.name} - ${account.currency}";
      });
    }
  }

  Future<Account?> search(List<Account> accounts) async {
    Account? selectedAccount = await showSearch<Account?>(
      context: context,
      delegate: AccountSearchDelegate(
        accounts: accounts,
        selected: _account,
      ),
    );
    return selectedAccount;
  }

  void _showCapGainsPicker() async {
    final List<Account> accounts = await AccountService().getAllAccounts(
      hidden: false,
      type: AccountType.income,
    );
    Account? selectedAccount = await search(accounts);

    if (selectedAccount != null) {
      await _settingService.setSetting(
          Setting.capitalGains, "${selectedAccount.id}");
      setState(() {
        _account = selectedAccount;
        subtitle = "${selectedAccount.name} - ${selectedAccount.currency}";
      });
      return;
    }

    await _settingService.deleteSetting(Setting.capitalGains);
    setState(() {
      _account = null;
      subtitle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Capital Gains Account"),
      subtitle: Text(subtitle ?? 'Unlinked'),
      leading: const Icon(Icons.moving),
      onTap: () => _showCapGainsPicker(),
    );
  }
}
