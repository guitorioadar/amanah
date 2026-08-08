import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Bottom-nav scaffold hosting the four primary tabs, with the global
/// "+ Expense" FAB. Uses [StatefulNavigationShell] so each tab keeps its own
/// navigation stack and scroll/search state (required by the designs).
class ShellScreen extends StatelessWidget {
  const ShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _tabs = <_TabSpec>[
    _TabSpec('Home', 'House'),
    _TabSpec('Audits', 'ClipboardText'),
    _TabSpec('Expenses', 'Calculator'),
    _TabSpec('Profile', 'User'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, // wired in M-expenses
        backgroundColor: AppColors.bgBrandBold,
        foregroundColor: AppColors.brandOnPrimary,
        icon: const Icon(Icons.add),
        label: Text('Expense', style: AppText.buttonM.copyWith(
          color: AppColors.brandOnPrimary,
        ),),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        backgroundColor: AppColors.bgDefault,
        indicatorColor: AppColors.bgInfo,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: _NavIcon(tab.icon, selected: false),
              selectedIcon: _NavIcon(tab.icon, selected: true),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon);
  final String label;
  final String icon;
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.name, {required this.selected});
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final weight = selected ? 'fill' : 'line';
    return SvgPicture.asset(
      'assets/icons/$weight/$name.svg',
      width: 26,
      colorFilter: ColorFilter.mode(
        selected ? AppColors.iconBrand : AppColors.iconSubtle,
        BlendMode.srcIn,
      ),
    );
  }
}

/// Temporary placeholder used by every tab until its feature lands.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: AppText.headingM)),
      body: Center(
        child: Text('$title — coming soon', style: AppText.bodyMRegular),
      ),
    );
  }
}
