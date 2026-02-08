import 'package:flutter/material.dart';
import '../../utils/extensions.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message ?? context.l10n.errorLoading),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
