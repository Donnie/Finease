import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';

class MonthService {
  final DatabaseHelper _databaseHelper;

  MonthService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<List<Month>> getAllMonthsInsights() async {
    String prefCurrency =
        await SettingService().getSetting(Setting.prefCurrency);

    final dbClient = await _databaseHelper.db;
    final results = await dbClient.rawQuery('''
      WITH RECURSIVE MonthDates(monthDate) AS (
        SELECT DATETIME((SELECT MIN(date) FROM entries), 'start of month')
        UNION ALL
        SELECT DATETIME(monthDate, '+1 month')
        FROM MonthDates
        WHERE DATETIME(monthDate, '+1 month') < CURRENT_DATE
      ),
      MonthlyTotals AS (
        SELECT 
          months.startDate,
          months.endDate,
          COALESCE((
            SELECT
              SUM(e.amount)
            FROM entries AS e
            LEFT JOIN accounts AS ac ON e.credit_account_id = ac.id
            LEFT JOIN accounts AS ad ON e.debit_account_id = ad.id
            WHERE
              ac.type IN ('asset', 'liability') AND ad.type IN ('income', 'expense')
              AND e.date BETWEEN months.startDate AND months.endDate
              AND ac.currency = '$prefCurrency'
              AND ad.currency = '$prefCurrency'
          ), 0) AS income,
          COALESCE((
            SELECT
              SUM(e.amount)
            FROM entries AS e
            LEFT JOIN accounts AS ac ON e.credit_account_id = ac.id
            LEFT JOIN accounts AS ad ON e.debit_account_id = ad.id
            WHERE
              ad.type IN ('asset', 'liability') AND ac.type IN ('income', 'expense')
              AND e.date BETWEEN months.startDate AND months.endDate
              AND ac.currency = '$prefCurrency'
              AND ad.currency = '$prefCurrency'
          ), 0) AS expense
        FROM (
          SELECT 
            REPLACE(DATETIME(monthDate, 'start of month'), ' ', 'T') || 'Z' as startDate,
            REPLACE(DATETIME(monthDate, 'start of month', '+1 month', '-1 second'), ' ', 'T') || 'Z' as endDate
          FROM MonthDates
        ) AS months
      ),
      CumulativeTotals AS (
        SELECT
          startDate as date,
          income,
          expense,
          (income - expense) as effect,
          SUM(income - expense) OVER (ORDER BY startDate ASC) as networth
        FROM MonthlyTotals
      )
      SELECT
        date,
        effect,
        expense,
        income,
        networth
      FROM CumulativeTotals;
    ''');

    try {
      return results.map((json) => Month.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}

class Month {
  DateTime? date;
  num? effect;
  num? expense;
  num? income;
  num? networth;

  Month({
    this.date,
    this.effect,
    this.expense,
    this.income,
    this.networth,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      date: DateTime.tryParse(json['date']),
      effect: json['effect'] / 100,
      expense: json['expense'] / 100,
      income: json['income'] / 100,
      networth: json['networth'] / 100,
    );
  }
}
