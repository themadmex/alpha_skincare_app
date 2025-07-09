// lib/presentation/widgets/scan/face_overlay.dart
import 'package:flutter/material.dart';

class FaceOverlay extends StatefulWidget {
  const FaceOverlay({super.key});

  @override
  State<FaceOverlay> createState() => _FaceOverlayState();
}

class _FaceOverlayState extends State<FaceOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: FaceOverlayPainter(
            scale: _scaleAnimation.value,
            color: Theme.of(context).primaryColor,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class FaceOverlayPainter extends CustomPainter {
  final double scale;
  final Color color;

  FaceOverlayPainter({required this.scale, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2.5);
    final radius = (size.width * 0.35) * scale;

    // Draw oval face guide
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2.4,
      ),
      paint,
    );

    // Draw corner guides
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 20.0;
    final corners = [
      // Top-left
      Offset(center.dx - radius * 0.8, center.dy - radius * 1.1),
      // Top-right
      Offset(center.dx + radius * 0.8, center.dy - radius * 1.1),
      // Bottom-left
      Offset(center.dx - radius * 0.8, center.dy + radius * 1.1),
      // Bottom-right
      Offset(center.dx + radius * 0.8, center.dy + radius * 1.1),
    ];

    for (final corner in corners) {
      // Draw corner brackets
      canvas.drawLine(
        corner,
        Offset(corner.dx + (corner.dx < center.dx ? cornerLength : -cornerLength), corner.dy),
        cornerPaint,
      );
      canvas.drawLine(
        corner,
        Offset(corner.dx, corner.dy + (corner.dy < center.dy ? cornerLength : -cornerLength)),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}