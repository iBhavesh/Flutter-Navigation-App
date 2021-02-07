import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String title, File image) async {
    _items.add(
      Place(
        id: DateTime.now().toString(),
        image: image,
        title: title,
      ),
    );
    notifyListeners();
  }
}
