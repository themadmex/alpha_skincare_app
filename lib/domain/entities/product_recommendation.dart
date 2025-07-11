// lib/domain/entities/product_recommendation.dart
class ProductRecommendation {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final List<String> suitableForSkinTypes;
  final List<String> targetsConcerns;
  final int matchPercentage;
  final String purchaseUrl;
  final String? size;
  final Map<String, dynamic>? additionalInfo;
  final bool isRecommended;
  final DateTime? createdAt;

  const ProductRecommendation({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.suitableForSkinTypes,
    required this.targetsConcerns,
    required this.matchPercentage,
    required this.purchaseUrl,
    this.size,
    this.additionalInfo,
    this.isRecommended = true,
    this.createdAt,
  });

  ProductRecommendation copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    double? rating,
    String? imageUrl,
    String? description,
    List<String>? ingredients,
    List<String>? suitableForSkinTypes,
    List<String>? targetsConcerns,
    int? matchPercentage,
    String? purchaseUrl,
    String? size,
    Map<String, dynamic>? additionalInfo,
    bool? isRecommended,
    DateTime? createdAt,
  }) {
    return ProductRecommendation(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      suitableForSkinTypes: suitableForSkinTypes ?? this.suitableForSkinTypes,
      targetsConcerns: targetsConcerns ?? this.targetsConcerns,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
      size: size ?? this.size,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isRecommended: isRecommended ?? this.isRecommended,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'ingredients': ingredients,
      'suitableForSkinTypes': suitableForSkinTypes,
      'targetsConcerns': targetsConcerns,
      'matchPercentage': matchPercentage,
      'purchaseUrl': purchaseUrl,
      'size': size,
      'additionalInfo': additionalInfo,
      'isRecommended': isRecommended,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      suitableForSkinTypes: List<String>.from(json['suitableForSkinTypes'] as List),
      targetsConcerns: List<String>.from(json['targetsConcerns'] as List),
      matchPercentage: json['matchPercentage'] as int,
      purchaseUrl: json['purchaseUrl'] as String,
      size: json['size'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
      isRecommended: json['isRecommended'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Helper methods
  String get priceRange {
    if (price < 15) return 'Budget';
    if (price < 30) return 'Mid-range';
    return 'Premium';
  }

  String get ratingText {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 3.0) return 'Average';
    return 'Below Average';
  }

  String get matchQuality {
    if (matchPercentage >= 90) return 'Excellent Match';
    if (matchPercentage >= 80) return 'Very Good Match';
    if (matchPercentage >= 70) return 'Good Match';
    if (matchPercentage >= 60) return 'Fair Match';
    return 'Poor Match';
  }

  bool isSuitableForSkinType(String skinType) {
    return suitableForSkinTypes.contains(skinType) ||
        suitableForSkinTypes.contains('All Types');
  }

  bool targetsConcern(String concern) {
    return targetsConcerns.contains(concern);
  }

  bool containsIngredient(String ingredient) {
    return ingredients.any((ing) =>
        ing.toLowerCase().contains(ingredient.toLowerCase()));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductRecommendation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductRecommendation(id: $id, name: $name, brand: $brand, category: $category, matchPercentage: $matchPercentage%)';
  }
}