import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize services
  await _initializeServices();

  runApp(
    const ProviderScope(
      child: SkinSenseApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  // Initialize local storage
  await Hive.openBox('settings');
  await Hive.openBox('user_data');

  // Initialize notification service
  // await NotificationService().init();
}