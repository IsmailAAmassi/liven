import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_providers.dart';
import '../../../l10n/app_localizations.dart';
import 'tabs/home_tab.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.navigationShell});

  static const routePath = HomeTabScreen.routePath;
  static const routeName = 'main';

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navItems = [
      _MainNavItem(icon: Icons.auto_graph, label: l10n.navStatistics),
      _MainNavItem(icon: Icons.event_note, label: l10n.navDailyRecords),
      _MainNavItem(icon: Icons.home_outlined, label: l10n.navHome),
      _MainNavItem(icon: Icons.person_outline, label: l10n.navProfile),
      _MainNavItem(icon: Icons.menu, label: l10n.navMore),
    ];

    final selectedIndex = ref.watch(mainTabIndexProvider);
    final shellIndex = widget.navigationShell.currentIndex;
    if (shellIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mainTabIndexProvider.notifier).setIndex(shellIndex);
      });
    }

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(mainTabIndexProvider.notifier).setIndex(index);
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MainNavItem {
  const _MainNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
