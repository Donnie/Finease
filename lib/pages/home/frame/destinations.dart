import 'package:finease/core/enum/page_type.dart';
import 'package:finease/pages/home/summary/main.dart';
import 'package:finease/pages/months/main.dart';
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
    body: const MonthsPage(),
    pageType: PageType.months,
    icon: const Icon(Icons.credit_card_outlined),
    selectedIcon: const Icon(Icons.credit_card),
  ),
  Destination(
    body: const SummaryPage(),
    pageType: PageType.debts,
    icon: Icon(MdiIcons.accountCashOutline),
    selectedIcon: Icon(MdiIcons.accountCash),
  ),
  Destination(
    body: const SummaryPage(),
    pageType: PageType.overview,
    icon: Icon(MdiIcons.sortVariant),
    selectedIcon: Icon(MdiIcons.sortVariant),
  ),
  Destination(
    body: const SummaryPage(),
    pageType: PageType.categories,
    icon: const Icon(Icons.category_outlined),
    selectedIcon: const Icon(Icons.category),
  ),
  Destination(
    body: const SummaryPage(),
    pageType: PageType.budget,
    icon: Icon(MdiIcons.timetable),
    selectedIcon: Icon(MdiIcons.timetable),
  ),
  Destination(
    body: const SummaryPage(),
    pageType: PageType.recurring,
    icon: Icon(MdiIcons.cashSync),
    selectedIcon: Icon(MdiIcons.cashSync),
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
