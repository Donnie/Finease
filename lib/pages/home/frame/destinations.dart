import 'package:finease/pages/home/accounts/main.dart';
import 'package:finease/pages/home/summary/main.dart';
import 'package:finease/pages/home/months/main.dart';
import 'package:finease/pages/home/transactions/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<Destination> destinations = [
  Destination(
    pageType: PageType.home,
    body: const SummaryPage(),
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home),
  ),
  Destination(
    body: const AccountsPage(),
    pageType: PageType.accounts,
    icon: const Icon(Icons.credit_card_outlined),
    selectedIcon: const Icon(Icons.credit_card),
  ),
  Destination(
    body: const MonthsPage(),
    pageType: PageType.months,
    icon: Icon(MdiIcons.calendarMonthOutline),
    selectedIcon: Icon(MdiIcons.calendarMonth),
  ),
  Destination(
    body: const EntriesPage(),
    pageType: PageType.transactions,
    icon: Icon(MdiIcons.swapVerticalCircleOutline),
    selectedIcon: Icon(MdiIcons.swapVertical),
  ),
];

class Destination {
  Destination({
    required this.pageType,
    required this.icon,
    required this.selectedIcon,
    required this.body,
  });

  final Icon icon;
  final PageType pageType;
  final Icon selectedIcon;
  final Widget body;
}

enum PageType {
  home,
  accounts,
  transactions,
  months;

  int get toIndex => index;
  String get name => toString().split('.').last;
}
