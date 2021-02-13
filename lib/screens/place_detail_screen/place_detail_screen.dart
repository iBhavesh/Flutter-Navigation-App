import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../image_full_screen/image_full_screen.dart';
import '../../providers/great_places.dart';
// import '../../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final int index;
  PlaceDetailScreen(this.index);
  Widget build(BuildContext context) {
    final place = Provider.of<GreatPlaces>(context, listen: false).items[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ImageFullScreen(place.image)));
                },
                child: Image.file(
                  place.image,
                  fit: BoxFit.scaleDown,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
