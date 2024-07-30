import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helperFiles/app_colors.dart';

class CheckUpPage extends StatefulWidget {
  final String petID;
  final Function(List<FlSpot>, List<FlSpot>, List<FlSpot>, List<FlSpot>) refreshGraph;

  const CheckUpPage({
    super.key,
    required this.petID,
    required this.refreshGraph,
  });

  @override
  State<CheckUpPage> createState() => _CheckUpPageState();
}

class _CheckUpPageState extends State<CheckUpPage> {
  final ValueNotifier<double> _sleepValueNotifier = ValueNotifier<double>(3);
  final ValueNotifier<double> _exerciseValueNotifier = ValueNotifier<double>(3);
  final ValueNotifier<double> _weightValueNotifier = ValueNotifier<double>(3);
  final ValueNotifier<double> _foodConsumptionValueNotifier = ValueNotifier<double>(3);

  String get petID => widget.petID;
  Function(List<FlSpot>, List<FlSpot>, List<FlSpot>, List<FlSpot>) get refreshGraph => widget.refreshGraph;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _updatePetCheckUpData() async {
    DocumentReference petDocRef = _firestore.collection('users')
        .doc(currentUser!.uid)
        .collection('pets')
        .doc(petID);

    DocumentSnapshot petDocSnapshot = await petDocRef.get();

    if (petDocSnapshot.exists) {
      Map<String, dynamic> petData = petDocSnapshot.data() as Map<String, dynamic>;

      List<dynamic> foodList = petData['foodList'] ?? [];
      List<dynamic> exerciseList = petData['exerciseList'] ?? [];
      List<dynamic> weightList = petData['weightList'] ?? [];
      List<dynamic> sleepList = petData['sleepList'] ?? [];

      foodList.add(_foodConsumptionValueNotifier.value);
      exerciseList.add(_exerciseValueNotifier.value);
      weightList.add(_weightValueNotifier.value);
      sleepList.add(_sleepValueNotifier.value);

      if (foodList.length > 5) foodList.removeAt(0);
      if (exerciseList.length > 5) exerciseList.removeAt(0);
      if (weightList.length > 5) weightList.removeAt(0);
      if (sleepList.length > 5) sleepList.removeAt(0);

      await petDocRef.update({
        'foodList': foodList,
        'exerciseList': exerciseList,
        'weightList': weightList,
        'sleepList': sleepList,
      });

      List<FlSpot> sleepSpots = sleepList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
      List<FlSpot> foodSpots = foodList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
      List<FlSpot> weightSpots = weightList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
      List<FlSpot> exerciseSpots = exerciseList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();

      refreshGraph(sleepSpots, foodSpots, weightSpots, exerciseSpots);
    } else {
      log("Pet document does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    log("check_up_page");
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/cozyCats.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "    Kontrol Et    ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Uyku Durumu',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                  ),
                ),
                customSlider(_sleepValueNotifier),
                const Text(
                  'Egzersiz Durumu',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                  ),
                ),
                customSlider(_exerciseValueNotifier),
                const Text(
                  'Kilo Durumu',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                  ),
                ),
                customSlider(_weightValueNotifier),
                const Text(
                  'Yemek Yeme Durumu',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                  ),
                ),
                customSlider(_foodConsumptionValueNotifier),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                    ),
                    onPressed: () async {
                      await _updatePetCheckUpData();
                      _showSnackBar();
                      _navTwicePop();
                    },
                    child: const Text(
                      'Gönder',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navTwicePop() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Bilgiler başarıyla gönderildi!',
          style: TextStyle(
            fontFamily: 'Baloo',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget customSlider(ValueNotifier<double> valueNotifier) {
    return ValueListenableBuilder<double>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Slider(
          activeColor: brown,
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.round().toString(),
          onChanged: (newValue) {
            valueNotifier.value = newValue;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _sleepValueNotifier.dispose();
    _exerciseValueNotifier.dispose();
    _weightValueNotifier.dispose();
    _foodConsumptionValueNotifier.dispose();
    super.dispose();
  }
}
