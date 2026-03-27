import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/project_cart.dart';
import '../../providers/providers.dart';
import '../../widgets/sparkline_painter.dart';

class CartDetailScreen extends ConsumerWidget {
  const CartDetailScreen({super.key, required this.cartId});

  final String cartId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartsProvider).firstWhere((c) => c.id == cartId);

    return Scaffold(
      appBar: AppBar(title: Text(cart.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGroupDialog(context, ref, cart),
        label: const Text('Add Item Slot'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Aggregate Total'),
              subtitle: Text('Budget: ${cart.budgetThreshold.toStringAsFixed(2)}'),
              trailing: Text(
                cart.totalCartPrice.toStringAsFixed(2),
                style: TextStyle(
                  color: cart.isUnderBudget ? AppColors.neonGreen : AppColors.crimson,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...cart.groups.map((group) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Cheapest: ${group.cheapestPrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    SizedBox(height: 40, child: PriceSparkline(points: group.mergedHistory)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: group.links
                          .map(
                            (link) => Chip(
                              label: Text('${link.vendorName}: ${link.currentPrice.toStringAsFixed(2)}'),
                              backgroundColor: group.cheapestLink?.id == link.id
                                  ? AppColors.neonGreen.withOpacity(.25)
                                  : null,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _showAddLinkDialog(context, ref, cart.id, group.id),
                      child: const Text('Add alternative URL (OR)'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _showAddGroupDialog(
    BuildContext context,
    WidgetRef ref,
    ProjectCart cart,
  ) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Product Group'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(cartsProvider.notifier).addGroup(cart.id, controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddLinkDialog(BuildContext context, WidgetRef ref, String cartId, String groupId) async {
    final urlController = TextEditingController();
    final vendorController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Alternative Store Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: urlController, decoration: const InputDecoration(labelText: 'Product URL')),
            TextField(controller: vendorController, decoration: const InputDecoration(labelText: 'Vendor Name')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(cartsProvider.notifier).addLink(
                    cartId: cartId,
                    groupId: groupId,
                    url: urlController.text.trim(),
                    vendor: vendorController.text.trim(),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
