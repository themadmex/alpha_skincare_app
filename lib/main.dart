import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

/// Main entry point for the Alpha Skincare App
/// Initializes all required services and configurations before running the app
void main() async {
  // Ensure Flutter binding is initialized before calling async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred device orientations to portrait only for consistent UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize the app with error handling
  await _initializeApp();
}

/// Initializes all required services and runs the app
Future<void> _initializeApp() async {
  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize SharedPreferences for local storage
    final sharedPreferences = await SharedPreferences.getInstance();

    // Set system UI overlay style for elegant appearance
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF8F5F2), // Warm off-white
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Run the app with Riverpod state management and error handling
    runApp(
      ProviderScope(
        overrides: [
          // Override the sharedPreferences provider with the initialized instance
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const AlphaSkincareApp(),
      ),
    );
  } catch (error, stackTrace) {
    // Log initialization errors
    debugPrint('Failed to initialize app: $error');
    debugPrint('Stack trace: $stackTrace');

    // Run error app to show user-friendly error message
    runApp(
      MaterialApp(
        theme: _getErrorTheme(),
        home: _ErrorScreen(error: error.toString()),
      ),
    );
  }
}

/// Provider for SharedPreferences instance
/// This allows us to inject SharedPreferences throughout the app
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // This will be overridden in main() with the actual instance
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Error theme that matches the app's elegant aesthetic
ThemeData _getErrorTheme() {
  return ThemeData(
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C5CE7),
      secondary: Color(0xFF00B894),
    ),
  );
}

/// Elegant error screen shown when app initialization fails
class _ErrorScreen extends StatelessWidget {
  final String error;

  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F5F2), // Warm off-white
              Color(0xFFE8E2DC), // Light beige
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Elegant error icon with circular background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    size: 60,
                    color: Color(0xFF6C5CE7),
                  ),
                ),
                const SizedBox(height: 40),

                // Error title with elegant typography
                Text(
                  'Oops!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: const Color(0xFF2D2D2D),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF2D2D2D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Error message with soft styling
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'We couldn\'t start the app properly. Please check your internet connection and try again.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF666666),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                // Retry button with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF8B7FE8)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C5CE7).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Restart the app
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'CLOSE APP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                // Debug info with elegant styling (only in debug mode)
                if (kDebugMode) ...[
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8E2DC),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEBUG INFO',
                          style: TextStyle(
                            color: const Color(0xFF666666),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Welcome Screen Notes:
// The app will feature an elegant welcome screen similar to the beauty salon design,
// with:
// - Warm, inviting color palette (off-white backgrounds, purple accents)
// - Circular design elements and soft shadows
// - "Love Your Skin Better" as the main tagline
// - Clean, minimal UI with premium feel
// - Smooth animations and transitions
//
// Platform-specific initialization notes:
//
// For iOS:
// 1. Add Firebase configuration file (GoogleService-Info.plist) to ios/Runner/
// 2. Update ios/Runner/Info.plist with required permissions:
//    - NSCameraUsageDescription for camera access
//    - NSPhotoLibraryUsageDescription for photo library access
//    - NSFaceIDUsageDescription for Face ID authentication
//
// For Android:
// 1. Add Firebase configuration file (google-services.json) to android/app/
// 2. Update android/app/src/main/AndroidManifest.xml with permissions:
//    - android.permission.CAMERA
//    - android.permission.INTERNET
//    - android.permission.USE_BIOMETRIC
// 3. Update android/app/build.gradle with minSdkVersion 21 or higher