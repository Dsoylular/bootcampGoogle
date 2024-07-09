import 'package:bootcamp_google/savedChats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../appColors.dart';

PreferredSizeWidget appBar(BuildContext context){
  return AppBar(
    backgroundColor: pink,
    title: Row(
      children: [
        const SizedBox(width: 20),
        const Expanded(
          child: Text(
            "Pawdi",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Chewy',
            ),
          ),
        ),
        IconButton(
          icon: Icon(
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
            // TODO: Connect to saved chats
          },
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}