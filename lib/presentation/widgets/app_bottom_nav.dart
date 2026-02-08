import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/extensions.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/ranking');
            break;
          case 2:
            context.go('/profile');
            break;
          case 3:
            context.go('/settings');
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: context.l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: context.l10n.rankingTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: context.l10n.profileTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: context.l10n.settingsTitle,
        ),
      ],
    );
  }
}
