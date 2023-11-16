import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('SomeTestFuckingScaffold'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    var _color = context.theme.iconTheme.color;
    var _index = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: _color),
        selectedItemColor: _color,
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.safety_check),
              icon: Icon(Icons.home, color: _color),
              label: 'Главная'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, color: _color), label: 'Добавить'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded),
              label: 'Профиль'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  // Widget getFavoriteIcon(context, selected) {
  //   Icon()
  //   if (selected) {
  //     return Icon(Icons.home);
  //   } else {
  //     return Icon(Icons.home_work_outlined);
  //   }
  // }

  // Widget getHomeIcon(context, selected) {;
  //   return ImageIcon(SvgPicture.asset('', color:MColors.dashAmber, semanticsLabel: 'label'));
  //   // if (selected) {
  //   //   return Icon(Icons.search.);
  //   // } else {
  //   //   return Icon(Icons.home_work_outlined);
  //   // }
  // }

  // Widget getMessages(context, selected) {
  //   if (selected) {
  //     return Icon(Icons.home);
  //   } else {
  //     return Icon(Icons.home_work_outlined);
  //   }
  // }
}
