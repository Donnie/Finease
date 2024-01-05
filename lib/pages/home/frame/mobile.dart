import 'package:finease/pages/home/frame/app_drawer.dart';
import 'package:finease/pages/home/frame/app_top_bar.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/pages/home/summary/main.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({
    super.key,
    required this.floatingActionButton,
    required this.destinations,
  });

  final List<Destination> destinations;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 8;
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomInset: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(toolbarHeight),
        child: TopBar(title: "Home"),
      ),
      drawer: AppDrawer(
        scaffoldKey: _scaffoldStateKey,
        destinations: destinations,
      ),
      body: const SummaryPage(),
      floatingActionButton: floatingActionButton,
    );
  }
}
