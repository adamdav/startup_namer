import 'package:http/http.dart' as http;
// import 'package:english_words/english_words.dart';
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
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(237, 151, 85, 1)),
        ),
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
    description = value;
    names = [];
    notifyListeners();
  }

  Future<void> getNext() async {
    if (names.isNotEmpty) {
      current = names.removeAt(0);
      notifyListeners();
      return;
    }

    // Get completion from OpenAI
    try {
      final result = await OpenAi.fetchCompletions(description);
      print("Result: $result");

      final choices = result['choices'];

      final firstChoice = choices[0];
      final text = firstChoice['text'];

      print("Text: $text");

      final _names = text
          .split('\n')
          .map((line) {
            final exp = RegExp(r'([a-zA-Z]+.+)');
            print("Line: $line");
            RegExpMatch? match = exp.firstMatch(line);
            if (match == null) {
              return null;
            }
            print("Match: $match");
            final name = match[0];
            print("Name: $name");
            return name;
          })
          .whereType<String>()
          .toList();

      print("Names: $_names");

      current = _names.removeAt(0);
      names = _names;

      print("Current: $current");

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
