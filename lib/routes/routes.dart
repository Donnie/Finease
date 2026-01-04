import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/duplicate_entry/main.dart';
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
        return const AddInfoPage();
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
      name: RoutesName.months.name,
      path: RoutesName.months.path,
      builder: (BuildContext context, GoRouterState state) {
        return const MonthsPage();
      },
    ),
    GoRoute(
      name: RoutesName.transactions.name,
      path: RoutesName.transactions.path,
      builder: (BuildContext context, GoRouterState state) {
        return const EntriesPage();
      },
    ),
    GoRoute(
      name: RoutesName.transactionsByDate.name,
      path: RoutesName.transactionsByDate.path,
      builder: (BuildContext context, GoRouterState state) {
        final String? startDateStr = state.uri.queryParameters['startDate'];
        final String? endDateStr = state.uri.queryParameters['endDate'];
        if (startDateStr == null || endDateStr == null) {
          return const EntriesPage();
        }
        final DateTime startDate = DateTime.parse(startDateStr);
        final DateTime endDate = DateTime.parse(endDateStr);
        return EntriesPage(startDate: startDate, endDate: endDate);
      },
    ),
    GoRoute(
      name: RoutesName.transactionsByAccount.name,
      path: RoutesName.transactionsByAccount.pathWaccountParam,
      builder: (BuildContext context, GoRouterState state) {
        final int accountID = int.tryParse(
          state.pathParameters[RoutesName.transactionsByAccount.accountParam]!,
        ) ?? 0;
        return EntriesPage(accountID: accountID);
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
        dynamic Function() onFormSubmitted = state.extra as dynamic Function();
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
        final String? debitAccountId = state.uri.queryParameters['debit_account_id'];
        return AddEntryScreen(
          onFormSubmitted: onFormSubmitted,
          initialDebitAccountId: debitAccountId != null ? int.parse(debitAccountId) : null,
        );
      },
    ),
    GoRoute(
      name: RoutesName.editEntry.name,
      path: RoutesName.editEntry.pathWparam,
      builder: (BuildContext context, GoRouterState state) {
        final int entryID = int.parse(
          state.pathParameters[RoutesName.editEntry.param]!,
        );
        dynamic Function() onFormSubmitted = state.extra as dynamic Function();
        return EditEntryScreen(
          entryID: entryID,
          onFormSubmitted: onFormSubmitted,
        );
      },
    ),
    GoRoute(
      name: RoutesName.duplicateEntry.name,
      path: RoutesName.duplicateEntry.pathWparam,
      builder: (BuildContext context, GoRouterState state) {
        final int entryID = int.parse(
          state.pathParameters[RoutesName.duplicateEntry.param]!,
        );
        dynamic Function() onFormSubmitted = state.extra as dynamic Function();
        return DuplicateEntryScreen(
          entryID: entryID,
          onFormSubmitted: onFormSubmitted,
        );
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
