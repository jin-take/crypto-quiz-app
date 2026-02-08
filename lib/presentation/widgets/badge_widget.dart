import 'package:flutter/material.dart';
import '../../data/models/index.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.badge,
  });

  final BadgeModel badge;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        child: Text(badge.icon ?? '🏅'),
      ),
      label: Text(badge.name),
    );
  }
}
