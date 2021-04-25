import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_test/services/provider/geofence_model.dart';

void main() {
  group('Geofence provider tests', () {
    var geofenceModel = GeofenceModel();
    test('Zone status should be true', () {
      bool isInsideZone = true;

      geofenceModel.setZoneStatus(isInsideZone: isInsideZone);
      expect(geofenceModel.isInsideZone, true);
    });

    test('Zone status should be false', () {
      bool isInsideZone = false;

      geofenceModel.setZoneStatus(isInsideZone: isInsideZone);
      expect(geofenceModel.isInsideZone, false);
    });
  });
}
