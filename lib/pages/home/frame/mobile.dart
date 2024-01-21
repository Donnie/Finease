import 'package:finease/pages/export.dart';
import 'package:finease/parts/error_dialog.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  SummaryPageState createState() => SummaryPageState();
}

class SummaryPageState extends State<SummaryPage> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();

  int destIndex = 0;
  double networthAmount = 0.0;
  double assetAmount = 0.0;
  double liabilitiesAmount = 0.0;
  double liquidAmount = 0.0;
  String currency = "USD";

  @override
  void initState() {
    super.initState();
    _fetchNetWorth();
  }

  Future<void> _fetchNetWorth() async {
    try {
      String prefCurrency =
          await _settingService.getSetting(Setting.prefCurrency);
      double asset =
          await _accountService.getTotalBalance(type: AccountType.asset);
      double liabilities =
          await _accountService.getTotalBalance(type: AccountType.liability);
      double liquid = await _accountService.getTotalBalance(liquid: true);
      setState(() {
        currency = prefCurrency;
        networthAmount = asset + liabilities;
        liabilitiesAmount = liabilities;
        assetAmount = asset;
        liquidAmount = liquid;
      });
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _showError(e) async => showErrorDialog(e.toString(), context);

  void _updateBody(int index) {
    setState(() {
      destIndex = index;
    });
    context.goNamed(
      destinations[destIndex].routeName.name,
      extra: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomInset: true,
      appBar: appBar(
        context,
        "home",
      ),
      drawer: AppDrawer(
        onRefresh: _fetchNetWorth,
        scaffoldKey: _scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: _updateBody,
      ),
      body: SummaryBody(
        networthAmount: networthAmount,
        assetAmount: assetAmount,
        liabilitiesAmount: liabilitiesAmount,
        liquidAmount: liquidAmount,
        currency: currency,
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () =>
            context.pushNamed(RoutesName.addEntry.name, extra: _fetchNetWorth),
        icon: Icons.add,
      ),
    );
  }
}
