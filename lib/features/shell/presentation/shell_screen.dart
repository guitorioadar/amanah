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
    _TabSpec('Profile', 'User', image: 'assets/images/2.0x/avatar.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: const _ExpenseButton(),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgDefault,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.borderDefault)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) => navigationShell.goBranch(
              i,
              initialLocation: i == navigationShell.currentIndex,
            ),
            backgroundColor: AppColors.bgDefault,
            surfaceTintColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            elevation: 0,
            indicatorColor: AppColors.bgInfo,
            destinations: [
              for (final tab in _tabs)
                NavigationDestination(
                  icon: _NavIcon(tab.icon, image: tab.image, selected: false),
                  selectedIcon:
                      _NavIcon(tab.icon, image: tab.image, selected: true),
                  label: tab.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon, {this.image});
  final String label;
  final String icon;

  /// Optional raster used instead of the SVG glyph (e.g. the Profile avatar).
  final String? image;
}

/// Global "+ Expense" action. Fixed 98×36 pill per design (smaller than a
/// standard extended FAB, so it's built from [Material] directly).
class _ExpenseButton extends StatelessWidget {
  const _ExpenseButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgBrandBold,
      elevation: 3,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {}, // wired in M-expenses
        child: SizedBox(
          width: 98,
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 18, color: AppColors.brandOnPrimary),
              const SizedBox(width: 4),
              Text(
                'Expense',
                style: AppText.buttonS.copyWith(
                  color: AppColors.brandOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.name, {required this.selected, this.image});
  final String name;
  final bool selected;
  final String? image;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.asset(image!, width: 22, height: 22);
    }
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
