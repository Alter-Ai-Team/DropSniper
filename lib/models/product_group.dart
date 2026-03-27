import 'product_link.dart';

class ProductGroup {
  ProductGroup({
    required this.id,
    required this.title,
    List<ProductLink>? links,
  }) : links = links ?? <ProductLink>[];

  final String id;
  final String title;
  final List<ProductLink> links;

  double get cheapestPrice {
    if (links.isEmpty) return 0;
    return links
        .map((link) => link.currentPrice)
        .reduce((value, element) => value < element ? value : element);
  }

  ProductLink? get cheapestLink {
    if (links.isEmpty) return null;
    return links.reduce(
      (value, element) =>
          value.currentPrice <= element.currentPrice ? value : element,
    );
  }

  List<PricePoint> get mergedHistory {
    final points = links.expand((e) => e.priceHistory).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return points;
  }

  ProductGroup copyWith({String? id, String? title, List<ProductLink>? links}) {
    return ProductGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      links: links ?? this.links,
    );
  }
}
