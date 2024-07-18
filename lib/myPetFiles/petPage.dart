import 'dart:ui';
import 'package:bootcamp_google/helperFiles/appColors.dart';
import 'package:bootcamp_google/helperFiles/myAppBar.dart';
import 'package:bootcamp_google/myPetFiles/checkUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  get petID => widget.petID;

  @override
  void initState() {
    print("AAAAAAAAAAAAAAA");
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
      print("Preselected Dates: $_preSelectedDays");
    });
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
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              margin: 10,
              interval: 1,
              getTitles: (value) {
                return days[value.toInt() % days.length];
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              margin: 10,
              getTitles: (value) {
                return value.toInt().toString();
              },
            ),
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
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
              colors: [lineColor],
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
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
                      CircleAvatar(
                        radius: 80,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/kediIcon.png', // TODO: Connect with backend
                            image: 'https://i.imgur.com/9l1A4OS.jpeg', // TODO: Connect with backend
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Fred",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
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
                            child: const Text(
                              "Fred, 12 yaşında, Ragdoll cinsinde bir beyefendidir.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            print("Profile Page");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            fixedSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Profili düzenle",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Distance from the bottom
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
                    // fontWeight: FontWeight.bold,
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
                  // print("${_preSelectedDays[0]}    ${day.toLocal()}     ${_preSelectedDays.contains(day.toLocal())}");
                  return _preSelectedDays.contains(day.toLocal()) || isSameDay(_userSelectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    if (_preSelectedDays.contains(selectedDay)) {
                      // Do nothing if the selected day is already in the pre-selected dates
                      _preSelectedDays.remove(selectedDay);
                      _userSelectedDay = null;
                      showAddButton = true;
                    } else {
                      if(_userSelectedDay == selectedDay){
                        _userSelectedDay = null;
                        showAddButton = true;
                      }
                      else{
                        _userSelectedDay = selectedDay;
                        showAddButton = true;
                      }
                    }
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
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
                      print("AAAAAAAA $_preSelectedDays");
                      setState(() {
                        _preSelectedDays.add(_userSelectedDay!);
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
                      print("AAAAAAAA $_preSelectedDays");
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _createGraph(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                // TODO: FUNCTIONALITY
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckUpPage()),
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
                  [
                    FlSpot(0, 3),
                    FlSpot(1, 1),
                    FlSpot(2, 4),
                    FlSpot(3, 3),
                    FlSpot(4, 2),
                    FlSpot(5, 5),
                    FlSpot(6, 4),
                  ],
                  ['Paz', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
                  Colors.blue,
                ),
                buildChart(
                  "Egzersiz",
                  [
                    FlSpot(0, 2),
                    FlSpot(1, 3),
                    FlSpot(2, 2),
                    FlSpot(3, 5),
                    FlSpot(4, 1),
                    FlSpot(5, 4),
                    FlSpot(6, 3),
                  ],
                  ['Paz', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
                  Colors.green,
                ),
                buildChart(
                  "Kilo",
                  [
                    FlSpot(0, 4),
                    FlSpot(1, 3),
                    FlSpot(2, 5),
                    FlSpot(3, 2),
                    FlSpot(4, 4),
                    FlSpot(5, 3),
                    FlSpot(6, 5),
                  ],
                  ['Paz', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
                  Colors.orange,
                ),
                buildChart(
                  "Uyku",
                  [
                    FlSpot(0, 3),
                    FlSpot(1, 4),
                    FlSpot(2, 2),
                    FlSpot(3, 5),
                    FlSpot(4, 3),
                    FlSpot(5, 4),
                    FlSpot(6, 2),
                  ],
                  ['Paz', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
