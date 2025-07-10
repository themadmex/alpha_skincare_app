// lib/presentation/widgets/scan/scan_instructions.dart
import 'package:flutter/material.dart';
import '../../widgets/common/custom_button.dart';

class ScanInstructions extends StatelessWidget {
  final VoidCallback onContinue;

  const ScanInstructions({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.face,
                size: 100,
                color: Colors.blue[700],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Get Your Skin Analysis',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            const Text(
              'Follow these steps for the best results:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Instructions list
            Expanded(
              child: ListView(
                children: [
                  _buildInstructionItem(
                    Icons.face,
                    'Clean Face',
                    'Wash your face and remove makeup for accurate analysis',
                  ),
                  _buildInstructionItem(
                    Icons.wb_sunny,
                    'Good Lighting',
                    'Use natural light or bright indoor lighting',
                  ),
                  _buildInstructionItem(
                    Icons.camera_alt,
                    'Position Face',
                    'Center your face in the circle and hold steady',
                  ),
                  _buildInstructionItem(
                    Icons.visibility,
                    'Look Forward',
                    'Look directly at the camera with a neutral expression',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: 'Start Scan',
              onPressed: onContinue,
            ),

            const SizedBox(height: 16),

            const Text(
              'Your photo is processed locally and never stored',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}