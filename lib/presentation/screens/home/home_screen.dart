// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/scan_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanHistory = ref.watch(scanHistoryProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkinSense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authState.when(
                      data: (user) => Text(
                        'Welcome back, ${user?.displayName ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      loading: () => const Text('Loading...'),
                      error: (_, __) => const Text('Welcome!'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ready for your next skin analysis?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Start New Scan',
                      onPressed: () => context.go('/scan'),
                      icon: Icons.camera_alt,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Progress Chart
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            scanHistory.when(
              data: (scans) {
                if (scans.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No scans yet.\nTake your first scan to see progress!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: scans.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.overallScore.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Theme.of(context).primaryColor,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, __) => const Card(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text('Error loading progress')),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => context.go('/recommendations'),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.lightbulb, size: 32),
                            SizedBox(height: 8),
                            Text('Tips'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => context.go('/profile/history'),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.history, size: 32),
                            SizedBox(height: 8),
                            Text('History'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}