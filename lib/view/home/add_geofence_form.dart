import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'geofence_trigger.dart';

class AddGeofenceForm extends StatefulWidget {
  final addMarker;
  final String? wifiName;

  AddGeofenceForm({this.addMarker, this.wifiName});
  @override
  _AddGeofenceFormState createState() => _AddGeofenceFormState();
}

class _AddGeofenceFormState extends State<AddGeofenceForm> {
  final _formKey = GlobalKey<FormState>();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final radiusController = TextEditingController();

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      double latitude = double.tryParse(latitudeController.text)!;
      double longitude = double.tryParse(longitudeController.text)!;
      double radius = double.tryParse(radiusController.text)!;

      GeofenceTrigger().addCustomGeoregion(
        context: context,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        wifiName: widget.wifiName,
      );

      widget.addMarker(latitude: latitude, longitude: longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 45,
      backdropEnabled: true,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      panel: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Slide up to add Geofence',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(hintText: 'Latitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: latitudeController,
              validator: (String? value) {
                if (value!.isEmpty &&
                    latitudeController.text.isEmpty &&
                    longitudeController.text.isEmpty) {
                  return 'Latitude is required.';
                } else if (double.tryParse(latitudeController.text)! < -90 ||
                    double.tryParse(latitudeController.text)! > 90) {
                  return 'Please enter a valid latitude.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(hintText: 'Longitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: longitudeController,
              validator: (String? value) {
                if (value!.isEmpty && latitudeController.text.isEmpty) {
                  return 'Longitude is required.';
                } else if (double.tryParse(latitudeController.text)! < -180 ||
                    double.tryParse(latitudeController.text)! > 180) {
                  return 'Please enter a valid longitude.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(hintText: 'Radius'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: radiusController,
              validator: (String? value) {
                if (value!.isEmpty && radiusController.text.isEmpty) {
                  return 'Radius is required.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Add Georegion'),
            ),
          ],
        ),
      ),
    );
  }
}
