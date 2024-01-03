import 'package:finease/pages/add_account/main.dart';
import 'package:finease/pages/home/frame/main.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/setup_accounts/main.dart';
import 'package:finease/pages/add_name/main.dart';
import 'package:finease/pages/intro/intro_page.dart';
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
      name: RoutesName.addName.name,
      path: RoutesName.addName.path,
      builder: (BuildContext context, GoRouterState state) {
        return const AddNamePage();
      },
    ),
    GoRoute(
      name: RoutesName.setupAccounts.name,
      path: RoutesName.setupAccounts.path,
      builder: (BuildContext context, GoRouterState state) {
        return const SetupAccountsPage();
      },
    ),
    GoRoute(
      name: RoutesName.addAccount.name,
      path: RoutesName.addAccount.path,
      builder: (BuildContext context, GoRouterState state) {
        return const AddAccountScreen();
      },
    ),
    GoRoute(
      name: RoutesName.home.name,
      path: RoutesName.home.path,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Center(
      child: Text(state.error.toString()),
    );
  },
  redirect: (_, GoRouterState state) async {
    final String onboarded = await SettingService().getSetting(Setting.onboarded);
    if (onboarded != "true") {
      return null;
    }
    return RoutesName.home.path;

    // final String introDone = await SettingService().getSetting(Setting.introDone);
    // if (introDone != "true") {
    //   return RoutesName.intro.path;
    // }

    // final String userName = await SettingService().getSetting(Setting.userName);
    // if (userName.isEmpty) {
    //   return RoutesName.addName.path;
    // }

    // final String accountSetup = await SettingService().getSetting(Setting.accountSetup);
    // if (accountSetup != "true") {
    //   return RoutesName.setupAccounts.path;
    // }
    // return null;
  }
);
