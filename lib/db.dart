import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:finease/message.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentDirectory.path}/main.db";
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Messages(id INTEGER PRIMARY KEY, text TEXT, type TEXT)",
    );
  }

  // Save and get messages
  Future<int> saveMessage(Message message) async {
    var dbClient = await db;
    int res = await dbClient.insert("Messages", message.toMap());
    return res;
  }

  Future<List<Message>> getMessages() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Messages');
    List<Message> messages = list.isNotEmpty
        ? list.map((item) => Message.fromMap(item.cast<String, dynamic>())).toList()
        : [];
    return messages;
  }
}
