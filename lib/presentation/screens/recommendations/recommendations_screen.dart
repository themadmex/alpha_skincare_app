// lib/presentation/screens/recommendations/recommendations_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/recommendations/product_card.dart';
import '../../widgets/recommendations/category_filter.dart';
import '../../widgets/recommendations/recommendation_header.dart';
import '../../providers/recommendations_provider.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(recommendationsControllerProvider.notifier).loadRecommendations());
  }

  @override
  Widget build(BuildContext context) {
    final recommendationsState = ref.watch(recommendationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        elevation: 0,
      ),
      body: recommendationsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(recommendationsControllerProvider.notifier).loadRecommendations(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (recommendations) {
          final filteredRecommendations = _selectedCategory == 'All'
              ? recommendations
              : recommendations.where((r) => r.category == _selectedCategory).toList();

          return Column(
            children: [
              // Header with skin analysis summary
              const RecommendationHeader(),

              // Category filter
              CategoryFilter(
                selectedCategory: _selectedCategory,
                onCategoryChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              // Products grid
              Expanded(
                child: filteredRecommendations.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No recommendations found'),
                      SizedBox(height: 8),
                      Text(
                        'Try a different category or update your skin analysis',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredRecommendations.length,
                  itemBuilder: (context, index) {
                    final recommendation = filteredRecommendations[index];
                    return ProductCard(recommendation: recommendation);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}