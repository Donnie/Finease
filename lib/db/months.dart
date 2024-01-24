import 'package:finease/db/db.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/settings.dart';

class MonthService {
  final DatabaseHelper _databaseHelper;
  final CurrencyBoxService currencyBoxService = CurrencyBoxService();

  MonthService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<List<Month>> getAllMonthsInsights() async {
    String prefCurrency =
        await SettingService().getSetting(Setting.prefCurrency);

    await currencyBoxService.init();
    await currencyBoxService.updateRatesTable();

    final dbClient = await _databaseHelper.db;
    String query = '''
      WITH RECURSIVE MonthDates(monthDate) AS (
        SELECT DATETIME((SELECT MIN(date) FROM entries), 'start of month')
        UNION ALL
        SELECT DATETIME(monthDate, '+1 month')
        FROM MonthDates
        WHERE DATETIME(monthDate, '+1 month') < CURRENT_DATE
      ),
      ForexPairs AS (
        SELECT
          MIN(e.id) AS forex_debit_id,
          MAX(e.id) AS forex_credit_id
        FROM
          entries e
          INNER JOIN accounts a ON e.credit_account_id = a.id OR e.debit_account_id = a.id
        WHERE
          a.name = 'Forex'
        GROUP BY
          e.date
      ),
      ConsolidatedForex AS (
        SELECT
          f.forex_debit_id AS id,
          e1.created_at,
          e1.updated_at,
          e1.debit_account_id,
          e2.credit_account_id,
          e2.amount,
          e1.date,
          e2.notes
        FROM
          ForexPairs f
          JOIN entries e1 ON f.forex_debit_id = e1.id
          JOIN entries e2 ON f.forex_credit_id = e2.id
      ),
      NonForexEntries AS (
        SELECT *
        FROM entries
        WHERE id NOT IN (SELECT forex_debit_id FROM ForexPairs)
          AND id NOT IN (SELECT forex_credit_id FROM ForexPairs)
      ),
      ConsolidatedEntries AS (
        SELECT *
        FROM ConsolidatedForex
        UNION ALL
        SELECT *
        FROM NonForexEntries
      ),
      MonthlyTotals AS (
        SELECT
          months.startDate,
          months.endDate,
          COALESCE(SUM(
            CASE
              WHEN ac.currency = ? THEN e.amount
              ELSE e.amount / (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ac.currency
              ) * (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ?
              )
            END
          ) FILTER (
            WHERE ac.type IN ('asset', 'liability') AND ad.type IN ('income', 'expense')
          ), 0) AS income,
          COALESCE(SUM(
            CASE
              WHEN ac.currency = ? THEN e.amount
              ELSE e.amount / (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ac.currency
              ) * (
                SELECT cr.rate FROM rates cr
                WHERE cr.currency = ?
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
        LEFT JOIN ConsolidatedEntries e ON e.date BETWEEN months.startDate AND months.endDate
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
      [prefCurrency, prefCurrency, prefCurrency, prefCurrency, prefCurrency],
    );
    currencyBoxService.close();

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
