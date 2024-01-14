import 'package:finease/pages/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({
    super.key,
  });

  @override
  HomePageMobileState createState() => HomePageMobileState();
}

class HomePageMobileState extends State<HomePageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  int destIndex = 0;

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
        onRefresh: () => {},
        scaffoldKey: _scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: _updateBody,
      ),
      body: const SummaryPage(),
    );
  }
}
