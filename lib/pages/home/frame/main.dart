import 'package:finease/core/export.dart';
import 'package:finease/pages/export.dart';
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
      color: context.surface,
      child: ScreenTypeLayout.builder(
        mobile: (p0) => const SummaryPage(),
        tablet: (p0) => const HomePageTablet(),
        desktop: (p0) => const HomePageTablet(),
      ),
    );
  }
}
