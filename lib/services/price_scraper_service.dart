import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class PriceScraperService {
  const PriceScraperService();

  Future<double?> scrapePrice(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: const {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      );
      if (response.statusCode != 200) return null;

      final document = html_parser.parse(response.body);
      const selectors = <String>[
        '#priceblock_ourprice',
        '#priceblock_dealprice',
        '.a-price .a-offscreen',
        '.priceToPay .a-offscreen',
        '.Nx9bqj',
        '.CxhGGd',
        '[itemprop="price"]',
        'meta[property="product:price:amount"]',
        'meta[name="twitter:data1"]',
        '.price',
      ];

      for (final selector in selectors) {
        final element = document.querySelector(selector);
        final text = element?.attributes['content'] ?? element?.text;
        if (text != null) {
          final price = _extractPrice(text);
          if (price != null) return price;
        }
      }

      return _extractPrice(document.body?.text ?? '');
    } catch (_) {
      return null;
    }
  }

  double? _extractPrice(String text) {
    final currencyRegex = RegExp(r'(?:₹|\$|€|£)\s?([\d,]+(?:\.\d{1,2})?)');
    final currencyMatch = currencyRegex.firstMatch(text);
    if (currencyMatch != null) {
      final clean = currencyMatch.group(1)?.replaceAll(',', '');
      return double.tryParse(clean ?? '');
    }

    final plainRegex = RegExp(r'\b([1-9]\d{2,}(?:\.\d{1,2})?)\b');
    final plainMatch = plainRegex.firstMatch(text.replaceAll(',', ''));
    if (plainMatch != null) {
      return double.tryParse(plainMatch.group(1) ?? '');
    }

    return null;
  }
}
