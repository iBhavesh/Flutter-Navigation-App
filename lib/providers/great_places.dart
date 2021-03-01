import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    final address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);

    final updatedLocation = PlaceLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address);

    final place = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedLocation,
    );
    _items.add(place);
    notifyListeners();

    // debugPrint(
    //     '${place.location.latitude},${place.location.longitude},${place.location.address}');

    return DBHelper.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'loc_lat': place.location.latitude,
      'loc_lng': place.location.longitude,
      'address': place.location.address,
    });
  }

  Future<void> deletePlace(String id) async {
    await DBHelper.deletePlace('user_places', id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelper.getData('user_places');
    _items = [];
    if (data == null) return;
    data.forEach((element) async {
      File image = File(element['image']);
      if (!image.existsSync()) image = null;
      _items.add(
        Place(
          id: element['id'],
          title: element['title'],
          image: image,
          location: PlaceLocation(
            latitude: element['loc_lat'],
            longitude: element['loc_lng'],
            address: element['address'],
          ),
        ),
      );
    });
    notifyListeners();
  }
}
