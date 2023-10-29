import 'package:flutter/material.dart';
import "package:sharing_map/navigator/tab.dart";
import 'package:sharing_map/navigator/bottom_navigator.dart';
import 'package:sharing_map/navigator/tab_navigator.dart';

// Наша главная страница будет содержать состояние
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // GlobalKey будет хранить уникальный ключ,
//   // по которому мы сможем получить доступ
//   // к виджетам, которые уже находяться в иерархии
//   // NavigatorState - состояние Navigator виджета
//   // final _navigatorKeys = {
//   //   TabItem.HOME: GlobalKey<NavigatorState>(),
//   //   TabItem.FAVORITE: GlobalKey<NavigatorState>(),
//   //   TabItem.ADD: GlobalKey<NavigatorState>(),
//   //   TabItem.MESSAGES: GlobalKey<NavigatorState>(),
//   // };

//   // текущий выбранный элемент
//   var _currentTab = TabItem.HOME;

//   // выбор элемента меню
//   void _selectTab(TabItem tabItem) {
//     setState(() => _currentTab = tabItem);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // WillPopScope переопределяет поведения
//     // нажатия кнопки Back
//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentTab != TabItem.HOME) {
//           if (_currentTab == TabItem.ADD) {
//             _selectTab(TabItem.HOME);
//           } else {
//             _selectTab(TabItem.HOME);
//           }
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         body: Stack(children: <Widget>[
//           _buildOffstageNavigator(TabItem.HOME),
//           _buildOffstageNavigator(TabItem.FAVORITE),
//           _buildOffstageNavigator(TabItem.ADD),
//           _buildOffstageNavigator(TabItem.MESSAGES),
//         ]),
//         // MyBottomNavigation мы создадим позже
//         bottomNavigationBar: MyBottomNavigation(
//           currentTab: _currentTab,
//           onSelectTab: _selectTab,
//         ),
//       ),
//     );
//   }

//   // Создание одного из экранов - посты, альбомы или задания
//   Widget _buildOffstageNavigator(TabItem tabItem) {
//     return Offstage(
//       // Offstage работает следующим образом:
//       // если это не текущий выбранный элемент
//       // в нижнем меню, то мы его скрываем
//       offstage: _currentTab != tabItem,
//       // TabNavigator мы создадим позже
//       child: TabNavigator(
//         navigatorKey: _navigatorKeys[tabItem]!,
//         tabItem: tabItem,
//       ),
//     );
//   }
// }
