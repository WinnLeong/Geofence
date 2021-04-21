import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static final CameraPosition _kDefaultPosition = CameraPosition(
    target: LatLng(3.109554, 101.638174),
    zoom: 14.4746,
  );

  // void _addDefaultMarker() {
  //   final String markerIdVal = 'marker_current_pos';
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   selectedMarker = markerId;

  //   final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(3.109554, 101.638174),
  //   );

  //   setState(() {
  //     markers[markerId] = marker;
  //   });
  // }

  void _updateMarker(CameraPosition cameraPos) {
    final Marker marker = markers[selectedMarker]!;
    LatLng newMarkerPosition =
        LatLng(cameraPos.target.latitude, cameraPos.target.longitude);

    setState(() {
      markers[selectedMarker!] =
          marker.copyWith(positionParam: newMarkerPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        backdropEnabled: true,
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kDefaultPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
