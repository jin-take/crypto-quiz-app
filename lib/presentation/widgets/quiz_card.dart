import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pointsText,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String pointsText;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Card(
        color: color.withOpacity(0.12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Text(
                    title.isNotEmpty ? title.substring(0, 1) : '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  pointsText,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
