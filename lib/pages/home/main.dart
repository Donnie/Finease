import 'package:finease/core/common.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: SafeArea(
          child: Container(),
        ),
        body: IndexedStack(
          children: [
            Center(
              child:  Container(),
            ),
          ],
        ),
      ),
    );
  }
}
