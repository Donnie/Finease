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
      color: context.surface,
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
                  onPressed: () async {
                    // Set default settings during onboarding
                    await _settingService.setSetting(Setting.accountSetup, "true");
                    await _settingService.setSetting(Setting.onboarded, "true");
                    
                    // Set default background image to none
                    await _settingService.setSetting(Setting.backgroundImage, "none");
                    
                    // Set default glassmorphic blur to 18
                    await _settingService.setSetting(Setting.glassmorphicBlur, "18.0");
                    
                    // Set default glassmorphic opacity to 50% (0.5)
                    await _settingService.setSetting(Setting.glassmorphicOpacity, "0.5");
                    
                    // Set dark mode to disabled (false)
                    await _settingService.setSetting(Setting.darkMode, "false");
                    
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
