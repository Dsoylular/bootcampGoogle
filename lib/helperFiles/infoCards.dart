import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';
import '../myPetFiles/petPage.dart';

Widget InfoCard(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
  String userID = currentUser!.uid;

  return SizedBox(
    height: 215,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('pets')
            .snapshots(),
        builder: (context, petsSnapshot) {
          if (petsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!petsSnapshot.hasData || petsSnapshot.data!.docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(10),
              child: Text('No pets available for this user'),
            );
          }
          final pets = petsSnapshot.data!.docs;

          return Column(
            children: pets.map((petDoc) {
              final pet = petDoc.data() as Map<String, dynamic>;
              final petName = pet['petName'] ?? 'No name';
              final petSituation = pet['petSituation'] ?? 'Uykulu'; // Example situation
              final petID = petDoc.id; // Get the document ID of the pet

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetPage(
                        petID: petID, // Pass the pet ID to PetPage
                      ),
                    ),
                  );
                  print("Directing to pet page");
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: 325,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: brown, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          petName,
                          style: const TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          petSituation,
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
  );
}
