import 'package:finease/core/export.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final Function onRefresh;
  const AppDrawer({
    super.key,
    required this.destinations,
    required this.scaffoldKey,
    required this.onDestinationSelected,
    required this.onRefresh,
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
              label: Text(e.routeName.name),
            )),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            onTap: () async {
              scaffoldKey.currentState?.closeDrawer();
              await context.pushNamed(
                RoutesName.settings.name,
                extra: onRefresh,
              );
            },
            leading: const Icon(Icons.settings),
            title: Text("settings", style: context.bodyLarge),
          ),
        ),
      ],
    );
  }
}
