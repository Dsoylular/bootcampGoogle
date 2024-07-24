import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../helperFiles/app_colors.dart';

class SavedChats extends StatefulWidget {
  const SavedChats({super.key});

  @override
  State<SavedChats> createState() => _SavedChatsState();
}

class _SavedChatsState extends State<SavedChats> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    log("saved_chats");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Kaydedilmiş Sohbetler",
          style: TextStyle(
            fontFamily: 'Baloo',
            color: Colors.white,
          ),
        ),
        backgroundColor: pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('savedMessages')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No saved chats found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              String respond = data['response'] ?? '';
              String prompt = data['prompt'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: cream,
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      'Prompt: $prompt',
                      style: const TextStyle(
                          fontFamily: 'Baloo'
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MarkdownBody(
                        data: respond,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteSavedChat(document.id);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _deleteSavedChat(String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('savedMessages')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat deleted'), backgroundColor: Colors.green),
      );
      log("Chat deleted");
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete chat: $error'), backgroundColor: Colors.red),
      );
      log("Deletion of chat failed");
    });
  }
}
