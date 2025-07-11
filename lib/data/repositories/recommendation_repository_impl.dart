// lib/data/repositories/recommendations_repository_impl.dart
import '../../core/constants/app_constant.dart';
import '../../domain/entities/product_recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../core/constants/app_constants.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  // Expanded mock data with more realistic products
  final List<ProductRecommendation> _mockRecommendations = [
    // Cleansers
    ProductRecommendation(
      id: 'cleanser_1',
      name: 'Foaming Facial Cleanser',
      brand: 'CeraVe',
      category: AppConstants.categoryCleanser,
      price: 14.99,
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1556229174-f6b0f65ac6a1?w=300&h=300&fit=crop',
      description: 'A gentle foaming cleanser that removes dirt, oil, and makeup without disrupting the skin barrier.',
      ingredients: ['Ceramides', 'Hyaluronic Acid', 'Niacinamide', 'Vitamin B5'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernAcne, AppConstants.concernOiliness],
      matchPercentage: 95,
      purchaseUrl: 'https://example.com/cerave-cleanser',
    ),
    ProductRecommendation(
      id: 'cleanser_2',
      name: 'Hydrating Cream Cleanser',
      brand: 'Neutrogena',
      category: AppConstants.categoryCleanser,
      price: 12.99,
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=300&h=300&fit=crop',
      description: 'A creamy, non-foaming cleanser that gently removes impurities while maintaining moisture.',
      ingredients: ['Glycerin', 'Petrolatum', 'Dimethicone', 'Panthenol'],
      suitableForSkinTypes: [AppConstants.skinTypeDry, AppConstants.skinTypeSensitive, AppConstants.skinTypeNormal],
      targetsConcerns: [AppConstants.concernDryness, AppConstants.concernSensitivity],
      matchPercentage: 88,
      purchaseUrl: 'https://example.com/neutrogena-cleanser',
    ),
    ProductRecommendation(
      id: 'cleanser_3',
      name: 'Gentle Gel Cleanser',
      brand: 'La Roche-Posay',
      category: AppConstants.categoryCleanser,
      price: 19.99,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop',
      description: 'A soap-free gel cleanser for sensitive skin that removes makeup and impurities.',
      ingredients: ['Thermal Spring Water', 'Sodium Cocoamphoacetate', 'Zinc Gluconate'],
      suitableForSkinTypes: [AppConstants.skinTypeSensitive, AppConstants.skinTypeNormal],
      targetsConcerns: [AppConstants.concernSensitivity, AppConstants.concernRedness],
      matchPercentage: 91,
      purchaseUrl: 'https://example.com/laroche-cleanser',
    ),

    // Moisturizers
    ProductRecommendation(
      id: 'moisturizer_1',
      name: 'Daily Moisturizing Lotion',
      brand: 'CeraVe',
      category: AppConstants.categoryMoisturizer,
      price: 16.99,
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=300&h=300&fit=crop',
      description: 'A lightweight, non-comedogenic moisturizer with essential ceramides and hyaluronic acid.',
      ingredients: ['Ceramides', 'Hyaluronic Acid', 'MVE Technology', 'Dimethicone'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeDry, AppConstants.skinTypeSensitive],
      targetsConcerns: [AppConstants.concernDryness],
      matchPercentage: 89,
      purchaseUrl: 'https://example.com/cerave-moisturizer',
    ),
    ProductRecommendation(
      id: 'moisturizer_2',
      name: 'Oil-Free Moisture Gel',
      brand: 'Neutrogena',
      category: AppConstants.categoryMoisturizer,
      price: 13.99,
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1583001931096-959e9a1a6223?w=300&h=300&fit=crop',
      description: 'An oil-free, lightweight gel that provides long-lasting hydration without clogging pores.',
      ingredients: ['Glycerin', 'Hyaluronic Acid', 'Cucumber Extract'],
      suitableForSkinTypes: [AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernOiliness, AppConstants.concernPores],
      matchPercentage: 85,
      purchaseUrl: 'https://example.com/neutrogena-gel',
    ),
    ProductRecommendation(
      id: 'moisturizer_3',
      name: 'Rich Repair Cream',
      brand: 'Eucerin',
      category: AppConstants.categoryMoisturizer,
      price: 22.99,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1556760544-74068565f05c?w=300&h=300&fit=crop',
      description: 'An intensive repair cream for very dry skin with urea and ceramides.',
      ingredients: ['Urea', 'Ceramides', 'Natural Moisturizing Factors', 'Glycerin'],
      suitableForSkinTypes: [AppConstants.skinTypeDry, AppConstants.skinTypeSensitive],
      targetsConcerns: [AppConstants.concernDryness, AppConstants.concernSensitivity],
      matchPercentage: 93,
      purchaseUrl: 'https://example.com/eucerin-cream',
    ),

    // Serums
    ProductRecommendation(
      id: 'serum_1',
      name: 'Vitamin C Serum',
      brand: 'The Ordinary',
      category: AppConstants.categorySerum,
      price: 8.90,
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1620916297893-94f29c58e57e?w=300&h=300&fit=crop',
      description: 'A potent vitamin C serum that brightens skin and reduces the appearance of dark spots.',
      ingredients: ['L-Ascorbic Acid 23%', 'Alpha Tocopherol', 'Zinc Sulfate'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernDarkSpots, AppConstants.concernDullness, AppConstants.concernUnevenTone],
      matchPercentage: 92,
      purchaseUrl: 'https://example.com/ordinary-vitamin-c',
    ),
    ProductRecommendation(
      id: 'serum_2',
      name: 'Hyaluronic Acid Serum',
      brand: 'The Ordinary',
      category: AppConstants.categorySerum,
      price: 6.80,
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=300&h=300&fit=crop',
      description: 'A moisture-binding serum that holds up to 1000 times its weight in water.',
      ingredients: ['Hyaluronic Acid', 'Sodium Hyaluronate', 'Vitamin B5'],
      suitableForSkinTypes: ['All Types'],
      targetsConcerns: [AppConstants.concernDryness, AppConstants.concernWrinkles],
      matchPercentage: 96,
      purchaseUrl: 'https://example.com/ordinary-hyaluronic',
    ),
    ProductRecommendation(
      id: 'serum_3',
      name: 'Niacinamide 10% Serum',
      brand: 'The Ordinary',
      category: AppConstants.categorySerum,
      price: 6.90,
      rating: 4.1,
      imageUrl: 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=300&h=300&fit=crop',
      description: 'A high-concentration niacinamide serum that reduces enlarged pores and improves skin texture.',
      ingredients: ['Niacinamide 10%', 'Zinc PCA 1%', 'Tasmanian Pepperberry'],
      suitableForSkinTypes: [AppConstants.skinTypeOily, AppConstants.skinTypeCombination, AppConstants.skinTypeNormal],
      targetsConcerns: [AppConstants.concernPores, AppConstants.concernOiliness, AppConstants.concernAcne],
      matchPercentage: 87,
      purchaseUrl: 'https://example.com/ordinary-niacinamide',
    ),
    ProductRecommendation(
      id: 'serum_4',
      name: 'Retinol Anti-Aging Serum',
      brand: 'Olay',
      category: AppConstants.categorySerum,
      price: 28.99,
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?w=300&h=300&fit=crop',
      description: 'A gentle retinol serum that helps reduce fine lines and improves skin texture.',
      ingredients: ['Retinol', 'Niacinamide', 'Amino-Peptides', 'Vitamin E'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeDry, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernWrinkles, AppConstants.concernUnevenTone, AppConstants.concernDullness],
      matchPercentage: 90,
      purchaseUrl: 'https://example.com/olay-retinol',
    ),

    // Sunscreens
    ProductRecommendation(
      id: 'sunscreen_1',
      name: 'Broad Spectrum SPF 50',
      brand: 'La Roche-Posay',
      category: AppConstants.categorySunscreen,
      price: 19.99,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1556228578-dd6e03c8605c?w=300&h=300&fit=crop',
      description: 'A lightweight, non-greasy sunscreen with broad spectrum UVA/UVB protection.',
      ingredients: ['Zinc Oxide', 'Titanium Dioxide', 'Niacinamide', 'Thermal Spring Water'],
      suitableForSkinTypes: ['All Types'],
      targetsConcerns: ['Sun Protection', AppConstants.concernWrinkles],
      matchPercentage: 94,
      purchaseUrl: 'https://example.com/laroche-sunscreen',
    ),
    ProductRecommendation(
      id: 'sunscreen_2',
      name: 'Clear Face SPF 30',
      brand: 'Neutrogena',
      category: AppConstants.categorySunscreen,
      price: 11.99,
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=300&h=300&fit=crop',
      description: 'A clear, oil-free sunscreen designed for acne-prone skin.',
      ingredients: ['Zinc Oxide', 'Helioplex Technology', 'Silica'],
      suitableForSkinTypes: [AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernAcne, 'Sun Protection'],
      matchPercentage: 86,
      purchaseUrl: 'https://example.com/neutrogena-sunscreen',
    ),

    // Treatment Products
    ProductRecommendation(
      id: 'treatment_1',
      name: 'Salicylic Acid Spot Treatment',
      brand: 'Paula\'s Choice',
      category: AppConstants.categoryTreatment,
      price: 26.00,
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop',
      description: 'A targeted spot treatment with 2% salicylic acid to clear acne and prevent future breakouts.',
      ingredients: ['Salicylic Acid 2%', 'Green Tea Extract', 'Chamomile'],
      suitableForSkinTypes: [AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernAcne, AppConstants.concernPores],
      matchPercentage: 91,
      purchaseUrl: 'https://example.com/paulas-choice-treatment',
    ),
    ProductRecommendation(
      id: 'treatment_2',
      name: 'Dark Spot Corrector',
      brand: 'Clinique',
      category: AppConstants.categoryTreatment,
      price: 49.50,
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=300&h=300&fit=crop',
      description: 'An intensive treatment that targets dark spots and improves overall skin tone.',
      ingredients: ['Kojic Acid', 'Vitamin C', 'Glucosamine', 'Salicylic Acid'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernDarkSpots, AppConstants.concernUnevenTone],
      matchPercentage: 88,
      purchaseUrl: 'https://example.com/clinique-corrector',
    ),

    // Exfoliants
    ProductRecommendation(
      id: 'exfoliant_1',
      name: 'AHA/BHA Exfoliating Toner',
      brand: 'Paula\'s Choice',
      category: AppConstants.categoryExfoliant,
      price: 32.00,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=300&fit=crop',
      description: 'A gentle chemical exfoliant that removes dead skin cells and improves texture.',
      ingredients: ['Salicylic Acid', 'Glycolic Acid', 'Green Tea Extract'],
      suitableForSkinTypes: [AppConstants.skinTypeNormal, AppConstants.skinTypeOily, AppConstants.skinTypeCombination],
      targetsConcerns: [AppConstants.concernPores, AppConstants.concernDullness, AppConstants.concernUnevenTone],
      matchPercentage: 89,
      purchaseUrl: 'https://example.com/paulas-choice-exfoliant',
    ),
  ];

  @override
  Future<List<ProductRecommendation>> getRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would analyze user's skin profile and scan results
    // to provide personalized recommendations
    return _getPersonalizedRecommendations(userId);
  }

  @override
  Future<List<ProductRecommendation>> getRecommendationsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (category == 'All') {
      return List.from(_mockRecommendations);
    }

    return _mockRecommendations
        .where((product) => product.category == category)
        .toList();
  }

  @override
  Future<ProductRecommendation?> getProductDetails(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockRecommendations.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductRecommendation>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) {
      return List.from(_mockRecommendations);
    }

    final lowercaseQuery = query.toLowerCase();

    return _mockRecommendations
        .where((product) =>
    product.name.toLowerCase().contains(lowercaseQuery) ||
        product.brand.toLowerCase().contains(lowercaseQuery) ||
        product.category.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery) ||
        product.ingredients.any((ingredient) =>
            ingredient.toLowerCase().contains(lowercaseQuery)) ||
        product.targetsConcerns.any((concern) =>
            concern.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  // Additional methods for enhanced functionality
  Future<List<ProductRecommendation>> getRecommendationsBySkinType(String skinType) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockRecommendations
        .where((product) =>
    product.suitableForSkinTypes.contains(skinType) ||
        product.suitableForSkinTypes.contains('All Types'))
        .toList();
  }

  Future<List<ProductRecommendation>> getRecommendationsByConcern(String concern) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockRecommendations
        .where((product) => product.targetsConcerns.contains(concern))
        .toList();
  }

  Future<List<ProductRecommendation>> getRecommendationsByPriceRange(double minPrice, double maxPrice) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockRecommendations
        .where((product) => product.price >= minPrice && product.price <= maxPrice)
        .toList();
  }

  Future<List<ProductRecommendation>> getTopRatedProducts({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sortedProducts = List<ProductRecommendation>.from(_mockRecommendations);
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));

    return sortedProducts.take(limit).toList();
  }

  Future<List<ProductRecommendation>> getBestMatchProducts(String userId, {int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final sortedProducts = List<ProductRecommendation>.from(_mockRecommendations);
    sortedProducts.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));

    return sortedProducts.take(limit).toList();
  }

  // Private helper methods
  List<ProductRecommendation> _getPersonalizedRecommendations(String userId) {
    // In a real app, this would:
    // 1. Get user's skin profile and concerns
    // 2. Get latest scan results
    // 3. Apply ML algorithms to rank products
    // 4. Consider user's purchase history and preferences
    // 5. Apply collaborative filtering based on similar users

    // For now, return a curated selection based on common skin concerns
    final personalizedProducts = <ProductRecommendation>[];

    // Always recommend a good cleanser and moisturizer
    personalizedProducts.addAll(_mockRecommendations
        .where((p) => p.category == AppConstants.categoryCleanser)
        .take(1));
    personalizedProducts.addAll(_mockRecommendations
        .where((p) => p.category == AppConstants.categoryMoisturizer)
        .take(1));

    // Always recommend sunscreen
    personalizedProducts.addAll(_mockRecommendations
        .where((p) => p.category == AppConstants.categorySunscreen)
        .take(1));

    // Add targeted serums based on common concerns
    personalizedProducts.addAll(_mockRecommendations
        .where((p) => p.category == AppConstants.categorySerum)
        .take(2));

    // Add treatment if needed
    personalizedProducts.addAll(_mockRecommendations
        .where((p) => p.category == AppConstants.categoryTreatment)
        .take(1));

    // Add remaining products to reach desired count
    final remainingProducts = _mockRecommendations
        .where((p) => !personalizedProducts.contains(p))
        .take(10 - personalizedProducts.length);

    personalizedProducts.addAll(remainingProducts);

    // Sort by match percentage descending
    personalizedProducts.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));

    return personalizedProducts;
  }

  // Method to simulate product availability
  Future<bool> checkProductAvailability(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Mock availability - 90% of products are available
    return DateTime.now().millisecond % 10 != 0;
  }

  // Method to get product reviews (mock data)
  Future<List<Map<String, dynamic>>> getProductReviews(String productId, {int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock reviews
    return [
      {
        'id': 'review_1',
        'userName': 'Sarah M.',
        'rating': 5.0,
        'comment': 'Amazing product! Really helped with my skin concerns.',
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'verified': true,
      },
      {
        'id': 'review_2',
        'userName': 'Jessica L.',
        'rating': 4.0,
        'comment': 'Good product, but took a few weeks to see results.',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'verified': true,
      },
      {
        'id': 'review_3',
        'userName': 'Maria K.',
        'rating': 5.0,
        'comment': 'Perfect for sensitive skin. No irritation at all!',
        'date': DateTime.now().subtract(const Duration(days: 45)),
        'verified': false,
      },
    ];
  }

  // Method to get similar products
  Future<List<ProductRecommendation>> getSimilarProducts(String productId, {int limit = 4}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final targetProduct = await getProductDetails(productId);
    if (targetProduct == null) return [];

    return _mockRecommendations
        .where((product) =>
    product.id != productId &&
        (product.category == targetProduct.category ||
            product.targetsConcerns.any((concern) =>
                targetProduct.targetsConcerns.contains(concern))))
        .take(limit)
        .toList();
  }
}