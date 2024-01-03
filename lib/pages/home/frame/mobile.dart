import 'package:finease/core/common.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({
    super.key,
    required this.floatingActionButton,
    required this.destinations,
  });

  final List<Destination> destinations;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 8;
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: SafeArea(
          top: true,
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              clipBehavior: Clip.antiAlias,
              child: AppBar(
                backgroundColor: context.secondaryContainer.withOpacity(0.5),
                scrolledUnderElevation: 0,
                title: Text(
                  "Home",
                  style: context.titleMedium,
                ),
                actions: const [
                  AppUserWidget(),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (i) {
          _scaffoldStateKey.currentState?.closeDrawer();
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
                // context.pushNamed(RoutesName.setting.name);
                // Navigator.pop(context);
              },
              leading: const Icon(Icons.settings),
              title: Text(
                language["settings"],
                style: context.bodyLarge,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        children: [
          Center(
            child: Container(),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
