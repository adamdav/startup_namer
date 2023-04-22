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
    if (names.length > 1) {
      current = names.removeAt(0);
      notifyListeners();
      return;
    }

    if (names.length == 1) {
      current = names.removeAt(0);
      try {
        names = await fetchNameIdeas(description);
        notifyListeners();
      } catch (e) {
        print(e);
      }
      notifyListeners();
      return;
    }

    // Get name ideas from OpenAI
    try {
      names = await fetchNameIdeas(description);
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
  final result = await OpenAi.fetchCompletions(description);
  final choices = result['choices'];
  final firstChoice = choices[0];
  final text = firstChoice['text'];

  final names = text
      .split('\n')
      .map((line) {
        final exp = RegExp(r'([a-zA-Z]+.+)');
        RegExpMatch? match = exp.firstMatch(line);
        if (match == null) {
          return null;
        }
        final name = match[0];
        return name;
      })
      .whereType<String>()
      .toList();

  return names;
}
