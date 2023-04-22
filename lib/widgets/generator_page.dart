import 'package:flutter/material.dart';
import 'package:startup_namer/main.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/widgets/startup_description_field.dart';
import 'package:startup_namer/widgets/startup_name_card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final names = appState.names;
    final name = appState.current;

    IconData icon;
    if (appState.favorites.contains(name)) {
      icon = Icons.fireplace;
    } else {
      icon = Icons.fireplace_outlined;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StartupDescriptionField(),
        ),
        if (names.isEmpty) ...[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Generate'),
            ),
          ),
        ],
        if (names.isNotEmpty) ...[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StartupNameCard(name: name),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
