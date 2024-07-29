import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../helperFiles/app_colors.dart';
import '../helperFiles/markdown_style_sheet.dart';

class RespondPage extends StatefulWidget {
  final String respond;
  final String prompt;

  const RespondPage({required this.respond, required this.prompt, super.key});

  @override
  State<RespondPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<RespondPage> {
  String get respond => widget.respond;
  String get prompt => widget.prompt;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    log("respond_page");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Cevap Detayları',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Baloo'
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: pink,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkBlue.withOpacity(0.2), cream],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: brown),
                ),
                child: MarkdownBody(
                  data: respond,
                  styleSheet: markdownStyleSheet,
                ),
              ),
              const SizedBox(height: 20),
              if (FirebaseAuth.instance.currentUser != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: _saveToFirestore,
                    icon: const Icon(
                      Icons.save,
                      size: 20,
                    ),
                    label: const Text(
                        'Kaydet',
                      style: TextStyle(
                        fontFamily: 'Baloo'
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveToFirestore() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).collection('savedMessages').add({
          'prompt': prompt,
          'response': respond,
        });
        _showSnackBar('Başarıyla kaydedildi', Colors.green);
        log("Respond is successfully saved");
      } else {
        _showSnackBar('Kullanıcı giriş yapmadı!', Colors.red);
        log("The user is not signed in!");
      }
    } catch (e) {
      _showSnackBar("Kayıtta sıkıntı yaşandı!", Colors.red);
      log("Error saving in Firestore!");
    }
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        backgroundColor: color,
      ),
    );
  }
}
