import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
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
      name: RoutesName.accounts.name,
      path: RoutesName.accounts.path,
      builder: (BuildContext context, GoRouterState state) {
        return const AccountsPage();
      },
    ),
    GoRoute(
      name: RoutesName.entries.name,
      path: RoutesName.entries.path,
      builder: (BuildContext context, GoRouterState state) {
        return const EntriesPage();
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
        dynamic Function() onFormSubmitted =
            state.extra as dynamic Function();
        return EditAccountScreen(
          accountID: accountID,
          onFormSubmitted: onFormSubmitted,
        );
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
        final Function onFormSubmitted = state.extra as Function;
        return SettingsPage(onFormSubmitted: onFormSubmitted);
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Center(
      child: Text(state.error.toString()),
    );
  },
);
