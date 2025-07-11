// lib/core/theme/dimensions.dart
class AppDimensions {
  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;
  static const double spacing80 = 80.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Margins
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusXXLarge = 20.0;
  static const double radiusCircular = 100.0;

  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonMinWidth = 88.0;

  // Icon Sizes
  static const double iconXSmall = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 64.0;

  // AppBar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardRadius = 12.0;
  static const double cardPadding = 16.0;

  // Input Field Dimensions
  static const double inputHeight = 48.0;
  static const double inputRadius = 12.0;
  static const double inputPadding = 16.0;

  // Bottom Navigation
  static const double bottomNavHeight = 60.0;
  static const double bottomNavElevation = 8.0;

  // Floating Action Button
  static const double fabSize = 56.0;
  static const double fabElevation = 4.0;

  // Camera Overlay
  static const double cameraOverlaySize = 250.0;
  static const double cameraOverlayHeight = 300.0;

  // Product Card
  static const double productCardWidth = 160.0;
  static const double productCardHeight = 220.0;
  static const double productCardRadius = 12.0;

  // Progress Indicators
  static const double progressBarHeight = 4.0;
  static const double progressBarRadius = 2.0;
  static const double circularProgressSize = 24.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Snackbar
  static const double snackbarElevation = 4.0;
  static const double snackbarRadius = 8.0;

  // Dialog
  static const double dialogRadius = 16.0;
  static const double dialogElevation = 8.0;
  static const double dialogPadding = 24.0;

  // Tab Bar
  static const double tabBarHeight = 48.0;
  static const double tabBarIndicatorHeight = 3.0;

  // List Tile
  static const double listTileHeight = 56.0;
  static const double listTileMinVerticalPadding = 4.0;

  // Chip
  static const double chipHeight = 32.0;
  static const double chipRadius = 16.0;

  // Avatar
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 48.0;
  static const double avatarLarge = 64.0;

  // Skeleton Loading
  static const double skeletonRadius = 4.0;
  static const double skeletonHeight = 16.0;

  // Grid
  static const double gridSpacing = 16.0;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridMainAxisSpacing = 16.0;
  static const double gridChildAspectRatio = 0.7;

  // Timeline
  static const double timelineIndicatorSize = 12.0;
  static const double timelineLineWidth = 2.0;

  // Analysis Chart
  static const double chartHeight = 250.0;
  static const double chartPadding = 16.0;

  // Scan Result Card
  static const double scanResultCardHeight = 120.0;
  static const double scanResultCardRadius = 12.0;

  // Recommendation Card
  static const double recommendationCardHeight = 180.0;
  static const double recommendationCardRadius = 12.0;

  // Quick Action Card
  static const double quickActionCardSize = 80.0;
  static const double quickActionCardRadius = 12.0;

  // Helper Methods
  static double responsiveWidth(double width, double screenWidth) {
    return (width / 375.0) * screenWidth; // 375 is iPhone X width
  }

  static double responsiveHeight(double height, double screenHeight) {
    return (height / 812.0) * screenHeight; // 812 is iPhone X height
  }
}