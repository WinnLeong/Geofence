import 'preferences.dart';

class LocalStorage {
  static const String kWifiName = 'WIFI_NAME';
  static const String kLocLat = 'LOCATION_LATITUDE';
  static const String kLocLong = 'LOCATION_LONGITUDE';

  Future<bool> saveWifiName(String wifiName) {
    return Preference.setString(kWifiName, wifiName);
  }

  Future<String?> getWifiName() async {
    return Preference.getString(kWifiName, def: '');
  }

  Future<bool> saveLocationLatitude(double locationLatitude) {
    return Preference.setDouble(kLocLat, locationLatitude);
  }

  Future<double?> getLocationLatitude() async {
    return Preference.getDouble(kLocLat, def: 0.0);
  }

  Future<bool> saveLocationLongitude(double locationLongitude) {
    return Preference.setDouble(kLocLong, locationLongitude);
  }

  Future<double?> getLocationLongitude() async {
    return Preference.getDouble(kLocLong, def: 0.0);
  }

  Future<void> clear() async {
    await Preference.removeAll();
  }
}
