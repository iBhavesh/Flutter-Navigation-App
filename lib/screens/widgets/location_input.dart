import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../secrets.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionStatus;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus == PermissionStatus.denied) return;
    }

    _locationData = await location.getLocation();
    _previewImageUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=${_locationData.latitude},${_locationData.longitude}&zoom=12&size=400x400&markers=color:red%7Clabel:C%7C${_locationData.latitude},${_locationData.longitude}&key=$API_KEY_GOOGLE';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text('No Location Added')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (_, child, progress) {
                    return progress == null
                        ? child
                        : LinearProgressIndicator(
                            value: progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes,
                          );
                  },
                ),
        ),
        Row(
          children: [
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
