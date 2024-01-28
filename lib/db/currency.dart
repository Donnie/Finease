import 'package:finease/core/export.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyBoxService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const String _boxName = 'currencies';
  late Box _box;
  late String prefCurrency;
  final ExchangeService _exchangeService = ExchangeService();

  Future<bool> isRequired() async {
    final dbClient = await _databaseHelper.db;
    const String sql = '''
      SELECT COALESCE(COUNT(DISTINCT currency), 0) AS total_count
      FROM (
        SELECT currency FROM Accounts
        UNION
        SELECT value FROM settings WHERE key = 'prefCurrency'
      ) AS combined_currencies;
    ''';
    final List<Map<String, dynamic>> result = await dbClient.rawQuery(sql);

    if (result.isNotEmpty) {
      final num count = result.first['total_count'];
      return count > 1;
    }
    return false;
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final currentDate = DateTime.now();
    final lastUpdate = _box.get('lastUpdate') as DateTime?;
    prefCurrency = await SettingService().getSetting(Setting.prefCurrency);

    // Check if data is older than a day or if no data is available (lastUpdate is null)
    if (lastUpdate == null ||
        lastUpdate.difference(currentDate).inDays.abs() >= 1) {
      try {
        await _updateRates(prefCurrency);
      } on InternetUnavailableError {
        if (lastUpdate == null) {
          // If no data available and there is an InternetUnavailableError, then rethrow it
          rethrow;
        }
        // else, ignore the error because we have data (even if it is outdated)
      } catch (e) {
        // Handle all other exceptions or rethrow as needed
        rethrow;
      }
    }
  }

  Future<void> updateRatesTable() async {
    final dbClient = await _databaseHelper.db;
    Batch batch = dbClient.batch();

    for (var currency in _box.keys) {
      if (currency == "lastUpdate") break;
      final rate = _box.get(currency);
      batch.insert(
        'rates',
        {'currency': currency, 'rate': rate},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<double> getSingleRate(
    String baseCurrency,
    String targetCurrency,
  ) async {
    // Assuming data is always available and up-to-date.
    // Retrieve the rates directly from the box.
    double baseRate = _box.get(baseCurrency) ?? 0;
    double targetRate = _box.get(targetCurrency) ?? 0;

    // rates must be available; if not, throw an exception.
    if (targetRate == 0 || baseRate == 0) {
      throw Exception('Unable to find rate for $baseCurrency/$targetCurrency');
    }

    // Calculate and return the combined rate.
    return targetRate / baseRate;
  }

  Future<void> _updateRates(String baseCurrency) async {
    try {
      final rates = await _exchangeService.getExchangeRateMap(baseCurrency);
      await _box.putAll(rates);
      await _box.put('lastUpdate', DateTime.now());
    } catch (e) {
      rethrow;
    }
  }

  void close() {
    _box.close();
  }
}

// ignore: non_constant_identifier_names
final Map<String, String> SupportedCurrency = {
  "AUD": "A\$", // Australian Dollar
  "BGN": "лв", // Bulgarian Lev
  "BRL": "R\$", // Brazilian Real
  "CAD": "C\$", // Canadian Dollar
  "CHF": "Fr", // Swiss Franc
  "CNY": "¥", // Chinese Yuan
  "CZK": "Kč", // Czech Koruna
  "DKK": "kr", // Danish Krone
  "EUR": "€", // Euro
  "GBP": "£", // British Pound
  "HKD": "HK\$", // Hong Kong Dollar
  "HUF": "Ft", // Hungarian Forint
  "IDR": "Rp", // Indonesian Rupiah
  "ILS": "₪", // Israeli New Shekel
  "INR": "₹", // Indian Rupee
  "ISK": "kr", // Icelandic Króna
  "JPY": "¥", // Japanese Yen
  "KRW": "₩", // South Korean Won
  "MXN": "Mex\$", // Mexican Peso
  "MYR": "RM", // Malaysian Ringgit
  "NOK": "kr", // Norwegian Krone
  "NZD": "NZ\$", // New Zealand Dollar
  "PHP": "₱", // Philippine Peso
  "PLN": "zł", // Polish Zloty
  "RON": "lei", // Romanian Leu
  "SEK": "kr", // Swedish Krona
  "SGD": "S\$", // Singapore Dollar
  "THB": "฿", // Thai Baht
  "TRY": "₺", // Turkish Lira
  "USD": "\$", // United States Dollar
  "ZAR": "R", // South African Rand
};
