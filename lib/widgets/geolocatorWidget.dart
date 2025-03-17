import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class GetPositionButton extends StatelessWidget {
  final Function(double, double) returnPosition;

  GetPositionButton({required this.returnPosition});
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return LoadingButton("Тык чтобы найти gps", () async {
      _getCurrentPosition();
    });
  }

  Future<void> _getCurrentPosition() async {
    final permission = await _handlePermission();

    if (permission != LocationPermission.always) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    returnPosition(position.latitude, position.longitude);
  }

  Future<LocationPermission> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.unableToDetermine;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermission.denied;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationPermission.deniedForever;
    }
    return LocationPermission.always;
  }
}
