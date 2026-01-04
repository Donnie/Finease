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
    required this.onRefresh,
  });

  final List<Destination> destinations;
  final GlobalKey<ScaffoldState> scaffoldKey;

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    // Remove leading slash for comparison
    final normalizedLocation = location.startsWith('/') ? location.substring(1) : location;
    
    for (int i = 0; i < destinations.length; i++) {
      final routePath = destinations[i].routeName.path;
      final normalizedRoutePath = routePath.startsWith('/') ? routePath.substring(1) : routePath;
      
      // Exact match or starts with route path followed by /
      if (normalizedLocation == normalizedRoutePath ||
          normalizedLocation.startsWith('$normalizedRoutePath/')) {
        return i;
      }
    }
    return 0; // Default to home
  }

  void _onDestinationSelected(BuildContext context, int index) {
    scaffoldKey.currentState?.closeDrawer();
    context.goNamed(destinations[index].routeName.name);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int i) => _onDestinationSelected(context, i),
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
