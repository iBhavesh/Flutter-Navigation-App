import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/DBHelper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String title, File image) async {
    final place = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
    );
    _items.add(place);
    notifyListeners();
    return DBHelper.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelper.getData('user_places');
    data.forEach((element) {
      _items.add(
        Place(
          id: element['id'],
          title: element['title'],
          image: File(element['image']),
        ),
      );
    });
    notifyListeners();
  }
}
