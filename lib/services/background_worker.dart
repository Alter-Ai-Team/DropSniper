import 'package:hive/hive.dart';
import 'package:workmanager/workmanager.dart';

import '../models/hive_adapters.dart';
import '../repositories/drop_repository.dart';
import 'notification_service.dart';

class BackgroundWorker {
  static const taskName = 'dropsniper.price.scan';

  static Future<void> initialize() async {
    final settings = Hive.box(HiveBoxes.settings);
    final alreadyRegistered = settings.get('workmanager_registered', defaultValue: false) as bool;

    if (!alreadyRegistered) {
      await Workmanager().initialize(_callbackDispatcher, isInDebugMode: false);
      await Workmanager().registerPeriodicTask(
        'dropsniper_periodic_scan',
        taskName,
        frequency: const Duration(hours: 6),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        constraints: Constraints(networkType: NetworkType.connected),
      );
      await settings.put('workmanager_registered', true);
    }
  }
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await HiveBootstrap.initialize();
    final repo = DropRepository();
    final notificationService = NotificationService.instance;
    await notificationService.initialize();

    final updatedCarts = await repo.refreshAllPrices();
    for (final cart in updatedCarts) {
      if (cart.totalCartPrice <= cart.budgetThreshold) {
        await notificationService.showDealAlert(
          cartName: cart.name,
          price: cart.totalCartPrice,
        );
      }
    }

    return true;
  });
}
