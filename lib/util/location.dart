import 'dart:async';

import 'package:geolocator/geolocator.dart';

class Location {
  double latitude = 0;
  double longitude = 0;
  double distanceInMeters = 0;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    latitude = position.latitude;
    longitude = position.longitude;
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
    double distance;

    distanceInMeters = Geolocator.distanceBetween(
        userLatitude, userLongitude, destLatitude, destLongitude);

    distance = distanceInMeters;

    return distance;
  }
}
