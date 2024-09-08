
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/theme.dart';

class SizeController extends GetxController {
  double _dpi = 0.0;
  double _fullHeight = 0.0;
  double _fullWidth = 0.0;
  String _platform = "";
  Orientation _orientation = Orientation.portrait;

  double get dpi => _dpi;
  double get fullHeight => _fullHeight;
  double get fullWeight => _fullWidth;
  String get platform => _platform;
  Orientation get orientation => _orientation;

  SizeController() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;
    // Size size = WidgetsBinding.instance.window.physicalSize;
    _dpi = view.devicePixelRatio;
    // _platform = view.platformDispatcher.pla
    // _orientation = view.devicePixelRatio;
    _fullWidth = size.width;
    _fullHeight = size.height;
  }

  double GetHeightOfBangs() {
    return _dpi > 2.5 ? 0.19 * _fullHeight : 0.22 * _fullHeight;
  }

  double GetHeightOfItems() {
    return _dpi > 2.5 ? _fullHeight / 6 : _fullHeight / 5;
  }

  double GetHeightOfCategories() {
    return GetHeightOfBangs() * 0.6;
  }

  double GetHeightOfBangIcons() {
    return GetHeightOfBangs() * 0.4;
  }

  TextStyle GetCategoryFont() {
    return _dpi > 2.5
        ? getBigTextStyle()
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(fontSize: 14)
        : getBigTextStyle().copyWith(fontWeight: FontWeight.bold);
  }
}
