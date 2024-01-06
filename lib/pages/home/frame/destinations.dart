import 'package:finease/pages/home/summary/main.dart';
import 'package:finease/pages/home/months/main.dart';
import 'package:flutter/material.dart';

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
  months;

  int get toIndex => index;
  String get name => toString().split('.').last;
}
