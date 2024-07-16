import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'helperWidgets/appColors.dart';

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

  Future<void> _saveToFirestore() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).collection('savedMessages').add({
          'prompt': prompt,
          'response': respond,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Başarıyla kaydedildi!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı giriş yapmadı!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıtta sıkıntı yaşandı'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context),
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
          child: Container(
            padding: const EdgeInsets.all(20.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [darkBlue.withOpacity(0.2), cream],
            //   ),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(height: 20),
                ),
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
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Baloo',
                      ),
                      h1: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      h3: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      strong: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      blockquote: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                      code: const TextStyle(
                        color: Colors.yellowAccent,
                        backgroundColor: Colors.black,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if(FirebaseAuth.instance.currentUser != null)...[Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _saveToFirestore,
                      icon: const Icon(
                        Icons.save,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        // TODO: Implement send functionality
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
