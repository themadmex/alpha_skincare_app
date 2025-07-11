// lib/presentation/providers/recommendations_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../data/repositories/recommendations_repository_impl.dart';

// Recommendations Repository Provider
final recommendationsRepositoryProvider = Provider<RecommendationsRepository>((ref) {
  return RecommendationsRepositoryImpl();
});

// Recommendations State
class RecommendationsState {
  final List<ProductRecommendation> recommendations;
  final bool isLoading;
  final String? error;

  const RecommendationsState({
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
  });

  RecommendationsState copyWith({
    List<ProductRecommendation>? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationsState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Recommendations Controller
class RecommendationsController extends StateNotifier<RecommendationsState> {
  final RecommendationsRepository _recommendationsRepository;

  RecommendationsController(this._recommendationsRepository) : super(const RecommendationsState());

  Future<void> loadRecommendations() async {
    // For now, we'll use a mock user ID
    await loadRecommendationsForUser('mock_user_id');
  }

  Future<void> loadRecommendationsForUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final recommendations = await _recommendationsRepository.getRecommendations(userId);
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadRecommendationsByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final recommendations = await _recommendationsRepository.getRecommendationsByCategory(category);
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchProducts(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final recommendations = await _recommendationsRepository.searchProducts(query);
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Recommendations Controller Provider
final recommendationsControllerProvider = StateNotifierProvider<RecommendationsController, RecommendationsState>((ref) {
  final recommendationsRepository = ref.watch(recommendationsRepositoryProvider);
  return RecommendationsController(recommendationsRepository);
});