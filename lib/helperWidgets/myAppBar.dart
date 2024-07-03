import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../appColors.dart';

PreferredSizeWidget appBar(){
  return AppBar(
    backgroundColor: pink,
    title: const Row(
      children: [
        SizedBox(width: 20),
        Expanded(
          child: Text(
            "Pawdi",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Pacifico',
            ),
          ),
        ),
      ],
    ),
  );
}