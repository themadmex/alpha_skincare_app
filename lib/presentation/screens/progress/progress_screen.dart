// lib/presentation/screens/progress/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/scan_provider.dart';
import '../../widgets/progress/progress_overview.dart';
import '../../widgets/progress/timeline_view.dart';
import '../../widgets/progress/metrics_comparison.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(scanControllerProvider.notifier).loadAllScans());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Timeline'),
            Tab(text: 'Metrics'),
          ],
        ),
      ),
      body: scanState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading progress: $error'),
            ],
          ),
        ),
        data: (scanResults) {
          if (scanResults.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No progress data yet'),
                  SizedBox(height: 8),
                  Text(
                    'Take your first skin scan to start tracking progress',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              ProgressOverview(scanResults: scanResults),
              TimelineView(scanResults: scanResults),
              MetricsComparison(scanResults: scanResults),
            ],
          );
        },
      ),
    );
  }
}