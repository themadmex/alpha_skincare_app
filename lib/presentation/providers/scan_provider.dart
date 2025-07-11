// lib/presentation/providers/scan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../data/repositories/scan_repository_impl.dart';
import 'auth_provider.dart';

// Scan Repository Provider
final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepositoryImpl();
});

// Scan State
class ScanState {
  final List<ScanResult> scanResults;
  final bool isLoading;
  final String? error;

  const ScanState({
    this.scanResults = const [],
    this.isLoading = false,
    this.error,
  });

  ScanState copyWith({
    List<ScanResult>? scanResults,
    bool? isLoading,
    String? error,
  }) {
    return ScanState(
      scanResults: scanResults ?? this.scanResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Scan Controller
class ScanController extends StateNotifier<ScanState> {
  final ScanRepository _scanRepository;

  ScanController(this._scanRepository) : super(const ScanState());

  Future<void> analyzeSkin(String imagePath) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _scanRepository.analyzeSkin(imagePath);
      final updatedResults = [result, ...state.scanResults];
      state = state.copyWith(
        isLoading: false,
        scanResults: updatedResults,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> loadScanHistory(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _scanRepository.getScanHistory(userId);
      state = state.copyWith(
        isLoading: false,
        scanResults: results,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadRecentScans() async {
    // For now, we'll use a mock user ID
    // In a real app, this would come from the auth state
    await loadRecentScansForUser('mock_user_id');
  }

  Future<void> loadRecentScansForUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _scanRepository.getRecentScans(userId, limit: 5);
      state = state.copyWith(
        isLoading: false,
        scanResults: results,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAllScans() async {
    // For now, we'll use a mock user ID
    await loadScanHistory('mock_user_id');
  }

  Future<void> deleteScanResult(String scanId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _scanRepository.deleteScanResult(scanId);
      final updatedResults = state.scanResults
          .where((result) => result.id != scanId)
          .toList();
      state = state.copyWith(
        isLoading: false,
        scanResults: updatedResults,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

// Scan Controller Provider
final scanControllerProvider = StateNotifierProvider<ScanController, ScanState>((ref) {
  final scanRepository = ref.watch(scanRepositoryProvider);
  return ScanController(scanRepository);
});