import 'package:sqflite/sqflite.dart';

Future<void> aInitialMigration(Database db) async {
  await db.execute(
      'CREATE TABLE Messages(id INTEGER PRIMARY'
      'KEY, text TEXT, type TEXT, created_at INTEGER)');
}
