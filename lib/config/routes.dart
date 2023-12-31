import 'package:finease/config/routes_name.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/features/intro/intro_page.dart';
import 'package:finease/features/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: RoutesName.intro.path,
  observers: <NavigatorObserver>[HeroController()],
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      name: RoutesName.intro.name,
      path: RoutesName.intro.path,
      builder: (BuildContext context, GoRouterState state) {
        return const IntroPage();
      },
    ),
    GoRoute(
      name: RoutesName.onboarding.name,
      path: RoutesName.onboarding.path,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingPage();
      },
    )
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Center(
      child: Text(state.error.toString()),
    );
  },
  redirect: (_, GoRouterState state) async {
    final String? introDone = await SettingService().getSetting("introDone");
    if (introDone != "true") {
      return RoutesName.intro.path;
    }

    final String? userName = await SettingService().getSetting("userName");
    if (userName == null || userName == "") {
      return RoutesName.onboarding.path;
    }
    return null;
  }
);
