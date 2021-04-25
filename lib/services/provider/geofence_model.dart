import 'package:flutter/material.dart';

class GeofenceModel extends ChangeNotifier {
  bool isInsideZone = false;

  void setZoneStatus({required bool isInsideZone}) {
    this.isInsideZone = isInsideZone;

    notifyListeners();
  }
}
