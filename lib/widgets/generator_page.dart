import 'package:flutter/material.dart';
import 'package:startup_namer/main.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/widgets/startup_description_field.dart';
import 'package:startup_namer/widgets/startup_name_card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    // var pair = appState.current;
    final names = appState.names;
    final name = appState.current;

    IconData icon;
    if (appState.favorites.contains(name)) {
      icon = Icons.fireplace;
    } else {
      icon = Icons.fireplace_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NameCard(pair: pair),
          // TextField(
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(),
          //     hintText: 'Describe your startup idea',
          //   ),
          // ),
          StartupDescriptionField(),
          if (names.isEmpty) ...[
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Generate'),
            ),
          ],
          if (names.isNotEmpty) ...[
            SizedBox(height: 10),
            StartupNameCard(name: name),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
