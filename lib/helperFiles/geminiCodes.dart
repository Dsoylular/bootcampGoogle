import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final apiKey = dotenv.env['API_KEY'];

Future<String?> talkWithGemini(String message) async {
  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
    String finalMessage = "Sen evcil hayvanlar konusunda uzman bir kişisin. $message .Bu soruyu evcil hayvan konusunda kalarak cevapla. Cevabı Türkçe ver ve olası tehlikeler konusunda bilgi ver ve yapılacak adımları söyle.";
    final content = Content.text(finalMessage);
    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    print('Error talking with Gemini: $e');
    return null;
  }
}
