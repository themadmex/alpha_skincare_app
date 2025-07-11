// lib/core/theme/animations.dart
import 'package:flutter/material.dart';

class AppAnimations {
  // Duration Constants
  static const Duration ultraFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration ultraSlow = Duration(milliseconds: 800);

  // Curve Constants
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeInOut;
  static const Curve bouncyCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;

  // Fade Animations
  static Widget fadeIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget fadeOut({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale Animations
  static Widget scaleIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = bouncyCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget scaleOut({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide Animations
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, 1), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromTop({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, -1), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromLeft({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(-1, 0), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value.dx * 100, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromRight({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(1, 0), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value.dx * 100, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  // Rotation Animations
  static Widget rotateIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: child,
        );
      },
      child: child,
    );
  }

  // Stagger Animations
  static Widget staggeredList({
    required List<Widget> children,
    Duration duration = medium,
    Duration delay = const Duration(milliseconds: 100),
    Curve curve = defaultCurve,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: duration,
          curve: curve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 50),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Shimmer Animation
  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: duration,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.transparent,
                Colors.white24,
                Colors.transparent,
              ],
              stops: [
                value - 0.3,
                value,
                value + 0.3,
              ],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // Pulse Animation
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: duration,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Loading Animation
  static Widget loading({
    Color color = Colors.blue,
    double size = 24.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 2.0,
      ),
    );
  }

  // Page Transitions
  static Route<T> fadeRoute<T>({
    required Widget page,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Route<T> slideRoute<T>({
    required Widget page,
    Duration duration = medium,
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: defaultCurve,
          )),
          child: child,
        );
      },
    );
  }

  static Route<T> scaleRoute<T>({
    required Widget page,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: bouncyCurve,
          )),
          child: child,
        );
      },
    );
  }
}