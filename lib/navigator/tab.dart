import 'package:flutter/material.dart';

// будет хранить основную информацию
// об элементах меню
class MyTab {
  final String name;
  final MaterialColor color;
  final IconData icon;

  const MyTab({required this.name, required this.color, required this.icon});
}

// пригодиться для определения
// выбранного элемента меню
// у нас будет три пункта меню и три страницы:
// посты, альбомы и задания
enum TabItem { HOME, FAVORITE, ADD, MESSAGES, PROFILE }
