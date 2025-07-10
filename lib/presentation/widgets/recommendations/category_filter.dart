// lib/presentation/widgets/recommendations/category_filter.dart
import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  static const List<String> categories = [
    'All',
    'Cleanser',
    'Moisturizer',
    'Serum',
    'Sunscreen',
    'Treatment',
    'Exfoliant',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategoryChanged(category);
                }
              },
              backgroundColor: Colors.grey.withOpacity(0.1),
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}