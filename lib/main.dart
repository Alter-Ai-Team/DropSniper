import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'models/hive_adapters.dart';
import 'services/background_worker.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveBootstrap.initialize();
  await NotificationService.instance.initialize();

  if (Platform.isAndroid || Platform.isIOS) {
    await BackgroundWorker.initialize();
  }

  runApp(const ProviderScope(child: DropSniperApp()));
}
