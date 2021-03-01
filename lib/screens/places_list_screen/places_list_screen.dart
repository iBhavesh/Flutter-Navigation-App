import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_place_screen/add_place_screen.dart';
import '../place_detail_screen/place_detail_screen.dart';
import '../../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  Future<void> _deletePlace(String id, BuildContext context, File image) async {
    try {
      if (await image.exists()) await image.delete();
    } catch (e) {
      debugPrint(e);
    }
    await Provider.of<GreatPlaces>(context, listen: false).deletePlace(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    child: Text(
                      'No Places Yet! Add Some.',
                      style: TextStyle(fontSize: 24),
                    ),
                    builder: (context, places, ch) => places.items.length <= 0
                        ? ch
                        : ListView.builder(
                            itemCount: places.items.length,
                            itemBuilder: (ctx, i) => Dismissible(
                              onDismissed: (direction) {
                                _deletePlace(places.items[i].id, context,
                                    places.items[i].image);
                              },
                              key: ValueKey(places.items[i].id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.delete_forever,
                                  size: 30,
                                ),
                              ),
                              child: buildPlacesListItem(context, i, places),
                            ),
                          ),
                  ),
      ),
    );
  }

  GestureDetector buildPlacesListItem(
      BuildContext context, int i, GreatPlaces places) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(i)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: places.items[i].image != null
                    ? FileImage(
                        places.items[i].image,
                      )
                    : AssetImage('assets/images/placeholder.png'),
              ),
              title: Text(places.items[i].title),
              subtitle: Text(places.items[i].location.address),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
