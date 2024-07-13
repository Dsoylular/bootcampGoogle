import 'package:bootcamp_google/petPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';

Widget PetCard(BuildContext context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = _auth.currentUser;
  String userID = currentUser!.uid;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const petPage(),
        ),
      );
      print("Directing to pet page");
    },
    child: SizedBox(
      height: 260,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('pets')
              .snapshots(),
          builder: (context, petsSnapshot) {
            if (petsSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!petsSnapshot.hasData || petsSnapshot.data!.docs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(10),
                child: Text('No pets available for this user'),
              );
            }
            final pets = petsSnapshot.data!.docs;

            return Row(
              children: pets.map((petDoc) {
                final pet = petDoc.data() as Map<String, dynamic>;
                final petName = pet['petName'] ?? 'No name';
                final petAge = pet['petAge'] ?? 'No age';
                final petVaccinationStatus = pet['vaccinationStatus'] ?? 'No status';
                final petImage = pet['petImage'] ?? 'https://i.imgur.com/9l1A4OS.jpeg';

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(petImage),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            petName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Age: $petAge',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vaccination: $petVaccinationStatus',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    ),
  );
}
