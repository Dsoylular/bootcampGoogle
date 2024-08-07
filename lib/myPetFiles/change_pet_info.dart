import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helperFiles/app_colors.dart';
import '../helperFiles/my_app_bar.dart';

class ChangePetScreen extends StatefulWidget {
  final String petSpecies;
  final String petGender;
  final String petBreed;
  final String petName;
  final String petAge;
  final String petID;

  const ChangePetScreen({super.key,
    required this.petSpecies,
    required this.petGender,
    required this.petBreed,
    required this.petName,
    required this.petAge,
    required this.petID,
  });

  @override
  State<ChangePetScreen> createState() => _ChangePetScreenState();
}

class _ChangePetScreenState extends State<ChangePetScreen> {
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String get petSpecies => widget.petSpecies;
  String get petGender => widget.petGender;
  String get petBreed => widget.petBreed;
  String get petName => widget.petName;
  String get petAge => widget.petAge;
  String get petID => widget.petID;

  @override
  Widget build(BuildContext context) {
    log("change_pet_info");
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
            const SizedBox(height: 40),
            customTextField(_nameController, petName, 30),
            const SizedBox(height: 20),
            customTextField(_speciesController, petSpecies, 40),
            const SizedBox(height: 20.0),
            customTextField(_breedController, petBreed, 40),
            const SizedBox(height: 20.0),
            customTextField(_ageController, petAge, 3),
            const SizedBox(height: 20.0),
            customTextField(_genderController, petGender, 5),
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

                final newSpecies = _speciesController.text.trim();
                final newGender = _genderController.text.trim();
                final newBreed = _breedController.text.trim();
                final newAgeText = _ageController.text.trim();
                final newName = _nameController.text.trim();

                if (newAgeText.isNotEmpty && (int.tryParse(newAgeText) == null || int.parse(newAgeText) < 0 || int.parse(newAgeText) > 100)) {
                  _showErrorDialog("Yaş 0 ile 100 arasında bir değer olmalıdır.");
                  return;
                }
                if (newGender.isNotEmpty && newGender != 'Erkek' && newGender != 'Dişi') {
                  _showErrorDialog("Cinsiyet yalnızca 'Erkek' veya 'Dişi' olabilir.");
                  return;
                }

                final updatedData = <String, dynamic>{};
                if (newName.isNotEmpty && newName != existingData['petName']) {
                  updatedData['petName'] = newName;
                }
                if (newSpecies.isNotEmpty && newSpecies != existingData['petSpecies']) {
                  updatedData['petSpecies'] = newSpecies;
                }
                if (newBreed.isNotEmpty && newBreed != existingData['petBreed']) {
                  updatedData['petBreed'] = newBreed;
                }
                if (newAgeText.isNotEmpty && newAgeText != existingData['petAge']) {
                  updatedData['petAge'] = newAgeText;
                }
                if (newGender.isNotEmpty && newGender != existingData['petGender']) {
                  updatedData['petGender'] = newGender;
                }

                updatedData['timestamp'] = Timestamp.now();
                updatedData['vaccinationDates'] = existingData['vaccinationDates'] ?? [];
                updatedData['foodList'] = existingData['foodList'] ?? [3, 3, 3, 3, 3, 3, 3];
                updatedData['sleepList'] = existingData['sleepList'] ?? [3, 3, 3, 3, 3, 3, 3];
                updatedData['weightList'] = existingData['weightList'] ?? [3, 3, 3, 3, 3, 3, 3];
                updatedData['exerciseList'] = existingData['exerciseList'] ?? [3, 3, 3, 3, 3, 3, 3];

                if (updatedData.isNotEmpty) {
                  await petDocRef.update(updatedData);
                }
                _navTwicePop();
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final bool? confirmDelete = await _showDeleteConfirmationDialog();
                if (confirmDelete == true) {
                  await _deletePet();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Evcil Hayvanı Sil",
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

  Future<void> _deletePet() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser == null) return;

    final petDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('pets')
        .doc(petID);

    await petDocRef.delete();
    _navTwicePop();
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              "Silme Onayı",
            style: TextStyle(
                fontFamily: 'Baloo'
            ),
          ),
          content: const Text(
              "Evcil hayvanı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
            style: TextStyle(
                fontFamily: 'Baloo'
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                  "Hayır",
                style: TextStyle(
                    fontFamily: 'Baloo',
                  color: darkBlue
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                  "Evet",
                style: TextStyle(
                    fontFamily: 'Baloo',
                  color: darkBlue
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _navTwicePop() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              "Hata",
            style: TextStyle(
              fontFamily: 'Baloo'
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                  "Tamam",
                style: TextStyle(
                    fontFamily: 'Baloo'
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Widget customTextField(TextEditingController controller, String hintText, int maxLength) {
  controller.text = hintText;
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: brown, width: 2.0),
      ),
      filled: true,
      fillColor: cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    maxLength: maxLength,
    keyboardType: maxLength == 3 ? TextInputType.number : TextInputType.text,
  );
}
