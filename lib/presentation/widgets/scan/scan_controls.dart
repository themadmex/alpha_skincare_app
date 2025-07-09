// lib/presentation/widgets/scan/scan_controls.dart
import 'package:flutter/material.dart';

class ScanControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;
  final VoidCallback onShowInstructions;

  const ScanControls({
    super.key,
    required this.onCapture,
    required this.onSwitchCamera,
    required this.onShowInstructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Instructions button
            IconButton(
              onPressed: onShowInstructions,
              icon: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 32,
              ),
            ),

            // Capture button
            GestureDetector(
              onTap: onCapture,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
            ),

            // Switch camera button
            IconButton(
              onPressed: onSwitchCamera,
              icon: const Icon(
                Icons.flip_camera_android,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}