import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_builder.dart';
import 'core/constants/app_strings.dart';
import 'presentation/router/app_router.dart';
import 'presentation/providers/auth_provider.dart';

class AlphaSkinCareApp extends StatelessWidget {
  const AlphaSkinCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.getRouter(authProvider),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}