import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'text_styles.dart';

// Theme configuration
class ThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color errorColor;
  final Color successColor;
  final Color warningColor;
  final Color infoColor;
  final Brightness brightness;
  final String fontFamily;
  final double borderRadius;
  final double buttonHeight;
  final double inputHeight;
  final double cardElevation;
  final double appBarElevation;

  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.errorColor,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.brightness,
    this.fontFamily = 'System',
    this.borderRadius = AppSizes.radiusLarge,
    this.buttonHeight = AppSizes.buttonHeight,
    this.inputHeight = AppSizes.inputHeight,
    this.cardElevation = AppSizes.cardElevation,
    this.appBarElevation = AppSizes.appBarElevation,
  });

  // Predefined light theme config
  static const ThemeConfig light = ThemeConfig(
    primaryColor: AppColors.primary,
    secondaryColor: AppColors.secondary,
    accentColor: AppColors.accent,
    backgroundColor: AppColors.background,
    surfaceColor: AppColors.surface,
    errorColor: AppColors.error,
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    infoColor: AppColors.info,
    brightness: Brightness.light,
  );

  // Predefined dark theme config
  static const ThemeConfig dark = ThemeConfig(
    primaryColor: AppColors.primary,
    secondaryColor: AppColors.secondary,
    accentColor: AppColors.accent,
    backgroundColor: AppColors.backgroundDark,
    surfaceColor: AppColors.surfaceDark,
    errorColor: AppColors.error,
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    infoColor: AppColors.info,
    brightness: Brightness.dark,
  );

  // Create a copy with modified values
  ThemeConfig copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? errorColor,
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
    Brightness? brightness,
    String? fontFamily,
    double? borderRadius,
    double? buttonHeight,
    double? inputHeight,
    double? cardElevation,
    double? appBarElevation,
  }) {
    return ThemeConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      brightness: brightness ?? this.brightness,
      fontFamily: fontFamily ?? this.fontFamily,
      borderRadius: borderRadius ?? this.borderRadius,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      inputHeight: inputHeight ?? this.inputHeight,
      cardElevation: cardElevation ?? this.cardElevation,
      appBarElevation: appBarElevation ?? this.appBarElevation,
    );
  }

  // Get text color based on brightness
  Color get textColor => brightness == Brightness.light ? AppColors.textPrimary : Colors.white;
  Color get textSecondaryColor => brightness == Brightness.light ? AppColors.textSecondary : Colors.white70;
  Color get textLightColor => brightness == Brightness.light ? AppColors.textLight : Colors.white54;
  Color get borderColor => brightness == Brightness.light ? AppColors.border : AppColors.borderDark;
}

// Theme builder class
class AppThemeBuilder {
  final ThemeConfig _config;
  final Map<String, dynamic> _customizations = {};

  AppThemeBuilder(this._config);

  // Factory constructors
  factory AppThemeBuilder.light() => AppThemeBuilder(ThemeConfig.light);
  factory AppThemeBuilder.dark() => AppThemeBuilder(ThemeConfig.dark);
  factory AppThemeBuilder.custom(ThemeConfig config) => AppThemeBuilder(config);

  // Customization methods
  AppThemeBuilder withPrimaryColor(Color color) {
    _customizations['primaryColor'] = color;
    return this;
  }

  AppThemeBuilder withSecondaryColor(Color color) {
    _customizations['secondaryColor'] = color;
    return this;
  }

  AppThemeBuilder withAccentColor(Color color) {
    _customizations['accentColor'] = color;
    return this;
  }

  AppThemeBuilder withBackgroundColor(Color color) {
    _customizations['backgroundColor'] = color;
    return this;
  }

  AppThemeBuilder withSurfaceColor(Color color) {
    _customizations['surfaceColor'] = color;
    return this;
  }

  AppThemeBuilder withFontFamily(String fontFamily) {
    _customizations['fontFamily'] = fontFamily;
    return this;
  }

  AppThemeBuilder withBorderRadius(double radius) {
    _customizations['borderRadius'] = radius;
    return this;
  }

  AppThemeBuilder withButtonHeight(double height) {
    _customizations['buttonHeight'] = height;
    return this;
  }

  AppThemeBuilder withCardElevation(double elevation) {
    _customizations['cardElevation'] = elevation;
    return this;
  }

  AppThemeBuilder withAppBarElevation(double elevation) {
    _customizations['appBarElevation'] = elevation;
    return this;
  }

  // Get effective config with customizations
  ThemeConfig get _effectiveConfig {
    return _config.copyWith(
      primaryColor: _customizations['primaryColor'],
      secondaryColor: _customizations['secondaryColor'],
      accentColor: _customizations['accentColor'],
      backgroundColor: _customizations['backgroundColor'],
      surfaceColor: _customizations['surfaceColor'],
      fontFamily: _customizations['fontFamily'],
      borderRadius: _customizations['borderRadius'],
      buttonHeight: _customizations['buttonHeight'],
      cardElevation: _customizations['cardElevation'],
      appBarElevation: _customizations['appBarElevation'],
    );
  }

  // Build the theme
  ThemeData build() {
    final config = _effectiveConfig;
    final colorScheme = _buildColorScheme(config);
    final textTheme = _buildTextTheme(config);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: config.fontFamily != 'System' ? config.fontFamily : null,

      // App Bar Theme
      appBarTheme: _buildAppBarTheme(config),

      // Card Theme
      cardTheme: _buildCardTheme(config),

      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(config),
      outlinedButtonTheme: _buildOutlinedButtonTheme(config),
      textButtonTheme: _buildTextButtonTheme(config),

      // Input Theme
      inputDecorationTheme: _buildInputDecorationTheme(config),

      // Navigation Theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(config),

      // Other component themes
      chipTheme: _buildChipTheme(config),
      dialogTheme: _buildDialogTheme(config),
      snackBarTheme: _buildSnackBarTheme(config),
      progressIndicatorTheme: _buildProgressIndicatorTheme(config),
      dividerTheme: _buildDividerTheme(config),
      iconTheme: _buildIconTheme(config),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(config),
      switchTheme: _buildSwitchTheme(config),
      checkboxTheme: _buildCheckboxTheme(config),
      radioTheme: _buildRadioTheme(config),
      sliderTheme: _buildSliderTheme(config),
      tabBarTheme: _buildTabBarTheme(config),
      listTileTheme: _buildListTileTheme(config),
    );
  }

  // Build color scheme
  ColorScheme _buildColorScheme(ThemeConfig config) {
    return ColorScheme.fromSeed(
      seedColor: config.primaryColor,
      brightness: config.brightness,
      primary: config.primaryColor,
      secondary: config.secondaryColor,
      surface: config.surfaceColor,
      background: config.backgroundColor,
      error: config.errorColor,
      onPrimary: config.brightness == Brightness.light ? Colors.white : Colors.black,
      onSecondary: config.brightness == Brightness.light ? Colors.white : Colors.black,
      onSurface: config.textColor,
      onBackground: config.textColor,
      onError: Colors.white,
    );
  }

  // Build text theme
  TextTheme _buildTextTheme(ThemeConfig config) {
    final baseTextStyle = TextStyle(
      color: config.textColor,
      fontFamily: config.fontFamily != 'System' ? config.fontFamily : null,
    );

    return TextTheme(
      displayLarge: TextStyles.displayLarge.merge(baseTextStyle),
      displayMedium: TextStyles.displayMedium.merge(baseTextStyle),
      displaySmall: TextStyles.displaySmall.merge(baseTextStyle),
      headlineLarge: TextStyles.headingLarge.merge(baseTextStyle),
      headlineMedium: TextStyles.headingMedium.merge(baseTextStyle),
      headlineSmall: TextStyles.headingSmall.merge(baseTextStyle),
      titleLarge: TextStyles.titleLarge.merge(baseTextStyle),
      titleMedium: TextStyles.titleMedium.merge(baseTextStyle),
      titleSmall: TextStyles.titleSmall.merge(baseTextStyle),
      bodyLarge: TextStyles.bodyLarge.merge(baseTextStyle),
      bodyMedium: TextStyles.bodyMedium.merge(baseTextStyle),
      bodySmall: TextStyles.bodySmall.merge(baseTextStyle.copyWith(color: config.textSecondaryColor)),
      labelLarge: TextStyles.labelLarge.merge(baseTextStyle),
      labelMedium: TextStyles.labelMedium.merge(baseTextStyle),
      labelSmall: TextStyles.labelSmall.merge(baseTextStyle.copyWith(color: config.textSecondaryColor)),
    );
  }

  // Build app bar theme
  AppBarTheme _buildAppBarTheme(ThemeConfig config) {
    return AppBarTheme(
      elevation: config.appBarElevation,
      backgroundColor: config.surfaceColor,
      foregroundColor: config.textColor,
      titleTextStyle: TextStyles.appBarTitle.copyWith(color: config.textColor),
      centerTitle: true,
      systemOverlayStyle: config.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }

  // Build card theme
  CardTheme _buildCardTheme(ThemeConfig config) {
    return CardTheme(
      elevation: config.cardElevation,
      color: config.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
    );
  }

  // Build elevated button theme
  ElevatedButtonThemeData _buildElevatedButtonTheme(ThemeConfig config) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: (config.buttonHeight - 24) / 2, // Adjust for text height
        ),
        minimumSize: Size(AppSizes.buttonMinWidth, config.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
        textStyle: TextStyles.button,
      ),
    );
  }

  // Build outlined button theme
  OutlinedButtonThemeData _buildOutlinedButtonTheme(ThemeConfig config) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: config.primaryColor,
        side: BorderSide(color: config.primaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: (config.buttonHeight - 24) / 2,
        ),
        minimumSize: Size(AppSizes.buttonMinWidth, config.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
        textStyle: TextStyles.button.copyWith(color: config.primaryColor),
      ),
    );
  }

  // Build text button theme
  TextButtonThemeData _buildTextButtonTheme(ThemeConfig config) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: config.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        textStyle: TextStyles.button.copyWith(color: config.primaryColor),
      ),
    );
  }

  // Build input decoration theme
  InputDecorationTheme _buildInputDecorationTheme(ThemeConfig config) {
    return InputDecorationTheme(
      filled: true,
      fillColor: config.surfaceColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: (config.inputHeight - 24) / 2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        borderSide: BorderSide(color: config.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        borderSide: BorderSide(color: config.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        borderSide: BorderSide(color: config.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        borderSide: BorderSide(color: config.errorColor, width: 2),
      ),
      labelStyle: TextStyles.labelMedium.copyWith(color: config.textSecondaryColor),
      hintStyle: TextStyles.bodyMedium.copyWith(color: config.textLightColor),
      errorStyle: TextStyles.error.copyWith(color: config.errorColor),
    );
  }

  // Build bottom navigation bar theme
  BottomNavigationBarThemeData _buildBottomNavigationBarTheme(ThemeConfig config) {
    return BottomNavigationBarThemeData(
      backgroundColor: config.surfaceColor,
      selectedItemColor: config.primaryColor,
      unselectedItemColor: config.textSecondaryColor,
      selectedLabelStyle: TextStyles.bottomNavLabelSelected.copyWith(color: config.primaryColor),
      unselectedLabelStyle: TextStyles.bottomNavLabel.copyWith(color: config.textSecondaryColor),
      type: BottomNavigationBarType.fixed,
      elevation: AppSizes.bottomNavElevation,
    );
  }

  // Build chip theme
  ChipThemeData _buildChipTheme(ThemeConfig config) {
    return ChipThemeData(
      backgroundColor: config.surfaceColor,
      selectedColor: config.primaryColor,
      labelStyle: TextStyles.labelMedium.copyWith(color: config.textColor),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
    );
  }

  // Build dialog theme
  DialogTheme _buildDialogTheme(ThemeConfig config) {
    return DialogTheme(
      backgroundColor: config.surfaceColor,
      elevation: AppSizes.cardElevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
      titleTextStyle: TextStyles.headingMedium.copyWith(color: config.textColor),
      contentTextStyle: TextStyles.bodyMedium.copyWith(color: config.textColor),
    );
  }

  // Build snack bar theme
  SnackBarThemeData _buildSnackBarTheme(ThemeConfig config) {
    return SnackBarThemeData(
      backgroundColor: config.brightness == Brightness.light
          ? config.textColor
          : config.surfaceColor,
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: config.brightness == Brightness.light
            ? Colors.white
            : config.textColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  // Build progress indicator theme
  ProgressIndicatorThemeData _buildProgressIndicatorTheme(ThemeConfig config) {
    return ProgressIndicatorThemeData(
      color: config.primaryColor,
      linearTrackColor: config.borderColor,
      circularTrackColor: config.borderColor,
    );
  }

  // Build divider theme
  DividerThemeData _buildDividerTheme(ThemeConfig config) {
    return DividerThemeData(
      color: config.borderColor,
      thickness: AppSizes.dividerThickness,
    );
  }

  // Build icon theme
  IconThemeData _buildIconTheme(ThemeConfig config) {
    return IconThemeData(
      color: config.textColor,
      size: AppSizes.iconMedium,
    );
  }

  // Build floating action button theme
  FloatingActionButtonThemeData _buildFloatingActionButtonTheme(ThemeConfig config) {
    return FloatingActionButtonThemeData(
      backgroundColor: config.primaryColor,
      foregroundColor: Colors.white,
      elevation: config.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
      ),
    );
  }

  // Build switch theme
  SwitchThemeData _buildSwitchTheme(ThemeConfig config) {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return config.primaryColor;
          }
          return config.textLightColor;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(WidgetState.selected)) {
            return config.primaryColor.withOpacity(0.3);
          }
          return config.borderColor;
        },
      ),
    );
  }

  // Build checkbox theme
  CheckboxThemeData _buildCheckboxTheme(ThemeConfig config) {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return config.primaryColor;
          }
          return config.surfaceColor;
        },
      ),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
    );
  }

  // Build radio theme
  RadioThemeData _buildRadioTheme(ThemeConfig config) {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return config.primaryColor;
          }
          return config.textSecondaryColor;
        },
      ),
    );
  }

  // Build slider theme
  SliderThemeData _buildSliderTheme(ThemeConfig config) {
    return SliderThemeData(
      activeTrackColor: config.primaryColor,
      inactiveTrackColor: config.borderColor,
      thumbColor: config.primaryColor,
      overlayColor: config.primaryColor.withOpacity(0.2),
      valueIndicatorColor: config.primaryColor,
      valueIndicatorTextStyle: TextStyles.labelSmall.copyWith(color: Colors.white),
    );
  }

  // Build tab bar theme
  TabBarTheme _buildTabBarTheme(ThemeConfig config) {
    return TabBarTheme(
      labelColor: config.primaryColor,
      unselectedLabelColor: config.textSecondaryColor,
      labelStyle: TextStyles.labelLarge.copyWith(color: config.primaryColor),
      unselectedLabelStyle: TextStyles.labelMedium.copyWith(color: config.textSecondaryColor),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
    );
  }

  // Build list tile theme
  ListTileThemeData _buildListTileTheme(ThemeConfig config) {
    return ListTileThemeData(
      tileColor: config.surfaceColor,
      selectedTileColor: config.primaryColor.withOpacity(0.1),
      titleTextStyle: TextStyles.bodyLarge.copyWith(color: config.textColor),
      subtitleTextStyle: TextStyles.bodyMedium.copyWith(color: config.textSecondaryColor),
      leadingAndTrailingTextStyle: TextStyles.labelMedium.copyWith(color: config.textSecondaryColor),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
    );
  }
}

// Theme manager for handling multiple themes
class ThemeManager {
  static ThemeData _lightTheme = AppThemeBuilder.light().build();
  static ThemeData _darkTheme = AppThemeBuilder.dark().build();

  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;

  // Update themes
  static void updateThemes({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    if (lightTheme != null) _lightTheme = lightTheme;
    if (darkTheme != null) _darkTheme = darkTheme;
  }

  // Create themed variants
  static ThemeData createBrandTheme({
    required Color primaryColor,
    required Color secondaryColor,
    Brightness brightness = Brightness.light,
  }) {
    final config = brightness == Brightness.light
        ? ThemeConfig.light
        : ThemeConfig.dark;

    return AppThemeBuilder.custom(config)
        .withPrimaryColor(primaryColor)
        .withSecondaryColor(secondaryColor)
        .build();
  }

  // Create minimal theme
  static ThemeData createMinimalTheme({
    Brightness brightness = Brightness.light,
  }) {
    final config = brightness == Brightness.light
        ? ThemeConfig.light
        : ThemeConfig.dark;

    return AppThemeBuilder.custom(config)
        .withCardElevation(0)
        .withAppBarElevation(0)
        .withBorderRadius(AppSizes.radiusSmall)
        .build();
  }

  // Create rounded theme
  static ThemeData createRoundedTheme({
    Brightness brightness = Brightness.light,
  }) {
    final config = brightness == Brightness.light
        ? ThemeConfig.light
        : ThemeConfig.dark;

    return AppThemeBuilder.custom(config)
        .withBorderRadius(AppSizes.radiusCircular)
        .withButtonHeight(AppSizes.buttonHeightLarge)
        .build();
  }
}

// Theme extensions for additional properties
extension ThemeExtensions on ThemeData {
  // Get app-specific colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;

  // Get text colors
  Color get textPrimary => colorScheme.onBackground;
  Color get textSecondary => colorScheme.onBackground.withOpacity(0.7);
  Color get textLight => colorScheme.onBackground.withOpacity(0.5);

  // Get border colors
  Color get borderColor => colorScheme.brightness == Brightness.light
      ? AppColors.border
      : AppColors.borderDark;

  // Get skin analysis colors
  Color get skinExcellent => AppColors.skinExcellent;
  Color get skinGood => AppColors.skinGood;
  Color get skinAverage => AppColors.skinAverage;
  Color get skinPoor => AppColors.skinPoor;
  Color get skinVeryPoor => AppColors.skinVeryPoor;

  // Get gradients
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, primaryColor.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get secondaryGradient => LinearGradient(
    colors: [secondaryColor, secondaryColor.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Get custom decorations
  BoxDecoration get primaryCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Get button styles
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingLarge,
      vertical: AppSizes.paddingMedium,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    ),
  );

  ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingLarge,
      vertical: AppSizes.paddingMedium,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    ),
  );

  ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingLarge,
      vertical: AppSizes.paddingMedium,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    ),
  );

  // Get skin metric card decoration
  BoxDecoration getSkinMetricCardDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    border: Border.all(color: color.withOpacity(0.3)),
  );

  // Get scan result card decoration
  BoxDecoration get scanResultCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    border: Border.all(color: borderColor),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Get product card decoration
  BoxDecoration get productCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

// Predefined theme collections
class ThemeCollection {
  // Material Design 3 inspired themes
  static final Map<String, ThemeData> material3Themes = {
    'light': AppThemeBuilder.light().build(),
    'dark': AppThemeBuilder.dark().build(),
  };

  // Skincare app specific themes
  static final Map<String, ThemeData> skincareThemes = {
    'fresh': AppThemeBuilder.light()
        .withPrimaryColor(const Color(0xFF4CAF50))
        .withSecondaryColor(const Color(0xFF8BC34A))
        .withAccentColor(const Color(0xFF00BCD4))
        .build(),
    'elegant': AppThemeBuilder.light()
        .withPrimaryColor(const Color(0xFF9C27B0))
        .withSecondaryColor(const Color(0xFFE91E63))
        .withAccentColor(const Color(0xFF673AB7))
        .build(),
    'minimal': AppThemeBuilder.light()
        .withPrimaryColor(const Color(0xFF37474F))
        .withSecondaryColor(const Color(0xFF546E7A))
        .withCardElevation(0)
        .withAppBarElevation(0)
        .build(),
    'warm': AppThemeBuilder.light()
        .withPrimaryColor(const Color(0xFFFF9800))
        .withSecondaryColor(const Color(0xFFFF5722))
        .withAccentColor(const Color(0xFFFFC107))
        .build(),
  };

  // Accessibility themes
  static final Map<String, ThemeData> accessibilityThemes = {
    'high_contrast_light': AppThemeBuilder.light()
        .withPrimaryColor(Colors.black)
        .withSecondaryColor(const Color(0xFF1976D2))
        .withBorderRadius(AppSizes.radiusSmall)
        .withButtonHeight(AppSizes.buttonHeightLarge)
        .build(),
    'high_contrast_dark': AppThemeBuilder.dark()
        .withPrimaryColor(Colors.white)
        .withSecondaryColor(const Color(0xFF90CAF9))
        .withBorderRadius(AppSizes.radiusSmall)
        .withButtonHeight(AppSizes.buttonHeightLarge)
        .build(),
  };

  // Get theme by name
  static ThemeData? getTheme(String name) {
    return material3Themes[name] ??
        skincareThemes[name] ??
        accessibilityThemes[name];
  }

  // Get all available theme names
  static List<String> get allThemeNames => [
    ...material3Themes.keys,
    ...skincareThemes.keys,
    ...accessibilityThemes.keys,
  ];
}