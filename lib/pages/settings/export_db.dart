import 'package:finease/db/db.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ExportDatabaseWidget extends StatelessWidget {
  const ExportDatabaseWidget({super.key});

  Future<bool> _exportDatabase() async {
    try {
      final databasePath = await DatabaseHelper().getDatabasePath();
      final databaseFile = XFile(databasePath);
      await Share.shareXFiles([databaseFile],
          text: 'Here is my database file.');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Export DB"),
      leading: Icon(MdiIcons.export),
      onTap: _exportDatabase,
    );
  }
}
