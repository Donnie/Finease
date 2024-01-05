import 'package:finease/pages/home/frame/app_drawer.dart';
import 'package:finease/pages/home/frame/app_top_bar.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/pages/home/summary/main.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
class HomePageMobile extends StatefulWidget {
  final Widget floatingActionButton;
  final List<Destination> destinations;

  const HomePageMobile({
    Key? key,
    required this.floatingActionButton,
    required this.destinations,
  }) : super(key: key);

  @override
  HomePageMobileState createState() => HomePageMobileState();
}

class HomePageMobileState extends State<HomePageMobile> {
  Widget _body = const SummaryPage(); // Default body

  void _updateBody(int index) {
    setState(() {
      _body = destinations[index].body;
    });
  }

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
        destinations: widget.destinations,
        onDestinationSelected: _updateBody,
      ),
      body: _body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
