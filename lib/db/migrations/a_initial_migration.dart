import 'package:sqflite/sqflite.dart';

Future<void> aInitialMigration(Database db) async {
  await db.execute('''
    CREATE TABLE Accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      currency TEXT NOT NULL,
      name TEXT NOT NULL,
      type TEXT CHECK(type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE')),
      balance BIGINT NOT NULL DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''');

  await db.execute('''
    CREATE TABLE Entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      debit_account_id INTEGER NOT NULL,
      credit_account_id INTEGER NOT NULL,
      amount BIGINT NOT NULL,
      notes TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME NULL,
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
