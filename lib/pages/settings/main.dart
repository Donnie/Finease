import 'package:finease/pages/export.dart';
import 'package:finease/pages/settings/about.dart';
import 'package:finease/pages/settings/toggle_encryption.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';

class SettingsPage extends StatelessWidget {
  final Function onFormSubmitted;
  const SettingsPage({
    super.key,
    required this.onFormSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 8;
    return AppAnnotatedRegionWidget(
      color: Colors.transparent,
      child: Scaffold(
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
                  title: Text("settings", style: context.titleMedium),
                ),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
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
