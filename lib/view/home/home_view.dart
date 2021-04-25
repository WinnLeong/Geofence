import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:geofence_test/services/provider/geofence_model.dart';
import 'package:geofence_test/services/provider/location_model.dart';
import 'package:geofence_test/view/home/geofence_trigger.dart';
import 'package:geofence_test/services/model/zone_model.dart';
import 'package:geofence_test/services/repository/zone_repo.dart';
import 'package:geofence_test/util/loading_model.dart';
import 'package:geofence_test/util/local_storage.dart';
import 'package:geofence_test/util/location.dart' as customLoc;
import 'package:geofence_test/util/wifi_info.dart';
import 'package:geofence_test/view/home/location_permission.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:provider/provider.dart';

import 'add_geofence_form.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage localStorage = LocalStorage();

  // repo
  final List<LocationData> zoneLocations = ZoneRepo().getZoneLocations();

  // flutter_wifi_info
  final GetWifiInfo _getWifiInfo = GetWifiInfo();
  LocationAuthorizationStatus? locationAuthorizationStatus;
  String? wifiName;

  final customLoc.Location location = customLoc.Location();

  bool _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static final CameraPosition _kDefaultPosition = CameraPosition(
    target: LatLng(3.109554, 101.638174),
    zoom: 12,
  );

  final TextStyle statusTextStyle = TextStyle(
    fontSize: 32,
  );

  @override
  void initState() {
    super.initState();
    _initHomeState();
  }

  _initHomeState() async {
    await RequestLocation()
        .getLocationPermission(moveCamera: moveCamera, context: context);

    await GetWifiInfo().getWifiAuthorization();

    wifiName = await _getWifiInfo.getWifiName();
    print('listen for location changes $wifiName');

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      GeofenceTrigger().getZoneStatus(
        context: context,
        wifiName: wifiName,
        entry: 'ENTRY',
      );
    });

    Geofence.startListening(GeolocationEvent.exit, (exit) {
      GeofenceTrigger()
          .getZoneStatus(context: context, wifiName: wifiName, entry: 'EXIT');
    });

    GeofenceTrigger().listenForLocationChanges(
      context: context,
      wifiName: wifiName,
    );

    setState(() {});

    GeofenceTrigger().addGeoregion(
      zoneLocations: zoneLocations,
    );
  }

  moveCamera() async {
    CameraPosition _currentCameraPosition = CameraPosition(
        target: LatLng(context.read<LocationModel>().latitude,
            context.read<LocationModel>().longitude),
        zoom: 18);

    final GoogleMapController controller = await _controller.future;
    controller
        .moveCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }

  void addMarker({required double latitude, required double longitude}) {
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
  }

  @override
  Widget build(BuildContext context) {
    bool isInsideZone = context.watch<GeofenceModel>().isInsideZone;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                  child: isInsideZone
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
            AddGeofenceForm(),
            LoadingModel(
              isVisible: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
