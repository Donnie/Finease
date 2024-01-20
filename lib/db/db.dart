import 'package:finease/db/migrations/a_initial_migration.dart';
import 'package:finease/db/migrations/b_add_indices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static Database? _db;

  static const String _databaseName = "main.db";

  Future<String> get _databasePath async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    return "${documentDirectory.path}/$_databaseName";
  }

  Future<String> getDatabasePath() async {
    return await _databasePath;
  }

  Future<Database> get db async {
    _db ??= await ensureDatabaseOpened();
    return _db!;
  }

  Future<Database> ensureDatabaseOpened() async {
    if (_db == null) {
      String path = await _databasePath;
      _db = await initDb(path);
    }
    return _db!;
  }

  Future<Database> initDb(String path) async {
    var ourDb = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return ourDb;
  }

  Future<void> _onCreate(Database db, int version) async {
    await aInitialMigration(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await bAddIndices(db);
    }
    if (oldVersion < 3) {
      // Execute next migration
    }
  }

  Future<void> clearDatabase() async {
    var dbClient = await db;
    await dbClient.close(); // Close the database connection
    String path = await _databasePath;

    await deleteDatabase(path); // Delete the database file
    _db = null; // Reset the _db variable
    await ensureDatabaseOpened(); // Reinitialize the database
  }

  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  Future<void> importNewDatabase(String newDbPath) async {
    final currentDbPath = await getDatabasePath();
    await clearDatabase();
    await File(newDbPath).copy(currentDbPath);
    await File(newDbPath).delete();
    await closeDatabase();
    await ensureDatabaseOpened();
  }
}
