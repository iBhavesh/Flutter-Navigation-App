import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_place_screen/add_place_screen.dart';
import '../place_detail_screen/place_detail_screen.dart';
import '../../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
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
                    child: Text('No Places Yet! Add Some.'),
                    builder: (context, places, ch) => places.items.length <= 0
                        ? ch
                        : ListView.builder(
                            itemCount: places.items.length,
                            itemBuilder: (ctx, i) => Dismissible(
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
                backgroundImage: FileImage(
                  places.items[i].image,
                ),
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
