import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'providers/providers.dart';
import 'services/share_intake_service.dart';

class DropSniperApp extends ConsumerStatefulWidget {
  const DropSniperApp({super.key});

  @override
  ConsumerState<DropSniperApp> createState() => _DropSniperAppState();
}

class _DropSniperAppState extends ConsumerState<DropSniperApp> {
  @override
  void initState() {
    super.initState();
    ShareIntakeService.instance.listen((url) {
      ref.read(cartsProvider.notifier).ingestSharedUrl(url);
    });
  }

  @override
  void dispose() {
    ShareIntakeService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingSeen = ref.watch(onboardingSeenProvider);

    return MaterialApp(
      title: 'DropSniper',
      theme: buildTheme(),
      home: onboardingSeen.when(
        data: (seen) => seen ? const DashboardScreen() : const OnboardingFlow(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const DashboardScreen(),
      ),
    );
  }
}
