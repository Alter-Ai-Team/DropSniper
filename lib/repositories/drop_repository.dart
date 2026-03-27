import 'dart:math';

import 'package:hive/hive.dart';

import '../models/hive_adapters.dart';
import '../models/product_group.dart';
import '../models/product_link.dart';
import '../models/project_cart.dart';
import '../services/price_scraper_service.dart';

class DropRepository {
  DropRepository({PriceScraperService? scraper})
      : _scraper = scraper ?? const PriceScraperService();

  final PriceScraperService _scraper;

  Box<ProjectCart> get _cartBox => Hive.box<ProjectCart>(HiveBoxes.carts);
  Box get _settings => Hive.box(HiveBoxes.settings);

  List<ProjectCart> loadCarts() => _cartBox.values.toList(growable: false);

  Future<void> upsertCart(ProjectCart cart) async {
    await _cartBox.put(cart.id, cart);
  }

  Future<void> deleteCart(String id) async {
    await _cartBox.delete(id);
  }

  Future<void> saveOnboardingSeen() => _settings.put('onboarding_seen', true);
  bool get onboardingSeen => _settings.get('onboarding_seen', defaultValue: false) as bool;

  String newId() => '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}';

  Future<List<ProjectCart>> refreshAllPrices() async {
    final carts = loadCarts();
    final updated = <ProjectCart>[];

    for (final cart in carts) {
      final newGroups = <ProductGroup>[];
      for (final group in cart.groups) {
        final newLinks = <ProductLink>[];
        for (final link in group.links) {
          final price = await _scraper.scrapePrice(link.url);
          if (price == null) {
            newLinks.add(link);
            continue;
          }
          final now = DateTime.now();
          final history = [...link.priceHistory, PricePoint(timestamp: now, price: price)];
          final last30Days = history
              .where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 30))))
              .toList();

          newLinks.add(
            link.copyWith(currentPrice: price, updatedAt: now, priceHistory: last30Days),
          );
        }
        newGroups.add(group.copyWith(links: newLinks));
      }
      final newCart = cart.copyWith(groups: newGroups);
      await upsertCart(newCart);
      updated.add(newCart);
    }

    return updated;
  }
}
