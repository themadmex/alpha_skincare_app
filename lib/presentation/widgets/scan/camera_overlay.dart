// lib/presentation/widgets/scan/camera_overlay.dart
import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay with hole
        Container(
          color: Colors.black.withOpacity(0.5),
          child: CustomPaint(
            painter: _CameraOverlayPainter(),
            child: Container(),
          ),
        ),

        // Face outline
        Center(
          child: Container(
            width: 250,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(150),
            ),
            child: Stack(
              children: [
                // Corner indicators
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final holePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    // Draw the overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Create hole for face
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 250, height: 300),
      holePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}