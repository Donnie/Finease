import 'package:sqflite/sqflite.dart';

Future<void> aInitialMigration(Database db) async {
  await db.execute('''
    CREATE TABLE Accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME,
      balance BIGINT NOT NULL DEFAULT 0,
      currency TEXT NOT NULL,
      liquid BOOLEAN,
      name TEXT NOT NULL,
      debit BOOLEAN
    )
  ''');

  await db.execute('''
    CREATE TABLE Entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME,
      debit_account_id INTEGER NOT NULL,
      credit_account_id INTEGER NOT NULL,
      amount BIGINT NOT NULL,
      date DATETIME,
      notes TEXT,
      FOREIGN KEY (debit_account_id) REFERENCES Accounts(id),
      FOREIGN KEY (credit_account_id) REFERENCES Accounts(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE Settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE,
      value TEXT NOT NULL
    )
  ''');
}
