class PricePoint {
  PricePoint({required this.timestamp, required this.price});

  final DateTime timestamp;
  final double price;
}

class ProductLink {
  ProductLink({
    required this.id,
    required this.url,
    required this.vendorName,
    required this.currentPrice,
    required this.updatedAt,
    List<PricePoint>? priceHistory,
  }) : priceHistory = priceHistory ?? <PricePoint>[];

  final String id;
  final String url;
  final String vendorName;
  final double currentPrice;
  final DateTime updatedAt;
  final List<PricePoint> priceHistory;

  ProductLink copyWith({
    String? id,
    String? url,
    String? vendorName,
    double? currentPrice,
    DateTime? updatedAt,
    List<PricePoint>? priceHistory,
  }) {
    return ProductLink(
      id: id ?? this.id,
      url: url ?? this.url,
      vendorName: vendorName ?? this.vendorName,
      currentPrice: currentPrice ?? this.currentPrice,
      updatedAt: updatedAt ?? this.updatedAt,
      priceHistory: priceHistory ?? this.priceHistory,
    );
  }
}
