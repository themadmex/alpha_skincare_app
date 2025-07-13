import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }

  try {
    // Initialize Hive
    await Hive.initFlutter();
    await _initializeServices();
    debugPrint('✅ Hive initialized successfully');
  } catch (e) {
    debugPrint('❌ Hive initialization failed: $e');
    // Continue without Hive for now
  }

  runApp(
    const ProviderScope(
      child: SkinSenseApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
    // Initialize local storage boxes
    await Hive.openBox('settings');
    await Hive.openBox('user_data');
    await Hive.openBox('scan_results');
    await Hive.openBox('app_cache');

    debugPrint('✅ All Hive boxes opened successfully');

    // Initialize notification service (when implemented)
    // await NotificationService().init();
  } catch (e) {
    debugPrint('❌ Service initialization failed: $e');
    // Continue without some services for now
  }
}

class SkinSenseApp extends ConsumerWidget {
  const SkinSenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SkinSense',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}