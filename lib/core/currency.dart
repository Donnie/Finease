import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ExchangeService {
  final String url =
      'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml';

  Future<Map<String, double>> getExchangeRateMap(String baseCurrency) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load currency data');
    }

    final document = XmlDocument.parse(response.body);
    final rates = _parseRates(document);

    if (!rates.containsKey(baseCurrency)) {
      throw Exception('Base currency not found');
    }

    final baseRate = rates[baseCurrency]!;
    return rates.map((currency, rate) => MapEntry(currency, rate / baseRate));
  }

  Map<String, double> _parseRates(XmlDocument document) {
    final rates = <String, double>{};
    final elements = document.findAllElements('Cube');

    for (var element in elements) {
      final currency = element.getAttribute('currency');
      final rate = element.getAttribute('rate');

      if (currency != null && rate != null) {
        rates[currency] = double.parse(rate);
      }
    }

    // Adding EUR since it's the base rate in the XML and is not listed
    rates['EUR'] = 1.0;

    return rates;
  }
}
