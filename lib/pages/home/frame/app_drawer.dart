import 'package:finease/core/common.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.destinations,
    required this.scaffoldKey,
    required this.onDestinationSelected,
    this.selectedIndex = 0,
  });

  final List<Destination> destinations;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(int) onDestinationSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int i) {
        onDestinationSelected(i);
        scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: AppIconTitle(),
        ),
        const Divider(),
        ...destinations.map((e) => NavigationDrawerDestination(
              icon: e.icon,
              selectedIcon: e.selectedIcon,
              label: Text(e.pageType.name),
            )),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            onTap: () async {
              await context.pushNamed(RoutesName.settings.name);
              scaffoldKey.currentState?.closeDrawer();
            },
            leading: const Icon(Icons.settings),
            title: Text(
              language["settings"],
              style: context.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
