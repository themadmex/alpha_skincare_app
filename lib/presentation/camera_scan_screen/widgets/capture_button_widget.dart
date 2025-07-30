import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CaptureButtonWidget extends StatefulWidget {
  final bool isOptimalPosition;
  final bool isCountingDown;
  final int countdownValue;
  final VoidCallback onCapture;

  const CaptureButtonWidget({
    super.key,
    required this.isOptimalPosition,
    required this.isCountingDown,
    required this.countdownValue,
    required this.onCapture,
  });

  @override
  State<CaptureButtonWidget> createState() => _CaptureButtonWidgetState();
}

class _CaptureButtonWidgetState extends State<CaptureButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isOptimalPosition) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CaptureButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOptimalPosition && !oldWidget.isOptimalPosition) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isOptimalPosition && oldWidget.isOptimalPosition) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Countdown display
          if (widget.isCountingDown) ...[
            Container(
              width: 20.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${widget.countdownValue}',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Capture button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isOptimalPosition ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: widget.onCapture,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isOptimalPosition
                          ? AppTheme.successColor
                          : Colors.white,
                      border: Border.all(
                        color: widget.isOptimalPosition
                            ? AppTheme.successColor
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isOptimalPosition
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Instruction text
          Text(
            widget.isCountingDown
                ? 'Auto-capturing...'
                : widget.isOptimalPosition
                    ? 'Tap to capture or wait for auto-capture'
                    : 'Position your face in the oval',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
