import 'dart:developer';
import 'package:bootcamp_google/helperFiles/my_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helperFiles/app_colors.dart';

class NewPet extends StatefulWidget {
  const NewPet({super.key});

  @override
  State<NewPet> createState() => _NewPetState();
}

class _NewPetState extends State<NewPet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Dişi';
  bool _vaccinationTracking = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("new_pet");
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                              "Yeni Evcil Hayvan!",
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
              _buildTextField(
                controller: _nameController,
                hintText: 'İsim',
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İsim boş olamaz';
                  }
                  if (value.length > 30) {
                    return 'İsim 30 karakterden uzun olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _speciesController,
                hintText: 'Tür (Kedi, Köpek, Balık...)',
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tür boş olamaz';
                  }
                  if (value.length > 40) {
                    return 'Tür 40 karakterden uzun olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _breedController,
                hintText: 'Cins (Labrador, Siyam, Balık)',
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cins boş olamaz';
                  }
                  if (value.length > 40) {
                    return 'Cins 40 karakterden uzun olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yaş boş olamaz';
                  }
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Yaş geçerli bir sayı olmalıdır';
                  }
                  if (age < 0 || age > 150) {
                    return 'Yaş 0 ile 150 arasında olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedGender.isEmpty ? null : _selectedGender,
                items: <String>['Erkek', 'Dişi'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: brown, width: 2.0),
                  ),
                  filled: true,
                  fillColor: cream,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                dropdownColor: cream,
              ),
              const SizedBox(height: 20.0),
              SwitchListTile(
                title: const Text(
                    'Aşı Takibi İstiyorum',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 14
                  ),
                ),
                value: _vaccinationTracking,
                onChanged: (bool value) {
                  setState(() {
                    _vaccinationTracking = value;
                  });
                },
                activeColor: pink,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    User? currentUser = auth.currentUser;
                    var docRef = await FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('pets').add({
                      'petName': _nameController.text,
                      'petSpecies': _speciesController.text,
                      'petBreed': _breedController.text,
                      'petAge': int.parse(_ageController.text),
                      'petImage': '',
                      'petGender': _selectedGender,
                      'timestamp': Timestamp.now(),
                      'isVaccinationTracking': _vaccinationTracking,
                      'vaccinationDates': _vaccinationTracking ? [] : null,
                      'foodList': [3, 3, 3, 3, 3, 3, 3],
                      'sleepList': [3, 3, 3, 3, 3, 3, 3],
                      'weightList': [3, 3, 3, 3, 3, 3, 3],
                      'exerciseList': [3, 3, 3, 3, 3, 3, 3],
                    });
                    log("Yeni hayvan eklendi");
                    _navPop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  "Oluştur",
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLength,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
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
      validator: validator,
    );
  }

  void _navPop() {
    Navigator.pop(context);
  }
}
