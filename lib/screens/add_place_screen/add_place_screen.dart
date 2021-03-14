import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../widgets/image_input.dart';
import '../../providers/great_places.dart';
import '../widgets/location_input.dart';
import '../../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  bool _addingPlace = false;

  void _selectImage(File image) {
    _selectedImage = image;
  }

  void _selectLocation(double lat, double lng) {
    _selectedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  Future<void> addPlace() async {
    if (_titleController.text.length < 5) {
      showSnackBar(
          context, 'Length of the text should be atleast 5 characters long');
      return;
    }
    if (_selectedImage == null) {
      showSnackBar(context, 'Image not selected');
      return;
    }
    if (_selectedLocation == null) {
      showSnackBar(context, 'Location not choosen');
      return;
    }
    setState(() {
      _addingPlace = true;
    });
    await Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _selectedImage!, _selectedLocation!);
    setState(() {
      _addingPlace = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Place'),
      ),
      body: Column(
        crossAxisAlignment: _addingPlace
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  SizedBox(height: 10),
                  ImageInput(_selectImage),
                  SizedBox(height: 10),
                  LocationInput(_selectLocation),
                ],
              ),
            ),
          ),
          _addingPlace
              ? CircularProgressIndicator()
              : RaisedButton.icon(
                  label: Text('Add'),
                  icon: Icon(Icons.add),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  elevation: 0,
                  onPressed: addPlace,
                )
        ],
      ),
    );
  }
}
