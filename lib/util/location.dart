import 'dart:async';

import 'package:geolocator/geolocator.dart';

class Location {
  double distanceInMeters = 0;

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
