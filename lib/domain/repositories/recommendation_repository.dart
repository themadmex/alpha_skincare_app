// lib/domain/repositories/recommendations_repository.dart
import '../entities/product_recommendation.dart';

abstract class RecommendationsRepository {
  Future<List<ProductRecommendation>> getRecommendations(String userId);
  Future<List<ProductRecommendation>> getRecommendationsByCategory(String category);
  Future<ProductRecommendation?> getProductDetails(String productId);
  Future<List<ProductRecommendation>> searchProducts(String query);
}