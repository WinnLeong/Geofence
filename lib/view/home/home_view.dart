import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:geofence_test/services/repository/zone_repo.dart';
import 'package:geofence_test/util/custom_dialog.dart';
import 'package:geofence_test/util/loading_model.dart';
import 'package:geofence_test/util/location.dart';
import 'package:geofence_test/util/notifications.dart';
import 'package:geofence_test/util/wifi_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Notifications notification = Notifications();

  // repo
  final zoneLocations = ZoneRepo().getZoneLocations();
  final locationWifiInfo = ZoneRepo().getWifiNames();

  // flutter_wifi_info
  final GetWifiInfo deviceWifiInfo = GetWifiInfo();

  final Location location = Location();
  final CustomDialog customDialog = CustomDialog();

  bool _isInsideZone = false;
  bool _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static final CameraPosition _kDefaultPosition = CameraPosition(
    target: LatLng(3.109554, 101.638174),
    zoom: 12,
  );

  final statusTextStyle = TextStyle(
    fontSize: 32,
  );

  // double locationLat = 0.0;
  // double locationLong = 0.0;

  // double distanceInMeters = 0.0;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _addGeoregion();

    // Geofence.getCurrentLocation().then((Coordinate? coordinate) {
    //   print(
    //       "Your latitude is ${coordinate!.latitude} and longitude ${coordinate.longitude}");
    // });

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      _getZoneStatus('entry');
    });

    Geofence.startListening(GeolocationEvent.exit, (exit) {
      _getZoneStatus('exit');
    });

    // _listenForLocationChanges();
  }

  Future<void> _getZoneStatus(entry) async {
    String? wifiName = await deviceWifiInfo.getWifiName();
    int i = 0;

    /* if (wifiName != null) {
      while (i < locationWifiInfo.length) {
        if (wifiName == locationWifiInfo[i].name) {
          setState(() {
            _isInsideZone = true;
          });

          notification.scheduleNotification(
            title: 'Geofence zone',
            subtitle: 'You are now in geofence zone.',
          );

          break;
        } else {
          setState(() {
            _isInsideZone = false;
          });

          notification.scheduleNotification(
            title: 'Geofence zone',
            subtitle: 'You are no longer in the geofence zone.',
          );
        }
      }

      i += 1;
    } else { */
    if (entry == 'entry') {
      setState(() {
        _isInsideZone = true;
      });

      notification.scheduleNotification(
        title: 'Geofence zone',
        subtitle: 'You are now in geofence zone.',
      );
    } else {
      setState(() {
        _isInsideZone = false;
      });

      notification.scheduleNotification(
        title: 'Geofence zone',
        subtitle: 'You are no longer in the geofence zone.',
      );
    }
    // }
  }

  // _listenForLocationChanges() {
  //   Geofence.startListeningForLocationChanges();
  //   Geofence.backgroundLocationUpdated.stream.listen((event) {
  //     // check if user is still in the zone
  //     _getZoneStatus();
  //   });
  // }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    LocationPermission permission = await location.checkLocationPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await location.getCurrentLocation();

      // _addMarker(latitude: location.latitude, longitude: location.longitude);
      _moveCamera();
      // _addGeoregion();
    } else {
      // if default location permission window doesn't show up
      customDialog.show(
        context: context,
        barrierDismissable: false,
        title: Text('Location Permission'),
        content: Text(
            'Location permission is required for geofencing. Would you like to enable location?'),
        customActions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();

              setState(() {});
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        type: DialogType.GENERAL,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  _addGeoregion() {
    int i = 0;
    Geolocation location;

    while (i < zoneLocations.length) {
      location = Geolocation(
          latitude: zoneLocations[i].latitude!,
          longitude: zoneLocations[i].longitude!,
          radius: 1000.0,
          id: "location_$i");

      Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
        print("Georegion added.");
      }).catchError((onError) {
        print("Add georegion error.");
      });

      i += 1;
    }

    // _calculateDistanceToZone();
  }

  // Future<void> _calculateDistanceToZone() async {
  // for (int i = 0; i < zoneLocations.length; i += 1) {
  //   double distanceInKm = await location.getDistance(
  //     userLatitude: location.latitude,
  //     userLongitude: location.longitude,
  //     destLatitude: zoneLocations[i].latitude!,
  //     destLongitude: zoneLocations[i].longitude!,
  //   );

  //   print(distanceInKm);

  //   // if (distanceInKm <= 0.15) {
  //   //   setState(() {
  //   //     _isInsideZone = true;
  //   //   });
  //   // } else {
  //   //   setState(() {
  //   //     _isInsideZone = false;
  //   //   });
  //   // }

  //   // zoneRepo[i].distance = distanceInKm;
  // }
  // }

  /* void _addMarker({required double latitude, required double longitude}) {
    final String markerIdVal = 'mark_current_pos';
    final MarkerId markerId = MarkerId(markerIdVal);
    selectedMarker = markerId;

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
    );

    setState(() {
      markers[markerId] = marker;
    });
  } */

  void _moveCamera() async {
    CameraPosition _currentCameraPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 18);

    final GoogleMapController controller = await _controller.future;
    controller
        .moveCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));

    // _updateMarker(_currentCameraPosition);
  }

  // void _updateMarker(CameraPosition cameraPos) {
  //   final Marker marker = markers[selectedMarker]!;
  //   LatLng newMarkerPosition =
  //       LatLng(cameraPos.target.latitude, cameraPos.target.longitude);

  //   setState(() {
  //     markers[selectedMarker!] =
  //         marker.copyWith(positionParam: newMarkerPosition);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            markers: Set<Marker>.of(markers.values),
            initialCameraPosition: _kDefaultPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            trafficEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 0,
            child: SafeArea(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 80,
                alignment: Alignment.center,
                child: _isInsideZone
                    ? Text(
                        'Inside of Zone',
                        style: statusTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'Outside of Zone',
                        style: statusTextStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
          /* SlidingUpPanel(
            backdropEnabled: true,
            panel: Center(
              child: Text("Nearest location to display here"),
            ),
          ), */
          LoadingModel(
            isVisible: _isLoading,
          ),
        ],
      ),
      // Test notification
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   notification.scheduleNotification(
      //       title: 'Geofence zone',
      //       subtitle: 'You have now entered geofence zone.');
      // }),
    );
  }
}
