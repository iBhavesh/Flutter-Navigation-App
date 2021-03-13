import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../secrets.dart';

class LocationHelper {
  static String getStaticImageUrl(double latitude, double longitude) {
    return 'https://www.mapquestapi.com/staticmap/v5/map?key=$MAP_QUEST_API_KEY&locations=$latitude,$longitude&zoom=16';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url = Uri.parse(
        "https://revgeocode.search.hereapi.com/v1/revgeocode?at=$latitude%2C$longitude&lang=en-US&apiKey=$HERE_API_KEY");
    final response = await http.get(url);
    if (response.body.contains('title')) {
      debugPrint("${response.body}");
      return json.decode(response.body)['items'][0]['address']['label'];
    }
    return '';
  }
}
