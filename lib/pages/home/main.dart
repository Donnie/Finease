import 'package:finease/core/common.dart';
import 'package:finease/pages/home/destinations.dart';
import 'package:finease/pages/home/mobile.dart';
import 'package:finease/pages/home/tablet.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: ScreenTypeLayout.builder(
        mobile: (p0) => HomePageMobile(
          destinations: destinations,
        ),
        tablet: (p0) => const HomePageTablet(),
        desktop: (p0) => Container(),
      ),
    );
  }
}
