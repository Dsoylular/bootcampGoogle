import 'package:bootcamp_google/appColors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

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
      body: buildMainPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Öner Bana!',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Tarifler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Yeni Tarif',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: pink,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildMainPage() {
    return Container(
      color: cream,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Submit",
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
