import 'package:flutter/material.dart';

class SavedChats extends StatefulWidget {
  const SavedChats({super.key});

  @override
  State<SavedChats> createState() => _SavedChatsState();
}

class _SavedChatsState extends State<SavedChats> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Saved chats"),
    );
  }
}
