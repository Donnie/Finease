import 'package:finease/routes/routes_name.dart';
import 'package:finease/core/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SetupAccountsPage extends StatefulWidget {
  const SetupAccountsPage({
    super.key,
  });

  @override
  State<SetupAccountsPage> createState() => _SetupAccountsPageState();
}

class _SetupAccountsPageState extends State<SetupAccountsPage> {
  final SettingService _settingService = SettingService();
  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: const SetupAccountsWidget(),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FloatingActionButton.extended(
                  heroTag: 'backButton',
                  onPressed: () {
                    _settingService.deleteSetting(Setting.accountSetup);
                    context.go(RoutesName.addName.path);
                  },
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                  label: Text(
                    language["back"],
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  icon: Icon(MdiIcons.arrowLeft),
                ),
                const Spacer(),
                FloatingActionButton.extended(
                  heroTag: 'next',
                  onPressed: () {
                    _settingService.setSetting(Setting.accountSetup, "true");
                    _settingService.setSetting(Setting.onboarded, "true");
                    context.go(RoutesName.home.path);
                  },
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                  label: Icon(MdiIcons.arrowRight),
                  icon: Text(
                    language["next"],
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
