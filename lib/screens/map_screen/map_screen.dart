import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/place.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;
  final PlaceLocation initialLocation;
  MapScreen({
    this.isSelecting = false,
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  LatLng _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: _pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId('1'),
                  position: _pickedLocation,
                ),
              },
      ),
    );
  }
}
