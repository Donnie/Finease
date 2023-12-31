import 'package:sqflite/sqflite.dart';

Future<void> aInitialMigration(Database db) async {
  await db.execute('''
    CREATE TABLE Accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT CHECK(type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE')),
      balance DECIMAL(19, 4) NOT NULL DEFAULT 0.0
    )
  ''');

  await db.execute('''
    CREATE TABLE Transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      date DATETIME DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'NOW'))
    )
  ''');

  await db.execute('''
    CREATE TABLE Entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      transaction_id INTEGER NOT NULL,
      debit_account_id INTEGER NOT NULL,
      credit_account_id INTEGER NOT NULL,
      amount DECIMAL(19, 4) NOT NULL,
      FOREIGN KEY (transaction_id) REFERENCES Transactions(id),
      FOREIGN KEY (debit_account_id) REFERENCES Accounts(id),
      FOREIGN KEY (credit_account_id) REFERENCES Accounts(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE Settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      setting_key TEXT NOT NULL UNIQUE,
      setting_value TEXT NOT NULL,
      setting_type TEXT NOT NULL
    )
  ''');

  await db.execute('''
    CREATE TABLE Messages(
      id INTEGER PRIMARY KEY,
      text TEXT,
      type TEXT,
      created_at INTEGER
    )
  ''');
}
