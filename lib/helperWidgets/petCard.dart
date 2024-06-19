import 'package:flutter/material.dart';

Widget PetCard() {
  return GestureDetector(
    onTap: () {
      print("Directing to pet page"); // TODO: Connect to page
    },
    child: SizedBox(
      height: 215,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 165,
                height: 215,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/kediIcon.png'), // TODO: Connect with backend
                    ),
                    Text(
                      'Fred', // TODO: Connect with backend
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Age: 12', // TODO: Connect with backend
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Vaccine: Done', // TODO: Connect with backend
                      style: TextStyle(
                        fontSize: 16,
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