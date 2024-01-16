import 'package:finease/db/db.dart';

class MonthService {
  final DatabaseHelper _databaseHelper;

  MonthService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<List<Map<String, dynamic>>> getAllMonthsInsights() async {
    final dbClient = await _databaseHelper.db;
    final result = await dbClient.rawQuery('''
      WITH RECURSIVE MonthDates(monthDate) AS (
        SELECT DATETIME((SELECT MIN(date) FROM entries))
        UNION ALL
        SELECT DATETIME(monthDate, '+1 month')
        FROM MonthDates
        WHERE DATETIME(monthDate, '+1 month') < CURRENT_DATE
      )
      SELECT
        months.startDate as month,
        COALESCE((
          SELECT
            SUM(
              CASE
                WHEN ac.type IN ('asset', 'liability') AND ad.type IN ('income', 'expense') THEN amount
                WHEN ad.type IN ('asset', 'liability') AND ac.type IN ('income', 'expense') THEN -amount
              END
            ) as delta
          FROM entries AS e
          LEFT JOIN accounts AS ac ON e.credit_account_id = ac.id
          LEFT JOIN accounts AS ad ON e.debit_account_id = ad.id
          WHERE
            e.date BETWEEN months.startDate AND months.endDate
        ), 0) as effect
      FROM (
        SELECT REPLACE(DATETIME(monthDate, 'start of month'), ' ', 'T') || 'Z' as startDate,
          REPLACE(DATETIME(monthDate, 'start of month', '+1 month', '-1 second'), ' ', 'T') || 'Z' as endDate
        FROM MonthDates
      ) AS months;
    ''');

    return result.map((row) {
      return {'month': row['month'], 'savings': row['savings']};
    }).toList();
  }
}
