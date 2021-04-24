import 'dart:convert';

import 'package:geofence_test/services/model/zone_model.dart';

class ZoneRepo {
  List<LocationData> getZoneLocations() {
    String zoneLocationsData = '''
  {
    "location": [
        {
            "latitude": 3.1234,
            "longitude": 101.5755,
            "address": "Petronas Ara Damansara"
        },
        {
            "latitude": 3.052591,
            "longitude": 101.6527169,
            "address": "Petronas Alam Sutera"
        },
        {
            "latitude": 3.0270851,
            "longitude": 101.5420121,
            "address": "Petronas Axis shah alam"
        },
        {
            "latitude": 2.806143,
            "longitude": 101.7163006,
            "address": "Petronas Bandar Baru Salak Tinggi"
        },
        {
            "latitude": 5.405330,
            "longitude": 100.412180,
            "address": "Taman Seri Arowana"
        }
    ]
  }
  ''';

    ZoneModel zoneModel = ZoneModel.fromJson(jsonDecode(zoneLocationsData));

    return zoneModel.location!;
  }

  List<WifiData> getWifiNames() {
    String wifiNames = '''
    {
      "wifi_info": [
        {
          "name": "petronas_1221"
        },
        {
          "name": "petronas_2000"
        },
        {
          "name": "petronas_3481"
        },
        {
          "name": "petronas_4055"
        }
      ]
    }
    ''';

    WifiNames wifiName = WifiNames.fromJson(jsonDecode(wifiNames));

    return wifiName.wifiInfo!;
  }
}
