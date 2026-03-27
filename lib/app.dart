import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'providers/providers.dart';
import 'services/share_intake_service.dart';
import 'widgets/app_logo.dart';

class DropSniperApp extends ConsumerStatefulWidget {
  const DropSniperApp({super.key});

  @override
  ConsumerState<DropSniperApp> createState() => _DropSniperAppState();
}

class _DropSniperAppState extends ConsumerState<DropSniperApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _showSplash = false);
      }),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ShareIntakeService.instance.listen((url) {
          ref.read(cartsProvider.notifier).ingestSharedUrl(url);
        });
      } catch (_) {
        // Safe no-op for unsupported desktop environments.
      }
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
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _showSplash
            ? const _SplashView()
            : onboardingSeen.when(
                data: (seen) => seen ? const DashboardScreen() : const OnboardingFlow(),
                loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
                error: (_, __) => const DashboardScreen(),
              ),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (_, value, child) => Transform.scale(scale: value, child: child),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropSniperLogo(size: 92),
              SizedBox(height: 16),
              Text('DropSniper', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Local. Private. Instant.', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
