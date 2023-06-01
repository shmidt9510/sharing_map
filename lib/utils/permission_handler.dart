import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  void checkServiceStatus(
      BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    }

  //below is about gps and location services checks

  static Future<bool> isGpsServiceActive() async {
    final GeolocationResult gps = await Geolocation.isLocationOperational();
    if (!gps.isSuccessful) {
      await Geolocation.enableLocationServices()
          .then((GeolocationResult onValue) async {
        if (onValue.isSuccessful)
          return true;
        else
          return false;
      });
    }
    return true;
  }

  static Future<bool> isLocationServiceAndPermissionsActive() async {
    final GeolocationResult gpsServiceActive =
        await Geolocation.isLocationOperational();
    final gpsPermissionGranted =
        await Permission.locationWhenInUse;

    if (gpsServiceActive.isSuccessful == false || gpsPermissionGranted == false)
      return false;

    return true;
  }
}
