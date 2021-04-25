import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:geofence_test/services/model/zone_model.dart';
import 'package:geofence_test/services/provider/geofence_model.dart';
import 'package:geofence_test/services/provider/location_model.dart';
import 'package:geofence_test/services/repository/zone_repo.dart';
import 'package:geofence_test/util/custom_dialog.dart';
import 'package:geofence_test/util/local_storage.dart';
import 'package:geofence_test/util/notifications.dart';
import 'package:provider/provider.dart';
import 'package:geofence_test/util/location.dart' as customLoc;

class GeofenceTrigger {
  final Notifications notification = Notifications();
  final LocalStorage localStorage = LocalStorage();
  final List<WifiData> locationWifiInfo = ZoneRepo().getWifiNames();
  final customLoc.Location location = customLoc.Location();
  final customDialog = CustomDialog();

  addGeoregion({required List<LocationData> zoneLocations}) {
    int i = 0;
    Geolocation location;

    while (i < zoneLocations.length) {
      location = Geolocation(
          latitude: zoneLocations[i].latitude!,
          longitude: zoneLocations[i].longitude!,
          radius: 500.0,
          id: 'location_$i');

      Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
        print('Georegion added.');
      }).catchError((onError) {
        print('Add georegion error.');
      });

      i += 1;
    }
    // _calculateDistanceToZone();
  }

  addCustomGeoregion(
      {required context,
      required double latitude,
      required double longitude,
      required double radius,
      required String? wifiName}) {
    Geolocation location;

    location = Geolocation(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        id: '$latitude');

    Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
      getZoneStatus(
        context: context,
        wifiName: wifiName,
        entry: 'CUSTOM',
        customLat: latitude,
        customLong: longitude,
      );

      customDialog.show(
        context: context,
        barrierDismissable: true,
        content: Text('Georegion added.'),
        type: DialogType.SUCCESS,
      );
    }).catchError((onError) {
      customDialog.show(
        context: context,
        barrierDismissable: true,
        content: Text('Add Georegion error.'),
        type: DialogType.ERROR,
      );
    });
  }

  listenForLocationChanges({required context, required wifiName}) {
    Geofence.startListeningForLocationChanges();
    Geofence.backgroundLocationUpdated.stream.listen((event) async {
      // check if user is still in the zone
      String? savedWifiName = await localStorage.getWifiName();

      double? zoneLatitude = await localStorage.getLocationLatitude();
      double? zoneLongitude = await localStorage.getLocationLongitude();

      if (zoneLatitude != 0.0 && zoneLongitude != 0.0) {
        await location.getCurrentLocation(context: context);

        double distanceInMeters = await location.getDistance(
          userLatitude:
              Provider.of<LocationModel>(context, listen: false).latitude,
          userLongitude:
              Provider.of<LocationModel>(context, listen: false).longitude,
          destLatitude: zoneLatitude!,
          destLongitude: zoneLongitude!,
        );

        // if wifiName is available
        if (wifiName != null) {
          if (wifiName == savedWifiName || distanceInMeters < 500) {
            Provider.of<GeofenceModel>(context, listen: false)
                .setZoneStatus(isInsideZone: true);

            print('User is in geofence zone.');
          } else {
            Provider.of<GeofenceModel>(context, listen: false)
                .setZoneStatus(isInsideZone: false);

            print('User is not in geofence zone.');

            localStorage.clear();
          }
        } else {
          // determine the zone based on distance if there is no wifi info
          if (distanceInMeters < 500) {
            Provider.of<GeofenceModel>(context, listen: false)
                .setZoneStatus(isInsideZone: true);

            print('User is in geofence zone.');
          } else {
            Provider.of<GeofenceModel>(context, listen: false)
                .setZoneStatus(isInsideZone: false);

            print('User is not in geofence zone.');

            localStorage.clear();
          }
        }
      }
    });
  }

  Future<void> getZoneStatus(
      {required context,
      required wifiName,
      required String entry,
      customLat,
      customLong}) async {
    int i = 0;

    if (entry == 'ENTRY' || entry == 'CUSTOM') {
      await location.getCurrentLocation(context: context);

      localStorage.saveLocationLatitude(
          Provider.of<LocationModel>(context, listen: false).latitude);
      localStorage.saveLocationLongitude(
          Provider.of<LocationModel>(context, listen: false).longitude);
    }

    if (wifiName != null) {
      localStorage.saveWifiName(wifiName!);

      while (i < locationWifiInfo.length) {
        if (wifiName == locationWifiInfo[i].name) {
          Provider.of<GeofenceModel>(context, listen: false)
              .setZoneStatus(isInsideZone: true);

          notification.scheduleNotification(
            title: 'Geofence zone',
            subtitle: 'You are now in geofence zone.',
          );

          break;
        } else {
          Provider.of<GeofenceModel>(context, listen: false)
              .setZoneStatus(isInsideZone: false);

          notification.scheduleNotification(
            title: 'Geofence zone',
            subtitle: 'You are no longer in the geofence zone.',
          );
        }
      }

      i += 1;
    } else {
      if (entry == 'ENTRY') {
        Provider.of<GeofenceModel>(context, listen: false)
            .setZoneStatus(isInsideZone: true);

        notification.scheduleNotification(
          title: 'Geofence zone',
          subtitle: 'You are now in geofence zone.',
        );
      } else if (entry == 'EXIT') {
        Provider.of<GeofenceModel>(context, listen: false)
            .setZoneStatus(isInsideZone: false);

        notification.scheduleNotification(
          title: 'Geofence zone',
          subtitle: 'You are no longer in the geofence zone.',
        );
      } else if (entry == 'CUSTOM') {
        double distanceInMeters = await location.getDistance(
          userLatitude:
              Provider.of<LocationModel>(context, listen: false).latitude,
          userLongitude:
              Provider.of<LocationModel>(context, listen: false).longitude,
          destLatitude: customLat,
          destLongitude: customLong,
        );

        if (distanceInMeters < 500) {
          Provider.of<GeofenceModel>(context, listen: false)
              .setZoneStatus(isInsideZone: true);

          notification.scheduleNotification(
            title: 'Geofence zone',
            subtitle: 'You are now in geofence zone.',
          );
        } else {
          Provider.of<GeofenceModel>(context, listen: false)
              .setZoneStatus(isInsideZone: false);
        }
      }
    }
  }
}
