import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';

/// Main navigation shell with bottom navigation bar
/// Provides consistent navigation experience across the app
class MainNavigationShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainNavigationShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  int _currentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(AppRoutes.home)) return AppRoutes.homeTabIndex;
    if (location.startsWith(AppRoutes.scan)) return AppRoutes.scanTabIndex;
    if (location.startsWith(AppRoutes.history)) return AppRoutes.historyTabIndex;
    if (location.startsWith(AppRoutes.products)) return AppRoutes.productsTabIndex;
    if (location.startsWith(AppRoutes.profile)) return AppRoutes.profileTabIndex;

    return AppRoutes.homeTabIndex;
  }

  void _onItemTapped(BuildContext context, int index) {
    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();

    // Animate FAB when switching to scan tab
    if (index == AppRoutes.scanTabIndex) {
      _fabAnimationController.forward();
    }

    context.goToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 65,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => _onItemTapped(context, index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppTheme.primaryPurple,
              unselectedItemColor: AppTheme.lightGray,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 24,
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.home_outlined, currentIndex == 0),
                  activeIcon: _buildNavIcon(Icons.home_rounded, true),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildScanButton(currentIndex == 1),
                  label: 'Scan',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.history_outlined, currentIndex == 2),
                  activeIcon: _buildNavIcon(Icons.history_rounded, true),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.shopping_bag_outlined, currentIndex == 3),
                  activeIcon: _buildNavIcon(Icons.shopping_bag_rounded, true),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.person_outline_rounded, currentIndex == 4),
                  activeIcon: _buildNavIcon(Icons.person_rounded, true),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      // Floating scan button (alternative design)
      // Uncomment if you prefer a floating action button for scanning
      /*
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go(AppRoutes.scan);
          },
          backgroundColor: AppTheme.primaryPurple,
          elevation: 8,
          child: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      */
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isActive
          ? BoxDecoration(
        color: AppTheme.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      )
          : null,
      child: Icon(
        icon,
        size: 24,
        color: isActive ? AppTheme.primaryPurple : AppTheme.lightGray,
      ),
    );
  }

  Widget _buildScanButton(bool isActive) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple,
            Color(0xFF8B7FE8),
          ],
        )
            : null,
        color: isActive ? null : AppTheme.lightBeige,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Icon(
        Icons.camera_alt_rounded,
        size: 24,
        color: isActive ? Colors.white : AppTheme.mediumGray,
      ),
    );
  }
}

/// Navigation extension for easy tab switching
extension NavigationExtension on BuildContext {
  void goToTab(int index) {
    switch (index) {
      case AppRoutes.homeTabIndex:
        go(AppRoutes.home);
        break;
      case AppRoutes.scanTabIndex:
        go(AppRoutes.scan);
        break;
      case AppRoutes.historyTabIndex:
        go(AppRoutes.history);
        break;
      case AppRoutes.productsTabIndex:
        go(AppRoutes.products);
        break;
      case AppRoutes.profileTabIndex:
        go(AppRoutes.profile);
        break;
    }
  }
}

// Temporary AppTheme references until we move theme to separate file
class AppTheme {
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color secondaryGreen = Color(0xFF00B894);
  static const Color warmWhite = Color(0xFFF8F5F2);
  static const Color lightBeige = Color(0xFFE8E2DC);
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFF999999);
}