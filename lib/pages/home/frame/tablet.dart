import 'package:finease/core/common.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/pages/home/summary/main.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePageTablet extends StatelessWidget {
  const HomePageTablet({
    super.key,
    required this.floatingActionButton,
    required this.destinations,
  });

  final List<Destination> destinations;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        NavigationRail(
          groupAlignment: 0,
          leading: floatingActionButton,
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
          selectedIndex: 0,
          onDestinationSelected: (index) {
            switch (index) {
              case 7:
                context.pushNamed(RoutesName.settings.name);
                break;
              default:
            }
          },
          minWidth: 55,
          useIndicator: true,
          destinations: [
            ...destinations.map((e) => NavigationRailDestination(
                  icon: e.icon,
                  selectedIcon: e.selectedIcon,
                  label: Text(e.pageType.name(context)),
                )),
            NavigationRailDestination(
              icon: Icon(MdiIcons.cog),
              label: Text(
                language["settings"],
              ),
            )
          ],
        ),
        VerticalDivider(
          thickness: 1,
          width: 1,
          color: context.background,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: AppIconTitle(),
              ),
              leadingWidth: 180,
              title: const Text("Home"),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppUserWidget(),
                )
              ],
            ),
            body: const SummaryPage(),
          ),
        ),
      ],
    );
  }
}
