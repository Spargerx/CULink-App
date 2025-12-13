/// Main Shell Screen
///
/// Root screen that handles navigation between different tabs.
/// Contains the floating nav bar and manages page switching.

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/floating_nav_bar.dart';
import 'home_feed_content.dart';
import 'connections_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Scaffold(
      backgroundColor: theme.backgroundLight,
      body: Stack(
        children: [
          // Page content
          IndexedStack(
            index: _currentIndex,
            children: const [
              HomeFeedContent(),
              ConnectionsScreen(),
              _PlaceholderScreen(title: 'Messages'),
              _PlaceholderScreen(title: 'Settings'),
            ],
          ),
          // Floating nav bar
          FloatingNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}

/// Placeholder for unimplemented screens
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      color: theme.backgroundLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: theme.mutedSecondary,
            ),
            SizedBox(height: theme.spacingM),
            Text(
              title,
              style: theme.heading2.copyWith(color: theme.textSecondary),
            ),
            SizedBox(height: theme.spacingS),
            Text(
              'Coming Soon',
              style: theme.bodyMedium.copyWith(color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
