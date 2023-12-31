import 'package:finease/db/db.dart';
import 'package:sqflite/sqflite.dart';

class SettingService {
  final DatabaseHelper _databaseHelper;

  SettingService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<int> createSetting(String key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.insert(
      'Settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<String?> getSetting(String key) async {
    final dbClient = await _databaseHelper.db;
    final maps = await dbClient.query(
      'Settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<int> setSetting(String key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.insert(
      'Settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSetting(String key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.update(
      'Settings',
      {'value': value},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<int> deleteSetting(String key) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.delete(
      'Settings',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
