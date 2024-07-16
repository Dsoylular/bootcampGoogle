import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';
import '../petPage.dart';

Widget InfoCard(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
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
                return const CircularProgressIndicator();
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
                  final petSituation = pet['petSituation'] ?? 'Uykulu'; // TODO: Connect with backend

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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '   $petName: $petSituation',
                            style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Baloo',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
      ),


          // children: List.generate(3, (index) {
          //   return Padding(
          //     padding: const EdgeInsets.only(bottom: 20),
          //     child: Container(
          //       width: 325,
          //       height: 50,
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: brown, width: 2),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: const Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          //         children: [
          //           Text(
          //             '   Fred: Uykulu zZz', // TODO: Connect with backend
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 18,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
      ),
    ),
  );
}
