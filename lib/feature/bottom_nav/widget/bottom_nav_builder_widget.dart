import 'package:ferrisfwt/feature/bottom_nav/mixin/bottom_nav_mixin.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:flutter/material.dart';

class BottomNavBuilder extends StatefulWidget {
  const BottomNavBuilder({super.key});

  @override
  State<BottomNavBuilder> createState() => _BottomNavBuilderState();
}

class _BottomNavBuilderState extends State<BottomNavBuilder>
    with BottomNavigationBarMixin {
  @override
  Widget build(BuildContext context) {
    final tabContext = ProductStateItems.bottomNavBuilder;
    return ListenableBuilder(
      listenable: tabContext,
      builder: (_, __) => BottomNavigationBar(
        backgroundColor: context.theme.colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: bottomNavigationBarItemList,
        currentIndex: tabContext.index,
        onTap: (index) {
          tabContext.setIndex(index);
          onTabTapped(index, context);
        },
      ),
    );
  }
}
