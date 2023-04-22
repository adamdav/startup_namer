import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/main.dart';

class StartupNameCard extends StatelessWidget {
  const StartupNameCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final name = appState.current;
    final favorites = appState.favorites;
    return Card(
        color: theme.colorScheme.primary,
        child: Stack(children: [
          // Show the favorite icon if the name is a favorite
          if (favorites.contains(name))
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.fireplace,
                    color: theme.colorScheme.onPrimary, size: 20),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(name,
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center),
              ),
            ],
          )
        ]));
  }
}
