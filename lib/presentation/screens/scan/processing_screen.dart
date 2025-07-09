// lib/presentation/screens/scan/processing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import '../../providers/scan_provider.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  final String? imagePath;

  const ProcessingScreen({super.key, this.imagePath});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    if (widget.imagePath != null) {
      final imageFile = File(widget.imagePath!);
      await ref.read(scanControllerProvider.notifier).analyzeSkin(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: scanState.when(
        loading: () => const ProcessingView(),
        data: (result) {
          if (result != null) {
            // Navigate to results after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.go('/results/${result.id}');
              }
            });
          }
          return const ProcessingView();
        },
        error: (error, stackTrace) => ProcessingErrorView(
          error: error.toString(),
          onRetry: () => _startProcessing(),
          onCancel: () => context.go('/scan'),
        ),
      ),
    );
  }
}

class ProcessingView extends StatelessWidget {
  const ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/ai_processing.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 32),
          const Text(
            'Analyzing your skin...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our AI is examining your skin for\nhydration, blemishes, and more',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 32),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessingErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  const ProcessingErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Analysis Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}