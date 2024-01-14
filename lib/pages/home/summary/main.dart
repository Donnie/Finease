import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => const SummaryMobileWidget(),
      // tablet: (p0) => const SummaryTabletWidget(),
      // desktop: (p0) => const SummaryDesktopWidget(),
    );
  }
}
