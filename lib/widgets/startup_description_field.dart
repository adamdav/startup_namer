import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/main.dart';

class StartupDescriptionField extends StatelessWidget {
  const StartupDescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Describe your startup idea',
      ),
      onChanged: (value) {
        appState.setDescription(value);
      },
    );
  }
}
