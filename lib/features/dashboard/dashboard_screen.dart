import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../providers/providers.dart';
import '../../widgets/budget_ring.dart';
import '../cart/cart_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carts = ref.watch(cartsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DropSniper'),
        actions: [
          IconButton(
            onPressed: () => ref.read(cartsProvider.notifier).runPriceRefresh(),
            icon: const Icon(Icons.sync),
            tooltip: 'Run scan now',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateCartDialog(context, ref),
        label: const Text('New Project Cart'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(cartsProvider.notifier).runPriceRefresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Project Carts', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: carts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final cart = carts[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CartDetailScreen(cartId: cart.id)),
                    ),
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          BudgetRing(total: cart.totalCartPrice, budget: cart.budgetThreshold),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cart.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(
                                  '${cart.totalCartPrice.toStringAsFixed(2)} / ${cart.budgetThreshold.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: cart.isUnderBudget ? AppColors.neonGreen : AppColors.crimson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Tracked Items', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            GridView.builder(
              itemCount: carts.expand((e) => e.groups).length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (_, index) {
                final group = carts.expand((e) => e.groups).toList()[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(group.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Text('Best: ${group.cheapestPrice.toStringAsFixed(2)}'),
                      Text(
                        group.cheapestLink?.vendorName ?? 'No links yet',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateCartDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Project Cart'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Cart Name'),
            ),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(labelText: 'Budget'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(cartsProvider.notifier).createCart(
                    nameController.text.trim(),
                    double.tryParse(budgetController.text.trim()) ?? 0,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
