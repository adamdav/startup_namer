import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class StartupNameCard extends StatelessWidget {
  const StartupNameCard({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(name, style: style),
      ),
    );
  }
}
