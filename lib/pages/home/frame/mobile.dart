import 'package:finease/pages/home/frame/app_drawer.dart';
import 'package:finease/pages/home/frame/app_top_bar.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({
    super.key,
  });

  @override
  HomePageMobileState createState() => HomePageMobileState();
}

class HomePageMobileState extends State<HomePageMobile> {
  int destIndex = 0;

  void _updateBody(int index) {
    setState(() {
      destIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 8;
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: TopBar(title: destinations[destIndex].pageType.name),
      ),
      drawer: AppDrawer(
        scaffoldKey: _scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: _updateBody,
      ),
      body: destinations[destIndex].body,
    );
  }
}
