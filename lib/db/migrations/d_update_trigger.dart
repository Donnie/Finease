import 'package:sqflite/sqflite.dart';

// Deciding not to go ahead with this
// as it would be a malpractice to update accounts
// or amounts in purely financial terms

Future<void> dUpdateEntriesTrigger(Database db) async {
  await db.execute('''
    CREATE TRIGGER UpdateAccountBalanceAfterUpdate
    AFTER UPDATE ON Entries
    WHEN (SELECT currency FROM Accounts WHERE id = OLD.debit_account_id) = 
        (SELECT currency FROM Accounts WHERE id = OLD.credit_account_id) AND
        (SELECT currency FROM Accounts WHERE id = NEW.debit_account_id) = 
        (SELECT currency FROM Accounts WHERE id = NEW.credit_account_id)
    BEGIN
      -- Adjust the balance for the old debit account
      UPDATE Accounts
      SET balance = balance + OLD.amount
      WHERE id = OLD.debit_account_id;

      -- Adjust the balance for the old credit account
      UPDATE Accounts
      SET balance = balance - OLD.amount
      WHERE id = OLD.credit_account_id;

      -- Adjust the balance for the new debit account
      UPDATE Accounts
      SET balance = balance - NEW.amount
      WHERE id = NEW.debit_account_id;

      -- Adjust the balance for the new credit account
      UPDATE Accounts
      SET balance = balance + NEW.amount
      WHERE id = NEW.credit_account_id;
    END;
  ''');
}
