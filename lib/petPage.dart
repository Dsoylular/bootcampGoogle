import 'dart:ui';

import 'package:bootcamp_google/appColors.dart';
import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:flutter/material.dart';

class petPage extends StatefulWidget {
  const petPage({super.key});

  @override
  State<petPage> createState() => _petPageState();
}

class _petPageState extends State<petPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Column(
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage('https://i.imgur.com/9l1A4OS.jpeg'),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Fred",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Flexible(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: const Text(
                              "Fred, 12 yaşında, Ragdoll cinsinde bir beyefendidir.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            print("Profile Page");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            fixedSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Profili düzenle",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Distance from the bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Aşı Takip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Durum Analizi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
