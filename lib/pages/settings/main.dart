import 'package:finease/pages/export.dart';
import 'package:finease/pages/settings/about.dart';
import 'package:finease/pages/settings/capital_gains.dart';
import 'package:finease/pages/settings/currency.dart';
import 'package:finease/pages/settings/dark_mode.dart';
import 'package:finease/pages/settings/toggle_encryption.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function onFormSubmitted;
  const SettingsPage({
    super.key,
    required this.onFormSubmitted,
  });

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
                CurrencySelectorWidget(onChange: onFormSubmitted),
                const CapGainsSelectorWidget(),
                DarkModeToggleWidget(onChange: onFormSubmitted),
              ],
            ),
            SettingsGroup(
              title: "Database",
              options: [
                const ToggleEncryptionWidget(),
                const ExportDatabaseWidget(),
                ImportDatabaseWidget(onImport: onFormSubmitted),
                const ResetAppWidget(),
              ],
            ),
            const SettingsGroup(
              title: "Dev Info",
              options: [
                AboutWidget(),
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
