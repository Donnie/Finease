import 'package:sqflite/sqflite.dart';

Future<void> cAddRates(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS rates (
      currency TEXT PRIMARY KEY,
      rate DECIMAL(10, 6) NOT NULL
    );
  ''');
}
