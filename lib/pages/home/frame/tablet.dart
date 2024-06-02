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
  int destIndex = 0;

  void _updateBody(int index) {
    setState(() {
      destIndex = index;
    });
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
          selectedIndex: destIndex,
          onDestinationSelected: _updateBody,
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
              onPressed: () => context.pushNamed(
                RoutesName.settings.name,
                extra: () => {},
              ),
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
              title: Text(destinations[destIndex].routeName.name),
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
