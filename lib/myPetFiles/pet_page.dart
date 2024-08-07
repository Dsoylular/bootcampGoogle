import 'dart:developer';

import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:bootcamp_google/helperFiles/gemini_codes.dart';
import 'package:bootcamp_google/helperFiles/my_app_bar.dart';
import 'package:bootcamp_google/myPetFiles/change_pet_info.dart';
import 'package:bootcamp_google/myPetFiles/check_up_page.dart';
import 'package:bootcamp_google/myPetFiles/myPetHelperFiles/situation_analysis_info.dart';
import 'package:bootcamp_google/myPetFiles/myPetHelperFiles/vaccinationInfoPage.dart';
import 'package:bootcamp_google/myPetFiles/pet_detailed_info_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


import '../helperFiles/photo_add_functions.dart';



class PetPage extends StatefulWidget {

  final String petID;

  const PetPage({super.key, required this.petID});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  List<DateTime> _preSelectedDays = [];
  DateTime? _userSelectedDay;

  User? currentUser = FirebaseAuth.instance.currentUser;

  String petName = "";
  String petAge = "";
  String petBreed = "";
  String petSpecies = "";
  String petImage = "";
  String petGender = "";
  bool isLoading = true;
  bool isGeminiLoading = false;
  bool showAddButton = false;
  bool isVaccinationTracking = false;

  List<FlSpot> foodList = [];
  List<FlSpot> exerciseList = [];
  List<FlSpot> weightList = [];
  List<FlSpot> sleepList = [];

  get petID => widget.petID;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    initializeData();
  }

  void initializeData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection("pets")
        .doc(petID)
        .get();
    setState(() {
        petName = snapshot['petName'];
        petAge = snapshot['petAge'].toString();
        petBreed = snapshot['petBreed'];
        petImage = snapshot['petImage'] ?? "";
        petSpecies = snapshot['petSpecies'];
        foodList = getFlSpotList(snapshot['foodList']);
        exerciseList = getFlSpotList(snapshot['exerciseList']);
        weightList = getFlSpotList(snapshot['weightList']);
        sleepList = getFlSpotList(snapshot['sleepList']);
        petGender = snapshot['petGender'];
        isVaccinationTracking = snapshot['isVaccinationTracking'] ?? false;
        if(isVaccinationTracking) {
          _preSelectedDays = List<DateTime>.from(
            snapshot['vaccinationDates'].map((timestamp) =>
                (timestamp as Timestamp).toDate()));
        }
        isLoading = false;
    });
  }

  List<FlSpot> getFlSpotList(List<dynamic> fireList){
    List<FlSpot> endList = [];
    for(int i = 0; i < fireList.length; i++){
      endList.add(FlSpot(i.ceilToDouble(), fireList[i].ceilToDouble()));
    }
    return endList;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildChart(String title, List<FlSpot> spots, List<String> days, Color lineColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(days[value.toInt() % days.length]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: brown, width: 2),
          ),
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      )

    );
  }

  @override
  Widget build(BuildContext context) {
    log("pet_page");
    if (isLoading) {
      return Scaffold(
        appBar: appBar(context),
        body: Center(
          child: CircularProgressIndicator(
            color: pink,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            width: 164,
                            height: 164,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: brown,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              child: ClipOval(
                                child: getPetImage(petImage),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                updatePetProfilePicture(context, petName, petID, refreshProfilePhoto);
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: darkBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        petName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Baloo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Flexible(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Text(
                              "$petName, $petAge yaşında, $petBreed cinsinde akıllı bir ${(petGender == 'erkek' || petGender == 'Erkek') ? 'beyefendidir' : 'hanımefendidir'}.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Baloo',
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangePetScreen(
                                  petID: petID,
                                  petAge: petAge,
                                  petBreed: petBreed,
                                  petSpecies: petSpecies,
                                  petGender: petGender,
                                  petName: petName,
                                ))
                            );
                            log("Profile Page");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            fixedSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Düzenle",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Baloo',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if(isVaccinationTracking)...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    "Aşı Takip",
                    style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VaccinationInfoPage())
                        );
                      },
                      icon: Icon(Icons.info_outlined, color: pink),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: cream,
                  border: Border.all(color: brown, width: 2),
                ),
                child: TableCalendar(
                  availableCalendarFormats: const {
                    CalendarFormat.twoWeeks: 'Month',
                    CalendarFormat.week: '2 weeks',
                    CalendarFormat.month: 'Week',
                  },
                  calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                          color: darkBlue,
                          shape: BoxShape.circle
                      ),
                      todayDecoration: BoxDecoration(
                          color: pink.withOpacity(0.6),
                          shape: BoxShape.circle
                      )
                  ),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return _preSelectedDays.contains(day.toLocal()) || isSameDay(_userSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (_preSelectedDays.contains(selectedDay.toLocal())) {
                        _preSelectedDays.remove(selectedDay.toLocal());
                        _userSelectedDay = null;
                        showAddButton = true;
                      }
                      else {
                        if(_userSelectedDay == selectedDay.toLocal()){
                          _userSelectedDay = null;
                          showAddButton = true;
                        }
                        else{
                          _userSelectedDay = selectedDay.toLocal();
                          showAddButton = true;
                        }
                      }
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (showAddButton)
                Row(
                  children: [
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                      ),
                      onPressed: () async {
                        setState(() {
                          if(_userSelectedDay != null){
                            _preSelectedDays.add(_userSelectedDay!);
                          }
                          showAddButton = false;
                        });

                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser!.uid)
                              .collection("pets")
                              .doc(petID)
                              .update({'vaccinationDates': _preSelectedDays});
                          log('Vaccination dates updated successfully.');
                        } catch (e) {
                          log('Error updating vaccination dates: $e');
                        }
                      },
                      child: const Text(
                        'Kaydet',
                        style: TextStyle(
                          fontFamily: 'Baloo',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 30),
                const Text(
                  "Durum Analizi",
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SituationAnalysisInfo()),
                    );
                  },
                  icon: Icon(Icons.info_outlined, color: pink),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _createGraph(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckUpPage(
                          petID: petID,
                          refreshGraph: refreshGraph,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text(
                    "Check-Up",
                    style: TextStyle(
                        fontFamily: 'Baloo',
                        color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (){
                    zeroGraphs();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text(
                    "Sıfırla",
                    style: TextStyle(
                        fontFamily: 'Baloo',
                        color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: pink),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: !isGeminiLoading
                      ? IconButton(
                          onPressed: () async{
                            setState(() {
                              isGeminiLoading = true;
                            });
                            String? response = await getDetailedInfo(petID);
                            setState(() {
                              isGeminiLoading = false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PetDetailedInfoPage(respond: response ?? "Durum Analizi Hatası!")));
                          },
                          icon: Icon(Icons.smart_toy_outlined, color: pink)
                      )
                      : CircularProgressIndicator(color: pink)
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _createGraph() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: cream,
        border: Border.all(color: brown, width: 2),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: darkBlue,
            tabs: const [
              Tab(text: "Yemek"),
              Tab(text: "Egzersiz"),
              Tab(text: "Kilo"),
              Tab(text: "Uyku"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildChart(
                  "Yemek",
                  foodList,
                  ['1', '2', '3', '4', '5', '6', '7'],
                  Colors.blue,
                ),
                buildChart(
                  "Egzersiz",
                  exerciseList,
                  ['1', '2', '3', '4', '5', '6', '7'],
                  Colors.green,
                ),
                buildChart(
                  "Kilo",
                  weightList,
                  ['1', '2', '3', '4', '5', '6', '7'],
                  Colors.orange,
                ),
                buildChart(
                  "Uyku",
                  sleepList,
                  ['1', '2', '3', '4', '5', '6', '7'],
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void refreshProfilePhoto(String newUrl) {
    setState(() {
      petImage = newUrl;
    });
  }

  refreshGraph(List<FlSpot> sleep, List<FlSpot> food, List<FlSpot> weight, List<FlSpot> exercise) {
    setState(() {
      sleepList = sleep;
      foodList = food;
      weightList = weight;
      exerciseList = exercise;
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void zeroGraphs() async {
    DocumentReference petDocRef = _firestore.collection('users')
        .doc(currentUser!.uid)
        .collection('pets')
        .doc(petID);

    DocumentSnapshot petDocSnapshot = await petDocRef.get();

    if (petDocSnapshot.exists) {

      List<dynamic> foodList = [3, 3, 3, 3, 3, 3, 3];
      List<dynamic> exerciseList = [3, 3, 3, 3, 3, 3, 3];
      List<dynamic> weightList = [3, 3, 3, 3, 3, 3, 3];
      List<dynamic> sleepList = [3, 3, 3, 3, 3, 3, 3];

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
    Navigator.pop(context);
  }
}

getPetImage(String petImage) {
  if(petImage != ""){
    try{
      return FadeInImage.assetNetwork(
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
      );
    }
    catch(e){
      return Image.asset(
        'assets/images/kediIcon.png',
        fit: BoxFit.cover,
        width: 160,
        height: 160,
      );
    }
  }
  return Image.asset(
    'assets/images/kediIcon.png',
    fit: BoxFit.cover,
    width: 160,
    height: 160,
  );
}

