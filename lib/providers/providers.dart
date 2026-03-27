import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_group.dart';
import '../models/product_link.dart';
import '../models/project_cart.dart';
import '../repositories/drop_repository.dart';

final repositoryProvider = Provider<DropRepository>((ref) => DropRepository());

final onboardingSeenProvider = FutureProvider<bool>((ref) async {
  return ref.read(repositoryProvider).onboardingSeen;
});

class CartNotifier extends StateNotifier<List<ProjectCart>> {
  CartNotifier(this._repo) : super(_repo.loadCarts());

  final DropRepository _repo;

  Future<void> refresh() async {
    state = _repo.loadCarts();
  }

  Future<void> createCart(String name, double budget) async {
    final cart = ProjectCart(id: _repo.newId(), name: name, budgetThreshold: budget);
    await _repo.upsertCart(cart);
    await refresh();
  }

  Future<void> addGroup(String cartId, String title) async {
    final cart = state.firstWhere((c) => c.id == cartId);
    final group = ProductGroup(id: _repo.newId(), title: title);
    await _repo.upsertCart(cart.copyWith(groups: [...cart.groups, group]));
    await refresh();
  }

  Future<void> addLink({
    required String cartId,
    required String groupId,
    required String url,
    required String vendor,
  }) async {
    final cart = state.firstWhere((c) => c.id == cartId);
    final groups = cart.groups.map((group) {
      if (group.id != groupId) return group;
      final link = ProductLink(
        id: _repo.newId(),
        url: url,
        vendorName: vendor,
        currentPrice: 0,
        updatedAt: DateTime.now(),
      );
      return group.copyWith(links: [...group.links, link]);
    }).toList();

    await _repo.upsertCart(cart.copyWith(groups: groups));
    await refresh();
  }

  Future<void> ingestSharedUrl(String sharedUrl) async {
    ProjectCart cart;
    if (state.isEmpty) {
      cart = ProjectCart(id: _repo.newId(), name: 'Quick Snipes', budgetThreshold: 999999);
      await _repo.upsertCart(cart);
    } else {
      cart = state.first;
    }

    if (cart.groups.isEmpty) {
      final group = ProductGroup(id: _repo.newId(), title: 'Shared Item');
      cart = cart.copyWith(groups: [group]);
      await _repo.upsertCart(cart);
    }

    await addLink(
      cartId: cart.id,
      groupId: cart.groups.first.id,
      url: sharedUrl,
      vendor: _vendorFromUrl(sharedUrl),
    );
  }

  String _vendorFromUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri?.host.replaceAll('www.', '') ?? 'Unknown Vendor';
  }

  Future<void> runPriceRefresh() async {
    await _repo.refreshAllPrices();
    await refresh();
  }
}

final cartsProvider = StateNotifierProvider<CartNotifier, List<ProjectCart>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return CartNotifier(repo);
});
