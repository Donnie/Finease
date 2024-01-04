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
      String baseCurrency, String targetCurrency) async {
    final currentDate = DateTime.now();
    final lastUpdate = _box.get('lastUpdate') as DateTime?;

    if (lastUpdate == null || lastUpdate.day != currentDate.day) {
      await _updateRates(baseCurrency);
    }

    final rate = _box.get(targetCurrency) as double?;
    if (rate == null) {
      throw Exception('Rate for $targetCurrency not found');
    }

    return rate;
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
final List<String> SupportedCurrency = [
  "AUD",
  "BGN",
  "BRL",
  "CAD",
  "CHF",
  "CNY",
  "CZK",
  "DKK",
  "GBP",
  "HKD",
  "HUF",
  "IDR",
  "ILS",
  "INR",
  "ISK",
  "JPY",
  "KRW",
  "MXN",
  "MYR",
  "NOK",
  "NZD",
  "PHP",
  "PLN",
  "RON",
  "SEK",
  "SGD",
  "THB",
  "TRY",
  "USD",
  "ZAR",
];
