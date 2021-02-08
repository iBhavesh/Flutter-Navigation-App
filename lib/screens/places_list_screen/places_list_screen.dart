import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_place_screen/add_place_screen.dart';
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
                            itemBuilder: (ctx, i) => Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(
                                        places.items[i].image,
                                      ),
                                    ),
                                    title: Text(places.items[i].title),
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
      ),
    );
  }
}
