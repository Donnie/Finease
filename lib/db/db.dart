import 'package:fineas/db/migrations/a_initial_migration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fineas/backend/message.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static Database? _db;

  static const String _databaseName = "main.db";
  static const String _tableName = "Messages";

  Future<String> get _databasePath async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    return "${documentDirectory.path}/$_databaseName";
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = await _databasePath;
    var ourDb = await openDatabase(
      path,
      version: 1,
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
      // await addNewColumn(db);
    }
    if (oldVersion < 3) {
      // Execute next migration
    }
    // Add additional checks for further versions
  }

  // Save and get messages
  Future<int> saveMessage(Message message) async {
    var dbClient = await db;
    int res = await dbClient.insert(_tableName, message.toMap());
    return res;
  }

  Future<List<Message>> getMessages() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM $_tableName ORDER BY created_at DESC');
    List<Message> messages = list.isNotEmpty
        ? list
            .map((item) => Message.fromMap(item.cast<String, dynamic>()))
            .toList()
        : [];
    return messages;
  }

  Future<void> clearDatabase() async {
    var dbClient = await db;
    await dbClient.close(); // Close the database connection

    String path = await _databasePath;

    await deleteDatabase(path); // Delete the database file

    _db = null; // Reset the _db variable
    await initDb(); // Reinitialize the database
  }
}
