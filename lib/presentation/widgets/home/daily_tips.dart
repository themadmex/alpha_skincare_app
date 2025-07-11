// lib/presentation/widgets/home/daily_tips.dart
import 'package:flutter/material.dart';

class DailyTips extends StatelessWidget {
  const DailyTips({super.key});

  static const List<Map<String, dynamic>> _tips = [
    {
      'title': 'Stay Hydrated',
      'description': 'Drink at least 8 glasses of water daily for healthy, glowing skin.',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'title': 'Use Sunscreen',
      'description': 'Apply SPF 30+ daily, even on cloudy days to protect from UV damage.',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
    },
    {
      'title': 'Get Quality Sleep',
      'description': 'Aim for 7-9 hours of sleep for natural skin repair and regeneration.',
      'icon': Icons.bedtime,
      'color': Colors.purple,
    },
    {
      'title': 'Gentle Cleansing',
      'description': 'Use a mild cleanser twice daily to remove dirt without stripping oils.',
      'icon': Icons.face,
      'color': Colors.green,
    },
    {
      'title': 'Moisturize Daily',
      'description': 'Apply moisturizer to damp skin to lock in hydration effectively.',
      'icon': Icons.spa,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final tipIndex = today.day % _tips.length;
    final dailyTip = _tips[tipIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber[700],
              ),
              const SizedBox(width: 8),
              Text(
                'Daily Tip',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (dailyTip['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (dailyTip['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    dailyTip['icon'] as IconData,
                    color: dailyTip['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dailyTip['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dailyTip['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}