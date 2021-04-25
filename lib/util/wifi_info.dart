import 'dart:io';

import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GetWifiInfo {
  final WifiInfo wifiInfo = WifiInfo();
  String? wifiBSSID;
  String? wifiName;

  Future<void> getWifiAuthorization() async {
    if (Platform.isIOS) {
      LocationAuthorizationStatus status =
          await wifiInfo.getLocationServiceAuthorization();

      if (status == LocationAuthorizationStatus.notDetermined) {
        status = await wifiInfo.requestLocationServiceAuthorization();
      }
      if (status == LocationAuthorizationStatus.authorizedAlways ||
          status == LocationAuthorizationStatus.authorizedWhenInUse) {
        wifiName = await wifiInfo.getWifiName();
        print('Wifi name is $wifiName');
      } else {
        wifiName = await wifiInfo.getWifiName();
        print('Wifi name is $wifiName');
      }
    } else if (Platform.isAndroid) {
      var status = await Permission.location.status;
      if (status.isDenied || status.isRestricted) {
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
        }
      }
      wifiName = await wifiInfo.getWifiName();
      print('Wifi name is $wifiName');
    }
  }

  Future<String?> getWifiName() async {
    wifiName = await wifiInfo.getWifiName();

    return wifiName;
  }

  // Future<String> getWifiSSID() async {
  //   wifiBSSID = await wifiInfo.getWifiBSSID();

  //   return wifiBSSID;
  // }
}
