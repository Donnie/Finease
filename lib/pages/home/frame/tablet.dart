import 'package:finease/core/export.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePageTablet extends StatefulWidget {
  const HomePageTablet({
    super.key,
  });

  @override
  HomePageTabletState createState() => HomePageTabletState();
}

class HomePageTabletState extends State<HomePageTablet> {
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final normalizedLocation = location.startsWith('/') ? location.substring(1) : location;
    
    for (int i = 0; i < destinations.length; i++) {
      final routePath = destinations[i].routeName.path;
      final normalizedRoutePath = routePath.startsWith('/') ? routePath.substring(1) : routePath;
      
      if (normalizedLocation == normalizedRoutePath ||
          normalizedLocation.startsWith('$normalizedRoutePath/')) {
        return i;
      }
    }
    return 0; // Default to home
  }

  void _updateBody(BuildContext context, int index) {
    context.goNamed(destinations[index].routeName.name);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        NavigationRail(
          groupAlignment: 0,
          elevation: 1,
          selectedLabelTextStyle: context.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
          unselectedLabelTextStyle: context.bodyLarge?.copyWith(
            color: context.onSurface.withOpacity(0.75),
          ),
          unselectedIconTheme: IconThemeData(
            color: context.onSurface.withOpacity(0.75),
          ),
          labelType: NavigationRailLabelType.all,
          backgroundColor: context.surface,
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (int index) => _updateBody(context, index),
          minWidth: 55,
          useIndicator: true,
          destinations: [
            ...destinations.map((e) => NavigationRailDestination(
                  icon: e.icon,
                  selectedIcon: e.selectedIcon,
                  label: Text(e.routeName.name),
                )),
          ],
          trailing: Column(children: [
            IconButton(
              onPressed: () async {
                await context.pushNamed(RoutesName.settings.name);
                // Settings will handle its own refresh on pop
              },
              icon: Icon(MdiIcons.cog),
              color: context.onSurface.withOpacity(0.75),
            ),
            Text(
              "settings",
              style: TextStyle(color: context.onSurface.withOpacity(0.75)),
            ),
          ]),
        ),
        VerticalDivider(
          thickness: 1,
          width: 1,
          color: context.surface,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: AppIconTitle(),
              ),
              leadingWidth: 180,
              title: Text(destinations[_getSelectedIndex(context)].routeName.name),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppUserWidget(),
                )
              ],
            ),
            body: Container(),
          ),
        ),
      ],
    );
  }
}
