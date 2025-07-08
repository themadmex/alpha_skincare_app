import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> pages = const [
    {
      'title': 'Welcome to AI Skincare',
      'subtitle': 'Analyze your skin with AI and get personalized routines.',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Track Your Progress',
      'subtitle': 'Monitor improvements over time and adjust routines.',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Stay Notified',
      'subtitle': 'Receive reminders to follow your skincare plan.',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(page['image']!, height: 300),
                const SizedBox(height: 32),
                Text(
                  page['title']!,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  page['subtitle']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

