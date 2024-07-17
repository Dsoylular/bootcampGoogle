import 'dart:ui';
import 'package:bootcamp_google/helperFiles/appColors.dart';
import 'package:bootcamp_google/helperFiles/myAppBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class petPage extends StatefulWidget {
  const petPage({super.key});

  @override
  State<petPage> createState() => _petPageState();
}

class _petPageState extends State<petPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  "Durum Analizi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
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
                    tabs: const [
                      Tab(text: "Food Consumption"),
                      Tab(text: "Exercise"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  getTitles: (value) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return 'Mon';
                                      case 1:
                                        return 'Tue';
                                      case 2:
                                        return 'Wed';
                                      case 3:
                                        return 'Thu';
                                      case 4:
                                        return 'Fri';
                                      case 5:
                                        return 'Sat';
                                      case 6:
                                        return 'Sun';
                                      default:
                                        return '';
                                    }
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitles: (value) {
                                    return value.toInt().toString();
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 6,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 3),
                                    FlSpot(1, 1),
                                    FlSpot(2, 4),
                                    FlSpot(3, 3),
                                    FlSpot(4, 2),
                                    FlSpot(5, 5),
                                    FlSpot(6, 4),
                                  ],
                                  isCurved: true,
                                  colors: [Colors.blue],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(show: false),
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  getTitles: (value) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return 'Mon';
                                      case 1:
                                        return 'Tue';
                                      case 2:
                                        return 'Wed';
                                      case 3:
                                        return 'Thu';
                                      case 4:
                                        return 'Fri';
                                      case 5:
                                        return 'Sat';
                                      case 6:
                                        return 'Sun';
                                      default:
                                        return '';
                                    }
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitles: (value) {
                                    return value.toInt().toString();
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 6,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 2),
                                    FlSpot(1, 3),
                                    FlSpot(2, 2),
                                    FlSpot(3, 5),
                                    FlSpot(4, 1),
                                    FlSpot(5, 4),
                                    FlSpot(6, 3),
                                  ],
                                  isCurved: true,
                                  colors: [Colors.green],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(show: false),
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
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
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: cream,
                border: Border.all(color: brown, width: 2),
              ),
              child: Center(child: Text("Aşı Takibi buraya")),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                // TODO: FUNCTIONALITY
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
}
