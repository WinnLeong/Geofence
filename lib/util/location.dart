import 'dart:async';

import 'package:geofence_test/services/provider/location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Location {
  Future<void> getCurrentLocation({required context}) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    Provider.of<LocationModel>(context, listen: false).setLocationCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<LocationPermission> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    return permission;
  }

  Future<double> getDistance({
    required double userLatitude,
    required double userLongitude,
    required double destLatitude,
    required double destLongitude,
  }) async {
    double distanceInMeters = Geolocator.distanceBetween(
        userLatitude, userLongitude, destLatitude, destLongitude);

    return distanceInMeters;
  }
}
