import 'dart:math';

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

String getPetSituation(int food, int weight, int sleep, int exercise) {
  List<int> values = [food, weight, sleep, exercise];
  values.sort();
  int maxValue = values.last;
  int minValue = values[0];
  String minimum = getMinProblem(food, weight, sleep, exercise, minValue);
  String maximum = getMaxProblem(food, weight, sleep, exercise, maxValue);

  if(minimum == maximum){
    if(minimum == ""){
      return "Her şey yolunda!";
    }
    return minimum;
  }
  print("kjsldkfs");
  if(minimum == ""){
    return maximum;
  }
  if(maximum == ""){
    return minimum;
  }
  if(maximum == "Dikkatli İnceleme Gerekli!" || minimum == "Dikkatli İnceleme Gerekli!") {
    return "Dikkatli İnceleme Gerekli!";
  }
  return "$maximum $minimum";
}

String getMaxProblem(int food, int weight, int sleep, int exercise, int maxValue) {
  String maximum = "";
  if(maxValue > 3) {
    int count = 0;
    if (maxValue == food) {
      count += 1;
      maximum = 'Çok Yemek';
    }
    if (maxValue == weight) {
      count += 1;
      maximum = 'Çok Kilo';
    }
    if(maxValue == exercise){
      count += 1;
      maximum = "Çok Egzersiz";
    }
    if(maxValue == sleep){
      count += 1;
      maximum = "Çok Uyku";
    }
    if(count > 1){
      return "Dikkatli İnceleme Gerekli!";
    }
  }
  return maximum;
}

String getMinProblem(int food, int weight, int sleep, int exercise, int minValue) {
  String minimum = "";
  if(minValue < 3){
    int count = 0;
    if (minValue == food) {
      count += 1;
      minimum = 'Az Yemek';
    }
    if (minValue == weight) {
      count += 1;
      minimum = 'Az Kilo';
    }
    if(minValue == exercise){
      count += 1;
      minimum = "Az Egzersiz";
    }
    if(minValue == sleep){
      count += 1;
      minimum = "Az Uyku";
    }
    if(count > 1){
      return "Dikkatli İnceleme Gerekli!";
    }
  }
  return minimum;
}
