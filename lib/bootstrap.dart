import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/scan_provider.dart';
import 'services/storage/secure_storage_service.dart';
import 'services/camera/camera_service.dart';
import 'services/ml/skin_analysis_service.dart';
import 'services/ml/tflite_service.dart';
import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/local/product_local_datasource.dart';
import 'data/datasources/local/scan_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/datasources/remote/scan_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/scan_repository_impl.dart';
import 'domain/usecases/auth/sign_in_usecase.dart';
import 'domain/usecases/auth/sign_out_usecase.dart';
import 'domain/usecases/auth/sign_up_usecase.dart';
import 'domain/usecases/product/get_recommendations_usecase.dart';
import 'domain/usecases/scan/analyze_skin_usecase.dart';
import 'domain/usecases/scan/create_scan_usecase.dart';
import 'domain/usecases/scan/get_scan_history_usecase.dart';

void bootstrap() {
  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<SecureStorageService>(
          create: (_) => SecureStorageService(),
        ),
        Provider<CameraService>(
          create: (_) => CameraService(),
        ),
        Provider<TfliteService>(
          create: (_) => TfliteService(),
        ),
        Provider<SkinAnalysisService>(
          create: (context) => SkinAnalysisService(
            context.read<TfliteService>(),
          ),
        ),

        // Data Sources
        Provider<AuthLocalDataSource>(
          create: (context) => AuthLocalDataSource(
            context.read<SecureStorageService>(),
          ),
        ),
        Provider<ProductLocalDataSource>(
          create: (context) => ProductLocalDataSource(
            context.read<SecureStorageService>(),
          ),
        ),
        Provider<ScanLocalDataSource>(
          create: (context) => ScanLocalDataSource(
            context.read<SecureStorageService>(),
          ),
        ),
        Provider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSource(),
        ),
        Provider<ProductRemoteDataSource>(
          create: (_) => ProductRemoteDataSource(),
        ),
        Provider<ScanRemoteDataSource>(
          create: (_) => ScanRemoteDataSource(),
        ),

        // Repositories
        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            localDataSource: context.read<AuthLocalDataSource>(),
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),
        Provider<ProductRepositoryImpl>(
          create: (context) => ProductRepositoryImpl(
            localDataSource: context.read<ProductLocalDataSource>(),
            remoteDataSource: context.read<ProductRemoteDataSource>(),
          ),
        ),
        Provider<ScanRepositoryImpl>(
          create: (context) => ScanRepositoryImpl(
            localDataSource: context.read<ScanLocalDataSource>(),
            remoteDataSource: context.read<ScanRemoteDataSource>(),
          ),
        ),

        // Use Cases
        Provider<SignInUseCase>(
          create: (context) => SignInUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<SignOutUseCase>(
          create: (context) => SignOutUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<GetRecommendationsUseCase>(
          create: (context) => GetRecommendationsUseCase(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        Provider<AnalyzeSkinUseCase>(
          create: (context) => AnalyzeSkinUseCase(
            context.read<ScanRepositoryImpl>(),
            context.read<SkinAnalysisService>(),
          ),
        ),
        Provider<CreateScanUseCase>(
          create: (context) => CreateScanUseCase(
            context.read<ScanRepositoryImpl>(),
          ),
        ),
        Provider<GetScanHistoryUseCase>(
          create: (context) => GetScanHistoryUseCase(
            context.read<ScanRepositoryImpl>(),
          ),
        ),

        // Providers
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            signInUseCase: context.read<SignInUseCase>(),
            signOutUseCase: context.read<SignOutUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
          ),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            getRecommendationsUseCase: context.read<GetRecommendationsUseCase>(),
          ),
        ),
        ChangeNotifierProvider<ScanProvider>(
          create: (context) => ScanProvider(
            analyzeSkinUseCase: context.read<AnalyzeSkinUseCase>(),
            createScanUseCase: context.read<CreateScanUseCase>(),
            getScanHistoryUseCase: context.read<GetScanHistoryUseCase>(),
          ),
        ),
      ],
      child: const AlphaSkinCareApp(),
    ),
  );
}
