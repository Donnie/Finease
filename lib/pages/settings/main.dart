import 'package:finease/pages/export.dart';
import 'package:finease/pages/settings/about.dart';
import 'package:finease/pages/settings/capital_gains.dart';
import 'package:finease/pages/settings/check_updates.dart';
import 'package:finease/pages/settings/currency.dart';
import 'package:finease/pages/settings/dark_mode.dart';
import 'package:finease/pages/settings/theme_selector.dart';
import 'package:finease/pages/settings/toggle_encryption.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  void _handleChange(BuildContext context) {
    // Pop back with true to indicate a change was made
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: Colors.transparent,
      child: Scaffold(
        appBar: appBar(context, "settings"),
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            SettingsGroup(
              title: "Personalise",
              options: [
                CurrencySelectorWidget(onChange: () => _handleChange(context)),
                const CapGainsSelectorWidget(),
                const ThemeSelectorWidget(),
                DarkModeToggleWidget(onChange: () => _handleChange(context)),
              ],
            ),
            SettingsGroup(
              title: "Database",
              options: [
                const ToggleEncryptionWidget(),
                const ExportDatabaseWidget(),
                ImportDatabaseWidget(onImport: () => _handleChange(context)),
                const ResetAppWidget(),
              ],
            ),
            const SettingsGroup(
              title: "Dev Info",
              options: [
                AboutWidget(),
                CheckUpdatesWidget(),
                VersionWidget(),
              ],
            ),
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Made with ♥ in Berlin"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
