import 'package:finease/core/export.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class ImportDatabaseWidget extends StatefulWidget {
  final Function onImport;
  const ImportDatabaseWidget({
    super.key,
    required this.onImport,
  });

  @override
  ImportDatabaseWidgetState createState() => ImportDatabaseWidgetState();
}

class ImportDatabaseWidgetState extends State<ImportDatabaseWidget> {
  final SettingService settingService = SettingService();
  final DatabaseHelper db = DatabaseHelper();

  Future<void> _onImportTap() async {
    bool confirmed = await _showImportConfirmationDialog();
    if (!confirmed) return;

    String? filePath = await _pickFile();
    if (filePath == null) return;

    bool importSuccessful = await _importDatabase(filePath);
    if (importSuccessful) {
      // ignore: use_build_context_synchronously
      context.pop();
      widget.onImport();
    }
  }

  Future<bool> _showImportConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Import Database"),
              content: const Text(
                  "Are you sure you want to import the database? This will replace the current database!"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text("Import"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return result.files.single.path;
    }
    return null;
  }

  Future<bool> _importDatabase(String filePath) async {
    final String ext = path.extension(filePath);
    String newPath = filePath;

    if (ext == ".enc") {
      newPath = path.join(path.dirname(filePath), "database.db");
      if (!await _handleEncryption(filePath, newPath)) {
        return false;
      }
    }

    await db.importNewDatabase(newPath);
    return true;
  }

  Future<bool> _handleEncryption(String oldPath, String newPath) async {
    String dbPassword = await settingService.getSetting(Setting.dbPassword);
    if (dbPassword.isEmpty) {
      await _showEncryptionAlert();
      return false;
    }

    try {
      await decryptFile(oldPath, newPath, dbPassword);
      return true;
    } catch (e) {
      await _showPaddingErrorAlert();
      return false;
    }
  }

  Future<void> _showEncryptionAlert() async => showErrorDialog(
        'Please Enable Encryption in the Settings'
        ' before importing an encrypted database.',
        context,
      );

  Future<void> _showPaddingErrorAlert() async => showErrorDialog(
        'The database file could not be recovered!',
        context,
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Import DB"),
      leading: Icon(MdiIcons.import),
      onTap: _onImportTap,
    );
  }
}
