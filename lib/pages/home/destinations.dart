
import 'package:finease/core/enum/page_type.dart';
import 'package:finease/pages/home/mobile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<Destination> destinations = [
  Destination(
    pageType: PageType.home,
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home),
  ),
  Destination(
    pageType: PageType.accounts,
    icon: const Icon(Icons.credit_card_outlined),
    selectedIcon: const Icon(Icons.credit_card),
  ),
  Destination(
    pageType: PageType.debts,
    icon: Icon(MdiIcons.accountCashOutline),
    selectedIcon: Icon(MdiIcons.accountCash),
  ),
  Destination(
    pageType: PageType.overview,
    icon: Icon(MdiIcons.sortVariant),
    selectedIcon: Icon(MdiIcons.sortVariant),
  ),
  Destination(
    pageType: PageType.category,
    icon: const Icon(Icons.category_outlined),
    selectedIcon: const Icon(Icons.category),
  ),
  Destination(
    pageType: PageType.budget,
    icon: Icon(MdiIcons.timetable),
    selectedIcon: Icon(MdiIcons.timetable),
  ),
  Destination(
    pageType: PageType.recurring,
    icon: Icon(MdiIcons.cashSync),
    selectedIcon: Icon(MdiIcons.cashSync),
  ),
];
