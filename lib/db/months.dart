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
    String query = '''
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
          COALESCE(SUM(
            CASE 
              WHEN ac.currency = ? THEN e.amount
              ELSE e.amount * (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ac.currency
              )
            END
          ) FILTER (
            WHERE ac.type IN ('asset', 'liability') AND ad.type IN ('income', 'expense')
          ), 0) AS income,
          COALESCE(SUM(
            CASE 
              WHEN ac.currency = ? THEN e.amount
              ELSE e.amount * (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ac.currency
              )
            END
          ) FILTER (
            WHERE ad.type IN ('asset', 'liability') AND ac.type IN ('income', 'expense')
          ), 0) AS expense,
          ? AS currency
        FROM (
          SELECT 
            REPLACE(DATETIME(monthDate, 'start of month'), ' ', 'T') || 'Z' as startDate,
            REPLACE(DATETIME(monthDate, 'start of month', '+1 month', '-1 second'), ' ', 'T') || 'Z' as endDate
          FROM MonthDates
        ) AS months
        LEFT JOIN entries e ON e.date BETWEEN months.startDate AND months.endDate
        LEFT JOIN accounts ac ON e.credit_account_id = ac.id
        LEFT JOIN accounts ad ON e.debit_account_id = ad.id
        GROUP BY months.startDate, months.endDate
      ),
      CumulativeTotals AS (
        SELECT
          startDate as date,
          income,
          expense,
          (income - expense) as effect,
          SUM(income - expense) OVER (ORDER BY startDate ASC) as networth,
          currency
        FROM MonthlyTotals
      )
      SELECT
        date,
        effect,
        expense,
        income,
        networth,
        currency
      FROM CumulativeTotals;
    ''';

    final results = await dbClient.rawQuery(
      query,
      [prefCurrency, prefCurrency, prefCurrency],
    );

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
  String? currency;

  Month({
    this.date,
    this.effect,
    this.expense,
    this.income,
    this.networth,
    this.currency,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      date: DateTime.tryParse(json['date']),
      effect: json['effect'] / 100,
      expense: json['expense'] / 100,
      income: json['income'] / 100,
      networth: json['networth'] / 100,
      currency: json['currency'],
    );
  }

  // Calculate the factor based on the relationship between income and expense
  double get factor {
    if (income == null || expense == null) {
      return 0; // or some default value or handle error
    }
    // Ensure that neither income nor expense is zero to avoid division by zero
    if (income == 0 && expense == 0) {
      return 0.5; // When both are zero, we can define factor as 0.5
    }

    // Bias towards extremes for visibility
    num incomeSquared = income! * income!;
    num expenseSquared = expense! * expense!;
    return (incomeSquared / (incomeSquared + expenseSquared));
  }

  bool get good => factor > 0.5;
}
