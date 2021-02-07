import 'package:flutter/material.dart';

import './screens/places_list_screen/places_list_screen.dart';
import './screens/add_place_screen/add_place_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext _) => PlacesListScreen(),
  AddPlaceScreen.routeName: (BuildContext _) => AddPlaceScreen(),
};
