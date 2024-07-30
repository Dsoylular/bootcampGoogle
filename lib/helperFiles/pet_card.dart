import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../myPetFiles/new_pet.dart';
import '../myPetFiles/pet_page.dart';
import 'app_colors.dart';

Widget petCard(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
  String userID = currentUser!.uid;

  return SizedBox(
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
            return const Center(child: CircularProgressIndicator());
          }
          if (!petsSnapshot.hasData || petsSnapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton(
                    onPressed: () async{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewPet(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cream
                    ),
                    child: Text(
                      "Evcil hayvanınız yok, eklemek için tıklayın!",
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        color: darkBlue
                      ),
                    )
                ),
              ),
            );
          }
          final pets = petsSnapshot.data!.docs;

          return Row(
            children: pets.map((petDoc) {
              final pet = petDoc.data() as Map<String, dynamic>;
              final petName = pet['petName'] ?? 'No name';
              final petAge = pet['petAge'] ?? 'No age';
              final petVacDates = pet['vaccinationDates'] ?? [];
              final petImage = pet['petImage'] ?? 'assets/images/kediIcon.png';
              final isVaccinationTracking = pet['isVaccinationTracking'] ?? false;
              final petID = petDoc.id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetPage(
                        petID: petID,
                      ),
                    ),
                  );
                  log("Directing to pet page");
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: cream,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/kediIcon.png',
                                image: petImage,
                                fit: BoxFit.cover,
                                width: 160,
                                height: 160,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/kediIcon.png',
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 160,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            petName,
                            style: const TextStyle(
                              fontFamily: 'Baloo',
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Yaş: $petAge',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (!isVaccinationTracking)
                            ? ''
                            : (petVacDates.isNotEmpty && petVacDates[0].toDate().isAfter(DateTime.now()))
                                ? 'Aşı: ${DateFormat('dd/MM/yyyy').format((petVacDates[0].toDate()))}'
                                : 'Yakında aşı yok',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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
