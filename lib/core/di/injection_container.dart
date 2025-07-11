// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/profile_remote_datasource.dart';
import '../../data/datasources/remote/scan_remote_datasource.dart';
import '../../data/datasources/remote/recommendations_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/local/profile_local_datasource.dart';
import '../../data/datasources/local/scan_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../data/repositories/recommendations_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../domain/usecases/profile/get_profile_usecase.dart';
import '../../domain/usecases/profile/update_profile_usecase.dart';
import '../../domain/usecases/scan/analyze_skin_usecase.dart';
import '../../domain/usecases/scan/get_scan_history_usecase.dart';
import '../../domain/usecases/recommendations/get_recommendations_usecase.dart';
import '../config/app_config.dart';
import '../network/network_info.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());

  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ScanRemoteDataSource>(
        () => ScanRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ScanLocalDataSource>(
        () => ScanLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecommendationsRemoteDataSource>(
        () => RecommendationsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ScanRepository>(
        () => ScanRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<RecommendationsRepository>(
        () => RecommendationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));

  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));

  sl.registerLazySingleton(() => AnalyzeSkinUsecase(sl()));
  sl.registerLazySingleton(() => GetScanHistoryUsecase(sl()));

  sl.registerLazySingleton(() => GetRecommendationsUsecase(sl()));
}