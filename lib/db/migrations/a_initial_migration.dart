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
      hidden BOOLEAN,
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
    WHEN (SELECT currency FROM Accounts WHERE id = NEW.debit_account_id) = 
        (SELECT currency FROM Accounts WHERE id = NEW.credit_account_id)
    BEGIN
      UPDATE Accounts
      SET balance = balance + NEW.amount
      WHERE id = NEW.credit_account_id;
      UPDATE Accounts
      SET balance = balance - NEW.amount
      WHERE id = NEW.debit_account_id;
    END;
  ''');

  await db.execute('''
    CREATE TRIGGER UpdateAccountBalanceAfterDelete
    BEFORE DELETE ON Entries
    WHEN (SELECT currency FROM Accounts WHERE id = OLD.debit_account_id) = 
        (SELECT currency FROM Accounts WHERE id = OLD.credit_account_id)
    BEGIN
      UPDATE Accounts
      SET balance = balance - OLD.amount
      WHERE id = OLD.credit_account_id;
      UPDATE Accounts
      SET balance = balance + OLD.amount
      WHERE id = OLD.debit_account_id;
    END;
  ''');

  await db.execute('''
    CREATE TRIGGER PreventDifferentCurrencyInsert
    BEFORE INSERT ON Entries
    FOR EACH ROW
    BEGIN
      SELECT
        CASE
          WHEN (SELECT currency FROM Accounts WHERE id = NEW.debit_account_id) !=
              (SELECT currency FROM Accounts WHERE id = NEW.credit_account_id) THEN
            RAISE(FAIL, 'Debit and Credit accounts must have the same currency')
        END;
    END;
  ''');

  await db.execute('''
    CREATE TABLE Settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE,
      value TEXT NOT NULL
    )
  ''');
}
