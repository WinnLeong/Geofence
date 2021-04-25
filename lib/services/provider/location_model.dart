import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;

  void setLocationCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    this.latitude = latitude;
    this.longitude = longitude;
  }
}
