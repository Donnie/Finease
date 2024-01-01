import 'package:finease/config/routes_name.dart';
import 'package:finease/core/common.dart';
import 'package:finease/widgets/export.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/widgets/add_account.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddAccountsPage extends StatefulWidget {
  const AddAccountsPage({
    super.key,
    this.forceCountrySelector = false,
  });
  final bool forceCountrySelector;

  @override
  State<AddAccountsPage> createState() => _AddAccountsPageState();
}

class _AddAccountsPageState extends State<AddAccountsPage> {
  final SettingService _settingService = SettingService();

  @override
  void initState() {
    super.initState();
  }
  
  void saveAccountAndNavigate() async {
    await _settingService.setSetting(Setting.accountSetup, "true");
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FloatingActionButton.extended(
                  heroTag: 'backButton',
                  onPressed: () {
                    SettingService().deleteSetting(Setting.accountSetup);
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
                    saveAccountAndNavigate();
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
        body: const IntroAccountAddWidget(),
      ),
    );
  }
}
