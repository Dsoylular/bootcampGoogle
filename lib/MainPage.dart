import 'package:bootcamp_google/appColors.dart';
import 'package:bootcamp_google/helperWidgets/infoCards.dart';
import 'package:bootcamp_google/helperWidgets/petCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        title: const Row(
          children: [
             SizedBox(width: 20),
            Expanded(
              child: Text(
                "Pawdi",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pacifico',
                ),
              ),
            ),
          ],
        ),
      ),
      body: buildMyPets(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_outlined),
            label: 'Ask Me!',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'My Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildMyPets() {
    return Column(
      children: [
        Container(
          height: 375,
          width: double.infinity,
          decoration: BoxDecoration(
            color: cream,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    "My Pets",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      print("Clicked ADD"); // TODO: Connect with backend
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "+   ADD",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 30),
              PetCard(),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Column(
          children: [
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  " Situation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InfoCard(),
          ],
        ),
      ],
    );
  }

}
