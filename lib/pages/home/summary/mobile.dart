import 'package:finease/pages/home/summary/net_worth_card.dart';
import 'package:finease/parts/variable_fab_size.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:go_router/go_router.dart';

class SummaryMobileWidget extends StatefulWidget {
  const SummaryMobileWidget({super.key});

  @override
  SummaryMobileWidgetState createState() => SummaryMobileWidgetState();
}

class SummaryMobileWidgetState extends State<SummaryMobileWidget> {
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();

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
    String prefCurrency = await _settingService.getSetting(Setting.prefCurrency);
    double asset =
        await _accountService.getTotalBalance(type: AccountType.asset);
    double liabilities =
        await _accountService.getTotalBalance(type: AccountType.liability);
    double liquid = await _accountService.getTotalBalance(liquid: true);
    setState(() {
      currency = prefCurrency;
      networthAmount = (asset + liabilities);
      liabilitiesAmount = liabilities;
      assetAmount = asset;
      liquidAmount = liquid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        padding: const EdgeInsets.only(bottom: 124),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: NetWorthCard(
              networthAmount: networthAmount,
              assetAmount: assetAmount,
              liabilitiesAmount: liabilitiesAmount,
              liquidAmount: liquidAmount,
              currency: currency,
            ),
          );
        },
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          await context.pushNamed(
            RoutesName.addEntry.name,
            extra: () => {},
          );
        },
        icon: Icons.add,
      ),
    );
  }
}
