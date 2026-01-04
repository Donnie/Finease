import 'package:finease/db/accounts.dart';
import 'package:finease/db/months.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class MonthsPage extends StatefulWidget {
  const MonthsPage({
    super.key,
  });

  @override
  MonthsPageState createState() => MonthsPageState();
}

class MonthsPageState extends State<MonthsPage> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final MonthService _monthService = MonthService();
  List<Month> months = [];
  double networth = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMonths();
  }

  Future<void> loadMonths() async {
    networth = await AccountService().getTotalBalance();
    List<Month> monthsList = await _monthService.getAllMonthsInsights();
    monthsList.sort((a, b) => b.date!.compareTo(a.date!));

    setState(() {
      months = monthsList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        key: _scaffoldStateKey,
        backgroundColor: Colors.transparent,
        appBar: infoBar(
          context,
          "months",
          "Click on a month to see transactions for that month.",
        ),
        body: RefreshIndicator(
          onRefresh: loadMonths,
          child: MonthCards(
            isLoading: isLoading,
            months: months,
            networth: networth,
            onChange: loadMonths,
          ),
        ),
        drawer: AppDrawer(
          onRefresh: loadMonths,
          scaffoldKey: _scaffoldStateKey,
          destinations: destinations,
        ),
      ),
    );
  }
}
