// lib/presentation/widgets/progress/timeline_view.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/scan_result.dart';

class TimelineView extends StatelessWidget {
  final List<ScanResult> scanResults;

  const TimelineView({super.key, required this.scanResults});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        final result = scanResults[index];
        final isFirst = index == 0;
        final isLast = index == scanResults.length - 1;

        return _buildTimelineItem(result, isFirst, isLast, context);
      },
    );
  }

  Widget _buildTimelineItem(ScanResult result, bool isFirst, bool isLast, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    // Timeline indicator
    Column(
    children: [
    Container(
    width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isFirst ? Theme.of(context).primaryColor : Colors.grey,
        shape: BoxShape.circle,
      ),
    ),
    if (!isLast)
    Container(
    width: 2,
    height: 80,
    color: Colors.grey.withOpacity(0.3),
    ),
    ],
    ),
    const SizedBox(width: 16),

    // Content
    Expanded(
    child: Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Header
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    _formatDate(result.createdAt),
    style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
    color: _getScoreColor(result.overallScore).withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
    '${result.overallScore}/100',
    style: TextStyle(
    color: _getScoreColor(result.overallScore),
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 12),

    // Metrics grid
    GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    childAspectRatio: 2.5,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    children: result.analysisResults.entries.map((entry) {
    final score = (entry.value * 100).round();
    return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Colors.grey.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),