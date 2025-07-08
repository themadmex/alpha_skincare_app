// lib/presentation/providers/scan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../domain/entities/scan_result.dart';
import '../../data/repositories/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepository();
});

final scanControllerProvider = NotifierProvider<ScanController, AsyncValue<ScanResult?>>(() {
  return ScanController();
});

class ScanController extends Notifier<AsyncValue<ScanResult?>> {
  @override
  AsyncValue<ScanResult?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> analyzeSkin(File imageFile) async {
    state = const AsyncValue.loading();

    try {
      final scanRepository = ref.read(scanRepositoryProvider);
      final result = await scanRepository.analyzeSkin(imageFile);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

final scanHistoryProvider = StreamProvider<List<ScanResult>>((ref) {
  final scanRepository = ref.read(scanRepositoryProvider);
  return scanRepository.getScanHistory();
});