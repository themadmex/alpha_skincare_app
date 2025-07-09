// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/home/greeting_card.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/home/skin_progress_card.dart';
import '../../widgets/home/recent_scans.dart';
import '../../widgets/home/daily_tips.dart';
import '../../providers/auth_provider.dart';
import '../../providers/scan_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load recent scans
    Future.microtask(() => ref.read(scanControllerProvider.notifier).loadRecentScans());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SkinSense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(scanControllerProvider.notifier).loadRecentScans();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting card
              const GreetingCard(),
              const SizedBox(height: 16),

              // Quick actions
              const QuickActions(),
              const SizedBox(height: 16),

              // Skin progress card
              const SkinProgressCard(),
              const SizedBox(height: 16),

              // Recent scans
              const RecentScans(),
              const SizedBox(height: 16),

              // Daily tips
              const DailyTips(),
              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/scan'),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan Skin'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}


