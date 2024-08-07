import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helperFiles/app_colors.dart';
import '../pet_page.dart';

Widget infoCard(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
  String userID = currentUser!.uid;

  return SizedBox(
    height: 300,
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
              child: Text(
                'Bu kullanıcının bir evcil hayvanı yok',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          final pets = petsSnapshot.data!.docs;

          return Column(
            children: pets.map((petDoc) {
              final pet = petDoc.data() as Map<String, dynamic>;
              final petName = pet['petName'] ?? 'No name';
              final petSituation = getPetSituation(
                (pet['foodList'].last as num).toInt(),
                (pet['weightList'].last as num).toInt(),
                (pet['sleepList'].last as num).toInt(),
                (pet['exerciseList'].last as num).toInt(),
              );
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: brown, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: cream,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            petName,
                            style: const TextStyle(
                              fontFamily: 'Baloo',
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          petSituation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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

String getPetSituation(int food, int weight, int sleep, int exercise) {
  List<int> values = [food, weight, sleep, exercise];
  values.sort();
  int maxValue = values.last;
  int minValue = values[0];
  String minimum = getMinProblem(food, weight, sleep, exercise, minValue);
  String maximum = getMaxProblem(food, weight, sleep, exercise, maxValue);

  if (minimum == maximum) {
    if (minimum == "") {
      return "Her şey yolunda!";
    }
    return minimum;
  }
  if (minimum == "") {
    return maximum;
  }
  if (maximum == "") {
    return minimum;
  }
  if (maximum == "Dikkatli İnceleme Gerekli!" || minimum == "Dikkatli İnceleme Gerekli!") {
    return "Dikkatli İnceleme Gerekli!";
  }
  return "$maximum $minimum";
}

String getMaxProblem(int food, int weight, int sleep, int exercise, int maxValue) {
  String maximum = "";
  if (maxValue > 3) {
    int count = 0;
    if (maxValue == food) {
      count += 1;
      maximum = 'Çok Yemek';
    }
    if (maxValue == weight) {
      count += 1;
      maximum = 'Çok Kilo';
    }
    if (maxValue == exercise) {
      count += 1;
      maximum = "Çok Egzersiz";
    }
    if (maxValue == sleep) {
      count += 1;
      maximum = "Çok Uyku";
    }
    if (count > 1) {
      return "Dikkatli İnceleme Gerekli!";
    }
  }
  return maximum;
}

String getMinProblem(int food, int weight, int sleep, int exercise, int minValue) {
  String minimum = "";
  if (minValue < 3) {
    int count = 0;
    if (minValue == food) {
      count += 1;
      minimum = 'Az Yemek';
    }
    if (minValue == weight) {
      count += 1;
      minimum = 'Az Kilo';
    }
    if (minValue == exercise) {
      count += 1;
      minimum = "Az Egzersiz";
    }
    if (minValue == sleep) {
      count += 1;
      minimum = "Az Uyku";
    }
    if (count > 1) {
      return "Dikkatli İnceleme Gerekli!";
    }
  }
  return minimum;
}
