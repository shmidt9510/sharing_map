import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldKey'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    var _height = context.height * 0.03;
    return Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            unselectedItemColor: MColors.darkGrey,
            selectedItemColor: MColors.green,
            useLegacyColorScheme: true,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            items: [
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/icon_home_pressed.svg',
                    height: _height,
                    width: _height,
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/icon_home_unpressed.svg',
                    height: _height,
                    width: _height,
                  ),
                  label: 'Главная'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/icon_add_unpressed.svg',
                    height: _height,
                    width: _height,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/icons/icon_add.svg',
                    height: _height,
                    width: _height,
                  ),
                  label: 'Добавить'),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      height: _height,
                      width: _height,
                      child: Container(
                        child: Icon(
                            size: 22,
                            Icons.my_library_books,
                            color: MColors.grey1),
                      )),
                  activeIcon: SizedBox(
                      height: _height,
                      width: _height,
                      child: Container(
                        child: Icon(
                          size: 22,
                          Icons.my_library_books,
                          color: MColors.green,
                        ),
                      )),
                  label: 'Моё'),
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: (int index) => _onTap(context, index),
          ),
        ));
  }

  void _onTap(BuildContext context, int index) {
    if (index == 3) {
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
