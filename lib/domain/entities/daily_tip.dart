// lib/domain/entities/daily_tip.dart
class DailyTip {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final bool isFeatured;

  const DailyTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.tags,
    required this.createdAt,
    this.isFeatured = false,
  });

  DailyTip copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    List<String>? tags,
    DateTime? createdAt,
    bool? isFeatured,
  }) {
    return DailyTip(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyTip && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}