import 'package:flutter/material.dart';
import 'package:sharing_map/navigator/tab.dart';

import 'package:sharing_map/items/item_list_page.dart';
import 'package:sharing_map/items/add_new_item_page.dart';

class TabNavigator extends StatelessWidget {
  // TabNavigator принимает:
  // navigatorKey - уникальный ключ для NavigatorState
  // tabItem - текущий пункт меню
  TabNavigator({required this.navigatorKey, required this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    // наконец-то мы дошли до этого момента
    // здесь мы присваиваем navigatorKey
    // только, что созданному Navigator'у
    // navigatorKey, как уже было отмечено является ключом,
    // по которому мы получаем доступ к состоянию
    // Navigator'a, вот и все!
    return Navigator(
      key: navigatorKey,
      // Navigator имеет параметр initialRoute,
      // который указывает начальную страницу и является
      // всего лишь строкой.
      // Мы не будем вдаваться в подробности, но отметим,
      // что по умолчанию initialRoute равен /
      // initialRoute: "/",

      // Navigator может сам построить наши страницы или
      // мы можем переопределить метод onGenerateRoute
      onGenerateRoute: (routeSettings) {
        // сначала определяем текущую страницу
        Widget currentPage = ItemListPage();
        if (tabItem == TabItem.HOME) {
          // пока мы будем использовать PonyListPage
          currentPage = ItemListPage();
        } else if (tabItem == TabItem.FAVORITE) {
          currentPage = ItemListPage();
        } else if (tabItem == TabItem.ADD) {
          currentPage = AddNewItemPage(
              // key: navigatorKey,
              );
        } else {
          currentPage = ItemListPage();
        }
        // строим Route (страница или экран)
        return MaterialPageRoute(
          builder: (context) => currentPage,
        );
      },
    );
  }
}
