import 'package:finease/pages/settings/export_db.dart';
import 'package:finease/pages/settings/import_db.dart';
import 'package:finease/pages/settings/reset_app.dart';
import 'package:finease/pages/settings/settings_group_card.dart';
import 'package:finease/pages/settings/version_widget.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

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
                const ExportDatabaseWidget(),
                ImportDatabaseWidget(onImport: onFormSubmitted),
                const ResetAppWidget(),
              ],
            ),
            const SettingsGroup(
              title: "Dev Info",
              options: [
                VersionWidget(),
              ],
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  language["madeWithLoveInBerlin"],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
