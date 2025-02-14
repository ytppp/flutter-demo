import 'package:flutter/material.dart';

class MenuData {
  final String label; // 标签
  final IconData icon; // 图标数据

  const MenuData({
    required this.label,
    required this.icon
  });
}

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<MenuData> meuns;
  final ValueChanged<int>? onItemTap;

  const AppBottomBar({
    super.key,
    this.onItemTap,
    this.currentIndex = 0,
    required this.meuns
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onItemTap,
        currentIndex: currentIndex,
        elevation: 3,
        type: BottomNavigationBarType.fixed,
        iconSize: 22,
        selectedItemColor: Theme.of(context).primaryColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: meuns.map(_buildItemByMenuMeta).toList()
    );
  }

  BottomNavigationBarItem _buildItemByMenuMeta(MenuData menu) {
    return BottomNavigationBarItem(
        icon: Icon(menu.icon),
        label: menu.label
    );
  }
}