import 'package:sqflite/sqflite.dart';

Future<void> aInitialMigration(Database db) async {
  await db.execute('''
    CREATE TABLE Accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      balance BIGINT NOT NULL DEFAULT 0,
      currency TEXT CHECK (length(currency) = 3),
      liquid BOOLEAN,
      name TEXT NOT NULL,
      type TEXT CHECK(type IN ('asset', 'liability', 'income', 'expense'))
    )
  ''');

  await db.execute('''
    CREATE TABLE Entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      debit_account_id INTEGER NOT NULL,
      credit_account_id INTEGER NOT NULL,
      amount BIGINT NOT NULL,
      date DATETIME DEFAULT CURRENT_TIMESTAMP,
      notes TEXT,
      FOREIGN KEY (debit_account_id) REFERENCES Accounts(id),
      FOREIGN KEY (credit_account_id) REFERENCES Accounts(id)
    )
  ''');

  await db.execute('''
    CREATE TRIGGER UpdateAccountBalanceAfterInsert
    AFTER INSERT ON Entries
    BEGIN
      UPDATE Accounts
      SET balance = balance - NEW.amount
      WHERE id = NEW.credit_account_id;
      UPDATE Accounts
      SET balance = balance + NEW.amount
      WHERE id = NEW.debit_account_id;
    END;
  ''');

  await db.execute('''
    CREATE TABLE Settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE,
      value TEXT NOT NULL
    )
  ''');

  await db.execute('''
    INSERT INTO Accounts (currency, liquid, name, type)
    VALUES ('EUR', 1, 'Past', 'income');
  ''');

  await db.execute('''
    INSERT INTO Settings (key, value)
    VALUES ('pastAccount', '1');
  ''');
}
