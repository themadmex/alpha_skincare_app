// lib/core/services/connectivity_service.dart
abstract class ConnectivityService {
  Future<bool> isConnected();
  Stream<bool> get connectivityStream;
}

class SimpleConnectivityService implements ConnectivityService {
  @override
  Future<bool> isConnected() async {
    // Simple implementation - in real app you'd check actual connectivity
    return true;
  }

  @override
  Stream<bool> get connectivityStream {
    // Simple implementation - in real app you'd stream actual connectivity changes
    return Stream.periodic(const Duration(seconds: 5), (_) => true);
  }
}