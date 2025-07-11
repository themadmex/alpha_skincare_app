import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart'; // Ensure this points to the correct file
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Should now resolve correctly
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  try {
    // Initialize Hive
    await Hive.initFlutter();
    await _initializeServices();
  } catch (e) {
    debugPrint('Hive initialization failed: $e');
  }

  runApp(
    const ProviderScope(
      child: SkinSenseApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
    // Initialize local storage
    await Hive.openBox('settings');
    await Hive.openBox('user_data');

    // Initialize notification service (uncomment when implemented)
    // await NotificationService().init();
  } catch (e) {
    debugPrint('Service initialization failed: $e');
  }
}

class SkinSenseApp extends ConsumerWidget {
  const SkinSenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'SkinSense',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}