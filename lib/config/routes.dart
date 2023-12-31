import 'package:finease/features/onboarding/user_onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finease/config/routes_name.dart';
import 'package:finease/features/intro/intro_page.dart';

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
      name: RoutesName.userOnboarding.name,
      path: RoutesName.userOnboarding.path,
      builder: (BuildContext context, GoRouterState state) {
        return const UserOnboardingPage();
      },
    )
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Center(
      child: Text(state.error.toString()),
    );
  },
  redirect: (_, GoRouterState state) => RoutesName.intro.path,
);
