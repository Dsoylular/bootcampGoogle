import 'package:bootcamp_google/askMeFiles/savedChats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';

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
            print("saved chats");
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