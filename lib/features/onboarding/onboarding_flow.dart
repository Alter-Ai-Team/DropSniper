import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../providers/providers.dart';
import '../../services/background_worker.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                children: const [
                  _OnboardPage(
                    title: '100% Local. Zero Cloud.',
                    body:
                        'DropSniper stores everything on your device using Hive. Your links and budgets stay private.',
                  ),
                  _OnboardPage(
                    title: 'Share Links Instantly',
                    body:
                        'Share a product URL from Amazon/Flipkart/browser and DropSniper will auto-import it.',
                  ),
                  _OnboardPage(
                    title: 'Enable Background Checks',
                    body:
                        'Allow periodic tasks so DropSniper can scan every 6 hours and alert you when budgets are hit.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () async {
                  if (_page < 2) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                    return;
                  }

                  await BackgroundWorker.initialize();
                  await ref.read(repositoryProvider).saveOnboardingSeen();

                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                },
                child: Text(_page < 2 ? 'Next' : 'Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
