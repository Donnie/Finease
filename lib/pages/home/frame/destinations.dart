import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<Destination> destinations = [
  Destination(
    routeName: RoutesName.home,
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home),
  ),
  Destination(
    routeName: RoutesName.accounts,
    icon: const Icon(Icons.credit_card_outlined),
    selectedIcon: const Icon(Icons.credit_card),
  ),
  Destination(
    routeName: RoutesName.transactions,
    icon: Icon(MdiIcons.swapVerticalCircleOutline),
    selectedIcon: Icon(MdiIcons.swapVertical),
  ),
  Destination(
    routeName: RoutesName.months,
    icon: Icon(MdiIcons.calendarOutline),
    selectedIcon: Icon(MdiIcons.calendar),
  ),
  Destination(
    routeName: RoutesName.chat,
    icon: const Icon(Icons.chat_outlined),
    selectedIcon: const Icon(Icons.chat),
  ),
];

class Destination {
  Destination({
    required this.routeName,
    required this.icon,
    required this.selectedIcon,
  });

  final RoutesName routeName;
  final Icon icon;
  final Icon selectedIcon;
}
