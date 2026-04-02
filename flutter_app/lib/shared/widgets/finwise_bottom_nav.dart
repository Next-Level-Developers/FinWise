import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_routes.dart';

class FinWiseBottomNav extends StatelessWidget {
  const FinWiseBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const List<_NavItem> _tabs = <_NavItem>[
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long),
    _NavItem(icon: Icons.pie_chart_outline, activeIcon: Icons.pie_chart),
    _NavItem(icon: Icons.flag_outlined, activeIcon: Icons.flag_rounded),
    _NavItem(icon: Icons.school_outlined, activeIcon: Icons.school_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ..._tabs.asMap().entries.map((MapEntry<int, _NavItem> entry) {
            final int index = entry.key;
            final _NavItem tab = entry.value;
            final bool isActive = currentIndex == index;
            return _IconTab(
              icon: isActive ? tab.activeIcon : tab.icon,
              isActive: isActive,
              onTap: () => _onTabTapped(context, index),
            );
          }),
        ],
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    const List<String> routes = <String>[
      AppRoutes.dashboard,
      AppRoutes.transactions,
      AppRoutes.budget,
      AppRoutes.goals,
      AppRoutes.learn,
    ];
    context.go(routes[index]);
  }
}

class _IconTab extends StatelessWidget {
  const _IconTab({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 2,
              margin: const EdgeInsets.only(bottom: 4),
              color: isActive ? AppColors.primary : Colors.transparent,
            ),
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.navActive : AppColors.navInactive,
            ),
            const SizedBox(height: 2),
            Text(
              _labelForIcon(icon),
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.navActive : AppColors.navInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelForIcon(IconData iconData) {
    if (iconData == Icons.home_outlined || iconData == Icons.home_rounded) {
      return 'Home';
    }
    if (iconData == Icons.receipt_long_outlined ||
        iconData == Icons.receipt_long) {
      return 'Transactions';
    }
    if (iconData == Icons.pie_chart_outline || iconData == Icons.pie_chart) {
      return 'Budget';
    }
    if (iconData == Icons.flag_outlined || iconData == Icons.flag_rounded) {
      return 'Goals';
    }
    return 'Learn';
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.activeIcon});

  final IconData icon;
  final IconData activeIcon;
}
