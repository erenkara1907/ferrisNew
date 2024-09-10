import 'package:ferrisfwt/feature/bottom_nav/widget/bottom_nav_builder_widget.dart';
import 'package:ferrisfwt/product/context/bottom_nav_context.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin BottomNavigationBarMixin on State<BottomNavBuilder> {
  final BottomNavContext tabContext = BottomNavContext();

  List<BottomNavigationBarItem> get bottomNavigationBarItemList {
    return tabContext.items.map((icon) {
      return buildNavigationBarItem(
        icon: icon,
        index: tabContext.items.indexOf(icon),
      );
    }).toList();
  }

  BottomNavigationBarItem buildNavigationBarItem({
    required Widget icon,
    required int index,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.surface,
      icon: Padding(
        padding: context.paddingTopLow,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: index == tabContext.index
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: context.paddingAllLow,
            child: icon,
          ),
        ),
      ),
      label: '',
    );
  }

  Future<void> onTabTapped(int index, BuildContext context) async {
    setState(() {
      tabContext.setIndex(index);
    });
    if (index == 0) {
      GoRouter.of(context).go(
        '/home_page',
      );
    } else if (index == 1) {
      GoRouter.of(context).go('/history_page');
    } else if (index == 2) {
      GoRouter.of(context).go('/profile_page');
    }
  }
}
