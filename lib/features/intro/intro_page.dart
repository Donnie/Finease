import 'package:finease/features/intro/intro_big.dart';
import 'package:finease/features/intro/intro_mobile.dart';
import 'package:finease/features/intro/intro_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (p0) => const IntroBigScreenWidget(),
      tablet: (p0) => const IntroTabletWidget(),
      mobile: (p0) => const IntroMobileWidget(),
    );
  }
}
