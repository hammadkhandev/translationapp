import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;
  OpenAIService(this.apiKey);

  Future<String> translate(String from, String to, String text) async {
    final prompt = 'Translate this from $from to $to:\n\n$text';
    final res = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful translator.'},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 100,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

}
