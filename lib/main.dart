import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/services/open_ai.dart';
import 'package:startup_namer/widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Startup Namer',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromRGBO(237, 151, 85, 1),
              primaryContainer: Color.fromRGBO(237, 151, 85, .1),
              secondary: Color.fromRGBO(237, 151, 85, 1),
              tertiary: Color.fromRGBO(237, 151, 85, 1),
              background: Color.fromRGBO(255, 255, 255, 1),
            ),
            navigationRailTheme: NavigationRailThemeData()
                .copyWith(indicatorColor: Color.fromRGBO(237, 151, 85, 1))),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var description = '';
  var names = <String>[];
  var current = '';

  void setDescription(String value) {
    // Set the description
    description = value;

    // Clear the list of names whenever the description changes
    names = [];

    notifyListeners();
  }

  Future<void> getNext() async {
    // If there is more than one name in the list, use them and do not fetch more
    if (names.length > 1) {
      // Use the first name from the current state
      current = names.removeAt(0);
      notifyListeners();
      return;
    }

    // If there is exactly one name in the list, use it and fetch more
    if (names.length == 1) {
      // Use the name from the current state
      current = names.removeAt(0);
      notifyListeners();

      try {
        // Fetch more name ideas
        names = await fetchNameIdeas(description);
        notifyListeners();
      } catch (e) {
        print(e);
      }

      return;
    }

    // If there are no names in the list, fetch more
    try {
      // Fetch name ideas
      names = await fetchNameIdeas(description);

      // Use the first name if fetch was successful
      current = names.removeAt(0);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  var favorites = <String>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

Future<List<String>> fetchNameIdeas(String description) async {
  // Fetch name ideas from OpenAI
  final result = await OpenAi.fetchCompletions(description);
  final choices = result['choices'];
  final firstChoice = choices[0];
  final text = firstChoice['text'];

  // Parse the name ideas from the raw text
  final names = text
      .split('\n')
      .map((line) {
        // Parse the name idea from the line of text
        final exp = RegExp(r'([a-zA-Z]+.+)');
        RegExpMatch? match = exp.firstMatch(line);
        if (match == null) {
          return null;
        }
        final name = match[0];
        return name;
      })
      .whereType<String>() // Filter out nulls
      .toList();

  return names;
}
