import 'dart:developer';

import 'package:bootcamp_google/askMeFiles/saved_chats.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

PreferredSizeWidget appBar(BuildContext context){
  return AppBar(
    backgroundColor: pink,
    iconTheme: const IconThemeData(
      color: Colors.white, 
    ),
    title: Row(
      children: [
        const SizedBox(width: 20),
        const Expanded(
          child: Text(
            "Pawdi",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.collections_bookmark,
            color: Colors.white,
          ),
          onPressed: () {
            log("Directing to saved chats");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SavedChats(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}