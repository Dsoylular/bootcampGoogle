import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyAUZ69b1Hr-7_gIfKh-HlfvMX8P1Gk_QF0";

String petSpecies = "";
String petBreed = "";
String petName = "";
String petAge = "";
List<dynamic> exerciseList = [];
List<dynamic> weightList = [];
List<dynamic> sleepList = [];
List<dynamic> foodList = [];

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String?> talkWithGemini(String message, String petID) async {
  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    String finalMessage = "Sen evcil hayvanlar konusunda uzman bir kişisin. $message. Bu soruyu evcil hayvan konusunda kalarak cevapla. Cevabı Türkçe ver ve olası tehlikeler konusunda bilgi ver ve yapılacak adımları söyle.";
    if(petID != ""){
      await getPetData(petID);
      finalMessage += " Bu soruyu, sana bilgilerini vereceğim evcil hayvana göre cevapla: Evcil hayvan ismi: $petName, evcil hayvan türü: $petSpecies, cinsi: $petBreed, yaşı: $petAge. Cevap sırasında hayvandan bahsedeceğin zaman direkt ismini kullan ve Türkçe cevap ver.";
    }
    final content = Content.text(finalMessage);
    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    log('Error talking with Gemini: $e');
    return null;
  }
}

Future<String?> getDetailedInfo(String petID) async {
  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    await getPetData(petID);
    String finalMessage = "Sen evcil hayvanlar konusunda uzman bir kişisin. "
        "Bu soruyu evcil hayvan konusunda kalarak cevapla. Cevabı Türkçe ver "
        "ve olası tehlikeler konusunda bilgi ver ve yapılacak adımları söyle. "
        "Şimdi sana cevap vereceğin evcil hayvanın bilgilerini vereceğim:"
        "Bu soruyu, sana bilgilerini vereceğim evcil hayvana göre cevapla: "
        "Evcil hayvan ismi: $petName, "
        "evcil hayvan türü: $petSpecies, "
        "cinsi: $petBreed, "
        "yaşı: $petAge "
        "Son 7 günkü yemek yeme durumu (3 normal, 5 çok, 1 az anlamına geliyor. Listenin son elemanı en güncel veridir.): $foodList "
        "Son 7 günkü uyku durumu (3 normal, 5 çok, 1 az anlamına geliyor. Listenin son elemanı en güncel veridir.): $sleepList "
        "Son 7 günkü kilo durumu (3 normal, 5 çok, 1 az anlamına geliyor. Listenin son elemanı en güncel veridir.): $weightList "
        "Son 7 günkü egzersiz durumu (3 normal, 5 çok, 1 az anlamına geliyor. Listenin son elemanı en güncel veridir.): $exerciseList "
        "Cevap sırasında hayvandan bahsedeceğin zamana direkt ismini kullan ve Türkçe cevap ver.";
    final content = Content.text(finalMessage);
    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    log('Error talking with Gemini: $e');
    return null;
  }
}

Future<void> getPetData(String petID) async {
  User? currentUser = _auth.currentUser;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .collection('pets')
      .doc(petID)
      .get();

  if (snapshot.exists) {
    petName = snapshot['petName'];
    petAge = snapshot['petAge'].toString();
    petBreed = snapshot['petBreed'];
    petSpecies = snapshot['petSpecies'];
    foodList = snapshot['foodList'];
    exerciseList = snapshot['exerciseList'];
    weightList = snapshot['weightList'];
    sleepList = snapshot['sleepList'];
  }
}
