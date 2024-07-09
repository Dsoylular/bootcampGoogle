import 'package:flutter/material.dart';

import 'appColors.dart';
import '../petPage.dart';

Widget InfoCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const petPage(),
        ),
      );
      print("Directing to pet page"); // TODO: Connect to page
    },
    child: SizedBox(
      height: 215,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: 325,
                height: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: brown, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      '   Fred: Sleepy zZz', // TODO: Connect with backend
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}
