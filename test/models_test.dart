import 'package:flutter_test/flutter_test.dart';

import 'package:dropsniper/models/product_group.dart';
import 'package:dropsniper/models/product_link.dart';
import 'package:dropsniper/models/project_cart.dart';

void main() {
  test('ProductGroup.cheapestPrice returns lowest link price', () {
    final group = ProductGroup(
      id: 'g1',
      title: 'RTX 4090',
      links: [
        ProductLink(
          id: 'l1',
          url: 'https://example.com/a',
          vendorName: 'Vendor A',
          currentPrice: 2200,
          updatedAt: DateTime.now(),
        ),
        ProductLink(
          id: 'l2',
          url: 'https://example.com/b',
          vendorName: 'Vendor B',
          currentPrice: 1999,
          updatedAt: DateTime.now(),
        ),
      ],
    );

    expect(group.cheapestPrice, 1999);
    expect(group.cheapestLink?.vendorName, 'Vendor B');
  });

  test('ProjectCart.totalCartPrice sums cheapest group prices', () {
    final cpu = ProductGroup(
      id: 'cpu',
      title: 'CPU',
      links: [
        ProductLink(
          id: 'c1',
          url: 'https://example.com/cpu1',
          vendorName: 'A',
          currentPrice: 320,
          updatedAt: DateTime.now(),
        ),
      ],
    );

    final gpu = ProductGroup(
      id: 'gpu',
      title: 'GPU',
      links: [
        ProductLink(
          id: 'g1',
          url: 'https://example.com/gpu1',
          vendorName: 'A',
          currentPrice: 1500,
          updatedAt: DateTime.now(),
        ),
        ProductLink(
          id: 'g2',
          url: 'https://example.com/gpu2',
          vendorName: 'B',
          currentPrice: 1450,
          updatedAt: DateTime.now(),
        ),
      ],
    );

    final cart = ProjectCart(
      id: 'cart1',
      name: 'Beast PC Build',
      budgetThreshold: 2000,
      groups: [cpu, gpu],
    );

    expect(cart.totalCartPrice, 1770);
    expect(cart.isUnderBudget, true);
  });
}
