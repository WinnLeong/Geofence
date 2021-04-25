import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_test/services/provider/location_model.dart';

void main() {
  group('Location provider tests', () {
    var locationModel = LocationModel();
    test('Coordinates should be updated accordingly', () {
      double latitude = 3.1234;
      double longitude = 101.5766;

      locationModel.setLocationCoordinates(
          latitude: latitude, longitude: longitude);
      expect(locationModel.latitude, 3.1234);
      expect(locationModel.longitude, 101.5766);
    });
  });
}
