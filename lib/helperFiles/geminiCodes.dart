import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final apiKey = dotenv.env['API_KEY'];

String petName = "";
String petSpecies = "";
String petBreed = "";
String petAge = "";
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String?> talkWithGemini(String message, String petID) async {
  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
    String finalMessage = "Sen evcil hayvanlar konusunda uzman bir kişisin. $message .Bu soruyu evcil hayvan konusunda kalarak cevapla. Cevabı Türkçe ver ve olası tehlikeler konusunda bilgi ver ve yapılacak adımları söyle.";
    if(petID != ""){
      _getPetData(petID);
      finalMessage += " Bu soruyu, sana bilgilerini vereceğim evcil hayvana göre cevapla: Evcil hayvan ismi: $petName, evcil hayvan türü: $petSpecies, cinsi: $petBreed, yaşı: $petAge. Cevap sırasında hayvanın ismi ile hitab et ve Türkçe cevap ver.";
    }
    final content = Content.text(finalMessage);
    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    print('Error talking with Gemini: $e');
    return null;
  }
}

void _getPetData(String petID) async {
  User? currentUser = _auth.currentUser;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .collection('pets')
      .doc(petID)
      .get();

  if (snapshot.exists) {
    petName = snapshot['petName'];
    petAge = snapshot['petAge'];
    petBreed = snapshot['petBreed'];
    petSpecies = snapshot['petSpecies'];
  }
}