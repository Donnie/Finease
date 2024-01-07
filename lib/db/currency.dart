import 'package:finease/core/currency.dart';
import 'package:hive/hive.dart';

class CurrencyBoxService {
  static const String _boxName = 'currencies';
  late Box _box;
  final ExchangeService _currencyService = ExchangeService();

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<Map<String, double>> getLatestRates(String baseCurrency) async {
    final currentDate = DateTime.now();
    final lastUpdate = _box.get('lastUpdate') as DateTime?;

    if (lastUpdate == null || lastUpdate.day != currentDate.day) {
      await _updateRates(baseCurrency);
    }

    return Map<String, double>.from(_box.toMap())
      ..remove('lastUpdate'); // Exclude the 'lastUpdate' key
  }

  Future<double> getSingleRate(
    String baseCurrency,
    String targetCurrency,
  ) async {
    final currentDate = DateTime.now();
    final lastUpdate = _box.get('lastUpdate') as DateTime?;

    if (lastUpdate == null || lastUpdate.day != currentDate.day) {
      await _updateRates(baseCurrency);
    }

    // Retrieve the rate for the targetCurrency and the baseCurrency
    final targetRate = _box.get(targetCurrency) as double?;
    final baseRate = _box.get(baseCurrency) as double?;

    // Check if either rate is null
    if (targetRate == null) {
      throw Exception('Rate for $targetCurrency not found');
    }
    if (baseRate == null) {
      throw Exception('Rate for $baseCurrency not found');
    }

    // Calculate the combined rate
    final combinedRate = targetRate / baseRate;

    return combinedRate;
  }

  Future<void> _updateRates(String baseCurrency) async {
    try {
      final rates = await _currencyService.getExchangeRateMap(baseCurrency);
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
