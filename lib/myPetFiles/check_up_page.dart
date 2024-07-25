import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helperFiles/app_colors.dart';

class CheckUpPage extends StatefulWidget {

  final String petID;
  final Function(List<FlSpot>, List<FlSpot>, List<FlSpot>, List<FlSpot>) refreshGraph;
  const CheckUpPage({super.key, required this.petID, required this.refreshGraph});

  @override
  State<CheckUpPage> createState() => _CheckUpPageState();
}

class _CheckUpPageState extends State<CheckUpPage> {

  double sleepValue = 3;
  double exerciseValue = 3;
  double weightValue = 3;
  double foodConsumptionValue = 3;

  String get petID => widget.petID;
  Function(List<FlSpot>, List<FlSpot>, List<FlSpot>, List<FlSpot>) get refreshGraph => widget.refreshGraph;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _updatePetCheckUpData(Function(List<FlSpot>, List<FlSpot>, List<FlSpot>, List<FlSpot>) refreshGraph) async {
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

      foodList.add(foodConsumptionValue);
      exerciseList.add(exerciseValue);
      weightList.add(weightValue);
      sleepList.add(sleepValue);

      foodList.removeAt(0);
      exerciseList.removeAt(0);
      weightList.removeAt(0);
      sleepList.removeAt(0);

      await petDocRef.update({
        'foodList': foodList,
        'exerciseList': exerciseList,
        'weightList': weightList,
        'sleepList': sleepList,
      });

      List<FlSpot> sleepSpots = sleepList.map((value) => FlSpot(sleepList.indexOf(value).toDouble(), value.toDouble())).toList();
      List<FlSpot> foodSpots = foodList.map((value) => FlSpot(foodList.indexOf(value).toDouble(), value.toDouble())).toList();
      List<FlSpot> weightSpots = weightList.map((value) => FlSpot(weightList.indexOf(value).toDouble(), value.toDouble())).toList();
      List<FlSpot> exerciseSpots = exerciseList.map((value) => FlSpot(exerciseList.indexOf(value).toDouble(), value.toDouble())).toList();

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
                      fontFamily: 'Baloo'
                  ),
                ),
                customSlider(sleepValue),
                const Text(
                  'Egzersiz Durumu',
                  style: TextStyle(
                      fontFamily: 'Baloo'
                  ),
                ),
                customSlider(exerciseValue),
                const Text(
                  'Kilo Durumu',
                  style: TextStyle(
                      fontFamily: 'Baloo'
                  ),
                ),
                customSlider(weightValue),
                const Text(
                  'Yemek Yeme Durumu',
                  style: TextStyle(
                      fontFamily: 'Baloo'
                  ),
                ),
                customSlider(foodConsumptionValue),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue
                    ),
                    onPressed: () async {
                      await _updatePetCheckUpData(refreshGraph);
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

  void _navTwicePop(){
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
  Widget customSlider(double value){
    return Slider(
      activeColor: brown,
      value: value,
      min: 1,
      max: 5,
      divisions: 4,
      label: value.round().toString(),
      onChanged: (newValue) {
        setState(() {
          value = newValue;
        });
      },
    );
  }
}