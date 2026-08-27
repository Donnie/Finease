import 'package:finease/db/accounts.dart';
import 'package:finease/db/months.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class YearsPage extends StatefulWidget {
  const YearsPage({
    super.key,
  });

  @override
  YearsPageState createState() => YearsPageState();
}

class YearsPageState extends State<YearsPage> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final MonthService _monthService = MonthService();
  List<Month> years = [];
  double networth = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadYears();
  }

  Future<void> loadYears() async {
    networth = await AccountService().getTotalBalance();
    List<Month> yearsList = await _monthService.getAllYearsInsights();
    yearsList.sort((a, b) => b.date!.compareTo(a.date!));

    setState(() {
      years = yearsList;
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
          "years",
          "Click on a year to see transactions for that year.",
        ),
        body: RefreshIndicator(
          onRefresh: loadYears,
          child: YearCards(
            isLoading: isLoading,
            years: years,
            networth: networth,
            onChange: loadYears,
          ),
        ),
        drawer: AppDrawer(
          onRefresh: loadYears,
          scaffoldKey: _scaffoldStateKey,
          destinations: destinations,
        ),
      ),
    );
  }
}
