import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/add_account/main.dart';
import 'package:finease/pages/add_entry/main.dart';
import 'package:finease/pages/add_name/main.dart';
import 'package:finease/pages/edit_account/main.dart';
import 'package:finease/pages/home/frame/main.dart';
import 'package:finease/pages/intro/intro_page.dart';
import 'package:finease/pages/settings/main.dart';
import 'package:finease/pages/setup_accounts/main.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: RoutesName.intro.path,
  observers: <NavigatorObserver>[HeroController()],
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      redirect: (context, state) async {
        String onboarded = await SettingService().getSetting(Setting.onboarded);
        if (onboarded == "true") {
          return RoutesName.home.path;
        }
        return null;
      },
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
        dynamic Function(Account) onFormSubmitted =
            state.extra as dynamic Function(Account);
        return AddAccountScreen(onFormSubmitted: onFormSubmitted);
      },
    ),
    GoRoute(
      name: RoutesName.editAccount.name,
      path: RoutesName.editAccount.pathWparam,
      builder: (BuildContext context, GoRouterState state) {
        final int accountID = int.parse(
          state.pathParameters[RoutesName.editAccount.param]!,
        );
        return EditAccountScreen(accountID: accountID);
      },
    ),
    GoRoute(
      name: RoutesName.addEntry.name,
      path: RoutesName.addEntry.path,
      builder: (BuildContext context, GoRouterState state) {
        final Function onFormSubmitted = state.extra as Function;
        return AddEntryScreen(onFormSubmitted: onFormSubmitted);
      },
    ),
    GoRoute(
      name: RoutesName.home.name,
      path: RoutesName.home.path,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      name: RoutesName.settings.name,
      path: RoutesName.settings.path,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Center(
      child: Text(state.error.toString()),
    );
  },
);
