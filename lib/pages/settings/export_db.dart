import 'dart:io';
import 'package:finease/db/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path; // Add this import for file path manipulation

class ExportDatabaseWidget extends StatelessWidget {
  const ExportDatabaseWidget({super.key});

  Future<bool> _exportDatabase() async {
    try {
      final databasePath = await DatabaseHelper().getDatabasePath();
      final time = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final dir = path.dirname(databasePath);
      final ext = path.extension(databasePath);
      final newFilename = 'database_$time$ext';
      final newPath = path.join(dir, newFilename);

      final databaseFile = File(databasePath);
      final newDatabaseFile = await databaseFile.copy(newPath);
      final xFile = XFile(newDatabaseFile.path);

      await Share.shareXFiles([xFile], text: 'Here is my database file.');
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
