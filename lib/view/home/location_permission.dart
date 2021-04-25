import 'package:flutter/material.dart';
import 'package:geofence_test/util/custom_dialog.dart';
import 'package:geofence_test/util/location.dart';
import 'package:geolocator/geolocator.dart';

class RequestLocation {
  final Location location = Location();

  Future<LocationPermission> getLocationPermission(
      {required moveCamera, required BuildContext context}) async {
    LocationPermission permission = await location.checkLocationPermission();
    final CustomDialog customDialog = CustomDialog();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await location.getCurrentLocation(context: context);

      // Geofence.getCurrentLocation().then((Coordinate? coordinate) {
      //   print(
      //       "Your latitude is ${coordinate!.latitude} and longitude ${coordinate.longitude}");
      // });

      moveCamera();
    } else {
      // if default location permission window doesn't show up
      customDialog.show(
        context: context,
        barrierDismissable: false,
        title: Text('Location Permission'),
        content: Text(
            'Location permission is required for geofencing. Would you like to enable location?'),
        customActions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();

              permission = await location.checkLocationPermission();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              permission = LocationPermission.denied;
              Navigator.pop(context);
            },
          ),
        ],
        type: DialogType.GENERAL,
      );
    }

    return permission;
  }
}
