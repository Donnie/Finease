import 'package:finease/core/export.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class ImportDatabaseWidget extends StatelessWidget {
  final Function onImport;
  const ImportDatabaseWidget({
    super.key,
    required this.onImport,
  });

  Future<bool> _importDatabase(BuildContext context) async {
    final SettingService settingService = SettingService();

    bool confirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Import Database"),
              content: const Text(
                  "Are you sure you want to import a new database? This will replace the current database!"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Dismisses the dialog and returns false
                  },
                ),
                TextButton(
                  child: const Text("Import"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Dismisses the dialog and returns true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // In case the dialog is dismissed by tapping outside of it

    if (!confirmed) {
      return false;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      final String ext = path.extension(filePath);
      String newPath = filePath;

      if (ext == ".enc") {
        newPath = path.join(path.dirname(filePath), "database.db");
        String dbPassword =
            await settingService.getSetting(Setting.dbPassword);
        await decryptFile(filePath, newPath, dbPassword);
      }

      await DatabaseHelper().importNewDatabase(newPath);
      // ignore: use_build_context_synchronously
      context.pop();
      onImport();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Import DB"),
      leading: Icon(MdiIcons.import),
      onTap: () => _importDatabase(context),
    );
  }
}
