import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:startup_namer/env/env.dart';

class OpenAi {
  static Future<Map<String, dynamic>> fetchCompletions(
      String description) async {
    final uri = Uri.parse('https://api.openai.com/v1/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Env.OPENAI_API_KEY}'
    };

    final body = {
      'model': 'text-davinci-003',
      'prompt':
          'Product description: $description\nSeed words:\nProduct names:\n',
      'temperature': 0.8,
      'max_tokens': 60,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0
    };

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    return jsonDecode(response.body);
  }
}
