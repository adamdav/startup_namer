import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/main.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var name in appState.favorites)
          ListTile(
            leading: Icon(Icons.fireplace),
            title: Text(name),
          ),
      ],
    );
  }
}
