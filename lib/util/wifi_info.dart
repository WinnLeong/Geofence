import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class GetWifiInfo {
  var wifiBSSID;
  var wifiName;

  Future<dynamic> getWifiName() async {
    wifiName = await WifiInfo().getWifiName();

    return wifiName;
  }

  Future<dynamic> getWifiSSID() async {
    wifiBSSID = await WifiInfo().getWifiBSSID();

    return wifiBSSID;
  }
}
