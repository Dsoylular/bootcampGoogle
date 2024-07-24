import 'package:bootcamp_google/helperFiles/appColors.dart';
import 'package:bootcamp_google/helperFiles/myAppBar.dart';
import 'package:bootcamp_google/myPetFiles/changePetInfo.dart';
import 'package:bootcamp_google/myPetFiles/checkUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


import '../helperFiles/photoAddFunctions.dart';



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
  bool showAddButton = false;
  List<DateTime> _preSelectedDays = [];
  DateTime? _userSelectedDay;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String petName = "";
  String petAge = "";
  String petBreed = "";
  String petImage = "";
  String petGender = "";

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
      _preSelectedDays = List<DateTime>.from(snapshot['vaccinationDates'].map((timestamp) => (timestamp as Timestamp).toDate()));
      petName = snapshot['petName'];
      petAge = snapshot['petAge'].toString();
      petBreed = snapshot['petBreed'];
      petImage = snapshot['petImage'];
      foodList = getFlSpotList(snapshot['foodList']);
      exerciseList = getFlSpotList(snapshot['exerciseList']);
      weightList = getFlSpotList(snapshot['weightList']);
      sleepList = getFlSpotList(snapshot['sleepList']);
      petGender = snapshot['petGender'];
      // print("Preselected Dates: $_preSelectedDays");
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
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                // margin: 10,
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
                // margin: 10,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      )

    );
  }

  @override
  Widget build(BuildContext context) {
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
                                child: petImage.isNotEmpty
                                    ? FadeInImage.assetNetwork(
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
                                )
                                    : Image.asset(
                                  'assets/images/kediIcon.png',
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                ),
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
                          // fontWeight: FontWeight.bold,
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
                              "$petName, $petAge yaşında, $petBreed cinsinde akıllı bir ${petGender == 'erkek' ? 'beyefendidir' : 'hanımefendidir'}.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Baloo',
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangePetScreen(petID: petID))
                            );
                            print("Profile Page");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            fixedSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Düzenle",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
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
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Aşı Takip",
                  style: TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 18
                  ),
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
              // child: Text(_preSelectedDays[0].toString()),
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
                      // print("kfgjlkdjflşdgşfd");
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
                      // print("AAAAAAAA $_preSelectedDays");
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
                        print('Vaccination dates updated successfully.');
                      } catch (e) {
                        print('Error updating vaccination dates: $e');
                        // Handle error accordingly
                      }
                      // print("AAAAAAAA $_preSelectedDays");
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
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Durum Analizi",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Baloo',
                      fontSize: 18,
                  ),
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
                SizedBox(width: 20),
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
              ],
            ),
            SizedBox(height: 20),
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
      Map<String, dynamic> petData = petDocSnapshot.data() as Map<String, dynamic>;

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
      print("Pet document does not exist");
    }
  }
}

