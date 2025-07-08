import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/screens/login_screen.dart';
import '../../scan/screens/scan_screen.dart';
import '../../results/screens/results_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('Please log in'));

    final lastScanStream = FirebaseFirestore.instance
        .collection('scans')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${ref.read(authServiceProvider).currentUser?.displayName ?? 'User'}!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/scan'),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start a New Scan'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Last Scan Overview', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // Listen to the latest scan document
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: lastScanStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No scans yet');
              }
              final data = snapshot.data!.docs.first.data();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _MetricCard(label: 'Score', value: '${data['results']['overallScore']}'),
                    _MetricCard(label: 'Hydration', value: '${data['results']['hydration']}'),
                    _MetricCard(label: 'Acne', value: '${data['results']['acne']}'),
                    _MetricCard(label: 'Redness', value: '${data['results']['redness']}'),
                    TextButton(
                      onPressed: () => context.go('/results'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Daily Tip: Apply a hydrating serum before your moisturizer!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = const [
    HomeTab(),
    ScanScreen(),
    ResultsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(_currentIndex),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Results'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return 'Skin Scan';
      case 2:
        return 'Results';
      case 3:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, User!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Quick Scan CTA
          ElevatedButton.icon(
            onPressed: () => context.go('/scan'),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start a New Scan'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Last Scan Metrics
          Text(
            'Last Scan Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _MetricCard(label: 'Score', value: '78'),
                _MetricCard(label: 'Hydration', value: '65'),
                _MetricCard(label: 'Acne', value: '12'),
                _MetricCard(label: 'Redness', value: '8'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Daily Tip Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Daily Tip: Apply a hydrating serum before your moisturizer!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}