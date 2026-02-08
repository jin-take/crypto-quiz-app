import 'package:flutter/material.dart';
import '../../data/models/index.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.entry,
    required this.highlight,
  });

  final RankingEntryModel entry;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color =
        highlight ? Theme.of(context).colorScheme.primary : Colors.transparent;
    final textColor =
        highlight ? Theme.of(context).colorScheme.onPrimary : null;
    final deviceLabel = entry.deviceId.length > 6
        ? entry.deviceId.substring(0, 6)
        : entry.deviceId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${entry.rank}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: textColor),
            ),
          ),
          Expanded(
            child: Text(
              deviceLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
            ),
          ),
          Text(
            '${entry.totalScore}pt',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
