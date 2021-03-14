import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../map_screen/map_screen.dart';
import '../../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function selectLocation;
  LocationInput(this.selectLocation);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  bool _selectingLocation = false;

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _selectingLocation = true;
    });
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionStatus;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      location.requestService();
      if (!_serviceEnabled) {
        _selectingLocation = false;
        return;
      }
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus == PermissionStatus.denied) {
        _selectingLocation = false;
        return;
      }
    }
    _locationData = await location.getLocation();

    final imageUrl = LocationHelper.getStaticImageUrl(
        _locationData.latitude!, _locationData.longitude!);
    setState(() {
      _previewImageUrl = imageUrl;
      _selectingLocation = false;
    });
    widget.selectLocation(_locationData.latitude, _locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
        fullscreenDialog: true,
      ),
    );

    if (selectedLocation == null) return;
    widget.selectLocation(
        selectedLocation.latitude, selectedLocation.longitude);
    final imageUrl = LocationHelper.getStaticImageUrl(
        selectedLocation.latitude, selectedLocation.longitude);
    setState(() {
      _previewImageUrl = imageUrl;
      _selectingLocation = false;
    });
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
          child: _previewImageUrl == null && !_selectingLocation
              ? Text('No Location Added')
              : _selectingLocation
                  ? CircularProgressIndicator()
                  : Image.network(_previewImageUrl!,
                      fit: BoxFit.cover, width: double.infinity,
                      loadingBuilder: (_, child, progress) {
                      return progress == null
                          ? child
                          : LinearProgressIndicator();
                    }),
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
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
