import 'package:flutter/material.dart';
import 'package:sharing_map/navigator/tab.dart';

// создаем три пункта меню
// const обозначает, что tabs является
// постоянной ссылкой и мы больше
// ничего не сможем ей присвоить,
// иначе говоря, она определена во время компиляции
const Map<TabItem, MyTab> tabs = {
  TabItem.HOME: const MyTab(name: "Home", color: Colors.red, icon: Icons.home),
  TabItem.FAVORITE:
      const MyTab(name: "Favorite", color: Colors.blue, icon: Icons.favorite),
  TabItem.ADD: const MyTab(name: "Add", color: Colors.green, icon: Icons.add),
  TabItem.MESSAGES:
      const MyTab(name: "Message", color: Colors.green, icon: Icons.message),
  TabItem.PROFILE:
      const MyTab(name: "Profile", color: Colors.green, icon: Icons.person)
};

class MyBottomNavigation extends StatelessWidget {
  // MyBottomNavigation принимает функцию onSelectTab
  // и текущую выбранную вкладку
  MyBottomNavigation({required this.currentTab, required this.onSelectTab});

  final TabItem currentTab;
  // ValueChanged<TabItem> - функциональный тип,
  // то есть onSelectTab является ссылкой на функцию,
  // которая принимает TabItem объект
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    // Используем встроенный виджет BottomNavigationBar для
    // реализации нижнего меню
    return BottomNavigationBar(
        selectedItemColor: _colorTabMatching(currentTab),
        selectedFontSize: 13,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab.index,
        // пункты меню
        items: [
          _buildItem(TabItem.HOME),
          _buildItem(TabItem.FAVORITE),
          _buildItem(TabItem.ADD),
          _buildItem(TabItem.MESSAGES),
          _buildItem(TabItem.PROFILE),
        ],
        // обработка нажатия на пункт меню
        // здесь мы делаем вызов функции onSelectTab,
        // которую мы получили через конструктор
        onTap: (index) => onSelectTab(TabItem.values[index]));
  }

  // построение пункта меню
  BottomNavigationBarItem _buildItem(TabItem item) {
    return BottomNavigationBarItem(
      // указываем иконку
      icon: Icon(
        _iconTabMatching(item),
        color: _colorTabMatching(item),
      ),
      // указываем метку или название
      label: tabs[item]?.name,
    );
  }

  // получаем иконку элемента
  IconData? _iconTabMatching(TabItem item) => tabs[item]?.icon;

  // получаем цвет элемента
  MaterialColor? _colorTabMatching(TabItem item) {
    return currentTab == item ? tabs[item]?.color : Colors.grey;
  }
}
