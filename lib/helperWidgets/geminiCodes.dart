import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final apiKey = dotenv.env['API_KEY'];

Future<String?> talkWithGemini(String message) async {
  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
    String finalMessage = "$message answer this question in the context of pets. Don't provide any info if else";
    final content = Content.text(finalMessage);
    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    print('Error talking with Gemini: $e');
    return null;
  }
}
