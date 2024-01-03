import 'package:finease/core/common.dart';
import 'package:finease/pages/home/mobile.dart';
import 'package:finease/pages/home/tablet.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      child: ScreenTypeLayout.builder(
        mobile: (p0) => const HomePageMobile(),
        tablet: (p0) =>const HomePageTablet(),
        desktop: (p0) => Container(),
      ),
    );
  }
}
