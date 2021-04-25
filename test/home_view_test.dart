import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_test/view/home/add_geofence_form.dart';
import 'package:geofence_test/view/home/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geofence_test/services/provider/geofence_model.dart';
import 'package:geofence_test/services/provider/location_model.dart';

Widget createHomeScreen() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeofenceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationModel(),
        ),
      ],
      child: MaterialApp(
        home: Home(),
      ),
    );

void main() {
  group('Home View Widget Tests', () {
    testWidgets('description', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      final googleMap = find.byType(GoogleMap);
      expect(googleMap, findsOneWidget);

      final addGeofenceForm = find.byType(AddGeofenceForm);
      expect(addGeofenceForm, findsOneWidget);
    });
  });
}
