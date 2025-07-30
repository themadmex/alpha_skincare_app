import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/skin_analysis.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/skin_analysis_service.dart';
import './widgets/daily_tip_card.dart';
import './widgets/metrics_carousel.dart';
import './widgets/quick_actions_grid.dart';
import './widgets/recent_scans_section.dart';
import './widgets/skin_score_card.dart';
import './widgets/subscription_status_card.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isRefreshing = false;
  bool _isLoading = true;

  // Services
  final AuthService _authService = AuthService();
  final SkinAnalysisService _analysisService = SkinAnalysisService();

  // Data
  UserProfile? _userProfile;
  List<SkinAnalysis> _recentAnalyses = [];
  Map<String, dynamic> _progressData = {};

  // Mock daily tip data (this would come from educational content service)
  final Map<String, dynamic> _dailyTipData = {
    "category": "Hydration",
    "title": "The Power of Hyaluronic Acid",
    "preview":
        "Hyaluronic acid can hold up to 1000 times its weight in water, making it a powerful hydrating ingredient for all skin types...",
    "fullContent":
        """Hyaluronic acid can hold up to 1000 times its weight in water, making it a powerful hydrating ingredient for all skin types. This naturally occurring substance in our skin helps maintain moisture levels and plumpness.

As we age, our natural hyaluronic acid production decreases, leading to drier, less elastic skin. Incorporating products with hyaluronic acid into your routine can help restore moisture and improve skin texture.

Look for serums or moisturizers containing different molecular weights of hyaluronic acid for maximum penetration and hydration benefits.""",
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() => _isLoading = true);

      // Load user profile
      _userProfile = await _authService.getCurrentUserProfile();

      if (_userProfile != null) {
        // Load recent analyses
        _recentAnalyses = await _analysisService.getUserAnalyses(limit: 5);

        // Load progress data
        _progressData =
            await _analysisService.getProgressData(_userProfile!.id);
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final userName = _userProfile?.fullName.split(' ').first ?? 'User';

    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, $userName!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Alpha Skincare',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to notifications
          },
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Navigate to settings
          },
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Status Card
            if (_userProfile != null)
              SubscriptionStatusCard(
                isPremium: _userProfile!.isPremium,
                scansRemaining: _userProfile!.scansRemaining,
                totalScans: _userProfile!.isPremium ? 999 : 5,
              ),

            // Skin Score Hero Section
            if (_recentAnalyses.isNotEmpty && _recentAnalyses.first.isCompleted)
              SkinScoreCard(
                skinScore: _recentAnalyses.first.overallScore ?? 0,
                trend: _getTrendText(),
                isImproving: _isScoreImproving(),
              )
            else
              _buildNoAnalysisCard(),

            // Metrics Carousel
            if (_recentAnalyses.isNotEmpty &&
                _recentAnalyses.first.isCompleted) ...[
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Recent Analysis',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              MetricsCarousel(metrics: _getMetricsData()),
            ],

            // Daily Tip Card
            SizedBox(height: 2.h),
            DailyTipCard(tipData: _dailyTipData),

            // Recent Scans Section
            if (_recentAnalyses.isNotEmpty) ...[
              SizedBox(height: 2.h),
              RecentScansSection(recentScans: _getRecentScansData()),
            ],

            // Quick Actions Grid
            SizedBox(height: 2.h),
            const QuickActionsGrid(),

            // Bottom padding for floating action button
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAnalysisCard() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.primaryColor,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Start Your Skin Journey',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Take your first skin analysis to get personalized insights and recommendations.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getTrendText() {
    if (_progressData.isEmpty || _progressData['previous_score'] == null) {
      return 'First analysis completed';
    }

    final current = _progressData['current_score'] ?? 0;
    final previous = _progressData['previous_score'] ?? 0;
    final diff = current - previous;

    if (diff > 0) {
      return '+$diff points from last scan';
    } else if (diff < 0) {
      return '$diff points from last scan';
    } else {
      return 'No change from last scan';
    }
  }

  bool _isScoreImproving() {
    if (_progressData.isEmpty || _progressData['previous_score'] == null) {
      return true; // Default to positive for first analysis
    }

    final current = _progressData['current_score'] ?? 0;
    final previous = _progressData['previous_score'] ?? 0;
    return current >= previous;
  }

  List<Map<String, dynamic>> _getMetricsData() {
    if (_recentAnalyses.isEmpty || !_recentAnalyses.first.isCompleted) {
      return [];
    }

    final metrics = _recentAnalyses.first.metrics;
    return [
      {
        "name": "Wrinkles",
        "score": metrics['wrinkles'] ?? 0,
        "improvement": "Improved",
        "icon": "face_retouching",
      },
      {
        "name": "Dark Spots",
        "score": metrics['dark_spots'] ?? 0,
        "improvement": "Stable",
        "icon": "brightness_6",
      },
      {
        "name": "Hydration",
        "score": metrics['hydration'] ?? 0,
        "improvement": "Declined",
        "icon": "water_drop",
      },
      {
        "name": "Texture",
        "score": metrics['texture'] ?? 0,
        "improvement": "Improved",
        "icon": "texture",
      },
    ];
  }

  List<Map<String, dynamic>> _getRecentScansData() {
    return _recentAnalyses.take(3).map((analysis) {
      return {
        "date":
            "${analysis.analysisDate.day}/${analysis.analysisDate.month}/${analysis.analysisDate.year}",
        "score": analysis.overallScore ?? 0,
        "thumbnail": analysis.thumbnailUrl ?? analysis.imageUrl,
      };
    }).toList();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.cardColor,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentTabIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'camera_alt',
            color: _currentTabIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'trending_up',
            color: _currentTabIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentTabIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    final canScan = _userProfile?.canScan ?? false;

    return FloatingActionButton.extended(
      onPressed: canScan ? _startNewScan : _showUpgradeDialog,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: CustomIconWidget(
        iconName: 'camera_alt',
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        canScan ? 'Start Scan' : 'Upgrade',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await _loadDashboardData();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    // Navigate to different screens based on tab
    switch (index) {
      case 0:
        // Already on home, do nothing
        break;
      case 1:
        Navigator.pushNamed(context, '/camera-scan-screen');
        break;
      case 2:
        // Navigate to progress screen
        break;
      case 3:
        // Navigate to profile screen
        break;
    }
  }

  void _startNewScan() {
    Navigator.pushNamed(context, '/camera-scan-screen');
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Upgrade to Premium',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You\'ve used all your free scans this month. Upgrade to Premium for unlimited scans and advanced analytics.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Maybe Later',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to subscription screen
              },
              child: Text(
                'Upgrade Now',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
