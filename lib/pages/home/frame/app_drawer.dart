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
  });

  final List<Destination> destinations;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (i) {
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
              label: Text(e.pageType.name(context)),
            )),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            onTap: () {
              context.pushNamed(RoutesName.settings.name);
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
