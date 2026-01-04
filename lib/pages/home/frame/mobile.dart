import 'package:finease/db/accounts.dart';
import 'package:finease/db/months.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  SummaryPageState createState() => SummaryPageState();
}

class SummaryPageState extends State<SummaryPage> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();
  final MonthService _monthService = MonthService();

  double networthAmount = 0.0;
  double assetAmount = 0.0;
  double liabilitiesAmount = 0.0;
  double liquidAmount = 0.0;
  String currency = "USD";
  bool isLoading = true;
  List<Month> months = [];

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
      List<Month> monthsList = await _monthService.getAllMonthsInsights();
      setState(() {
        currency = prefCurrency;
        networthAmount = asset + liabilities;
        liabilitiesAmount = liabilities;
        assetAmount = asset;
        liquidAmount = liquid;
        months = monthsList;
        isLoading = false;
      });
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _showError(e) async => showErrorDialog(e.toString(), context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomInset: true,
      appBar: appBar(context, "home"),
      drawer: AppDrawer(
        onRefresh: _fetchNetWorth,
        scaffoldKey: _scaffoldStateKey,
        destinations: destinations,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNetWorth,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SummaryBody(
            isLoading: isLoading,
            networthAmount: networthAmount,
            assetAmount: assetAmount,
            liabilitiesAmount: liabilitiesAmount,
            liquidAmount: liquidAmount,
            currency: currency,
            months: months,
          ),
        ),
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          final result = await context.pushNamed(RoutesName.addEntry.name);
          if (result == true) {
            _fetchNetWorth();
          }
        },
        icon: Icons.add,
      ),
    );
  }
}
