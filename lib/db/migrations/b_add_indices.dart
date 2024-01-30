import 'package:sqflite/sqflite.dart';

Future<void> bAddIndices(Database db) async {
  await db.execute('''
    CREATE INDEX idx_accounts_id ON Accounts(id);
    CREATE INDEX idx_accounts_balance ON Accounts(balance);
    CREATE INDEX idx_accounts_currency ON Accounts(currency);
    CREATE INDEX idx_accounts_liquid ON Accounts(liquid);
    CREATE INDEX idx_accounts_hidden ON Accounts(hidden);
    CREATE INDEX idx_accounts_name ON Accounts(name);
    CREATE INDEX idx_accounts_type ON Accounts(type);

    CREATE INDEX idx_entries_id ON Entries(id);
    CREATE INDEX idx_entries_debit_account_id ON Entries(debit_account_id);
    CREATE INDEX idx_entries_credit_account_id ON Entries(credit_account_id);
    CREATE INDEX idx_entries_amount ON Entries(amount);
    CREATE INDEX idx_entries_date ON Entries(date);
    CREATE INDEX idx_entries_notes ON Entries(notes);

    CREATE INDEX idx_settings_key ON Settings(key);
  ''');
}
