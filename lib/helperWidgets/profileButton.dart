import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:flutter/material.dart';

Widget profileButton(String name, String explanation, Icon icon, int type){
  return ElevatedButton(
    onPressed: () {
      print("Profile Page");
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: type == 0 ? darkBlue : pink,
      fixedSize: const Size(300, 50),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                explanation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}