import 'package:finease/db/db.dart';
import 'package:sqflite/sqflite.dart';

enum Setting {
  introDone,
  userName,
  accountSetup,
}

typedef Settings = Map<Setting, String>;

class SettingService {
  final DatabaseHelper _databaseHelper;

  SettingService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  final Map<Setting, String> _settingKeys = {
    Setting.introDone: 'introDone',
    Setting.userName: 'userName',
    Setting.accountSetup: 'accountSetup',
  };

  Future<int> createSetting(Setting key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.insert(
      'Settings',
      {'key': _settingKeys[key], 'value': value},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<String> getSetting(Setting key) async {
    final dbClient = await _databaseHelper.db;
    final maps = await dbClient.query(
      'Settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [_settingKeys[key]],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return "";
  }

  Future<Settings> loadSettings() async {
    final dbClient = await _databaseHelper.db;
    final maps = await dbClient.query('Settings', columns: ['key', 'value']);
    
    Settings settings = {};

    for (var map in maps) {
      final keyAsString = map['key'] as String?;
      final value = map['value'] as String?;

      if (keyAsString != null && value != null) {
        final key = _settingKeys.entries
            .firstWhere((entry) => entry.value == keyAsString).key;
        settings[key] = value;
      }
    }

    return settings;
  }

  Future<int> setSetting(Setting key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.insert(
      'Settings',
      {'key': _settingKeys[key], 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSetting(Setting key, String value) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.update(
      'Settings',
      {'value': value},
      where: 'key = ?',
      whereArgs: [_settingKeys[key]],
    );
  }

  Future<int> deleteSetting(Setting key) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.delete(
      'Settings',
      where: 'key = ?',
      whereArgs: [_settingKeys[key]],
    );
  }
}
