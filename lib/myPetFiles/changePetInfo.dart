import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helperFiles/app_colors.dart';
import '../helperFiles/my_app_bar.dart';

class ChangePetScreen extends StatefulWidget {
  final String petID;
  const ChangePetScreen({super.key, required this.petID});

  @override
  State<ChangePetScreen> createState() => _ChangePetScreenState();
}

class _ChangePetScreenState extends State<ChangePetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String get petID => widget.petID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 300,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Evcil Hayvanın Bilgilerini Düzenle!",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pacifico',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'İsim',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _speciesController,
              decoration: InputDecoration(
                hintText: 'Tür (Kedi, Köpek, Balık...)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _breedController,
              decoration: InputDecoration(
                hintText: 'Cins (Labrador, Siyam, Balık...)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: 'Yaş',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(
                hintText: 'Cinsiyet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                User? currentUser = auth.currentUser;

                if (currentUser == null) return;

                final petDocRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('pets')
                    .doc(petID);

                final petDocSnapshot = await petDocRef.get();

                if (!petDocSnapshot.exists) return;

                final existingData = petDocSnapshot.data() ?? {};

                final updatedData = {
                  'petName': _nameController.text.isNotEmpty ? _nameController.text : existingData['petName'],
                  'petSpecies': _speciesController.text.isNotEmpty ? _speciesController.text : existingData['petSpecies'],
                  'petBreed': _breedController.text.isNotEmpty ? _breedController.text : existingData['petBreed'],
                  'petAge': _ageController.text.isNotEmpty ? _ageController.text : existingData['petAge'],
                  'petGender': _genderController.text.isNotEmpty ? _genderController.text : existingData['petGender'],
                  'timestamp': Timestamp.now(),
                  'vaccinationDates': existingData['vaccinationDates'] ?? [],
                  'foodList': existingData['foodList'] ?? [3, 3, 3, 3, 3, 3, 3],
                  'sleepList': existingData['sleepList'] ?? [3, 3, 3, 3, 3, 3, 3],
                  'weightList': existingData['weightList'] ?? [3, 3, 3, 3, 3, 3, 3],
                  'exerciseList': existingData['exerciseList'] ?? [3, 3, 3, 3, 3, 3, 3],
                };

                await petDocRef.update(updatedData);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Güncelle",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Baloo',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
