import 'dart:ui';

import 'package:bootcamp_google/appColors.dart';
import 'package:bootcamp_google/helperWidgets/infoCards.dart';
import 'package:bootcamp_google/helperWidgets/petCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/myAppBar.dart';

// DocumentSnapshot snapshot = await FirebaseFirestore.instance
//     .collection('users')
// .doc('users')
//     .get();
// if (snapshot.exists) {
// final curData = snapshot.data() as Map<String, dynamic>;
// final res = curData['deniz'] ?? '';
// print(res);
// }



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
      appBar: appBar(),
      body: _selectedIndex == 0
          ? _buildAskMe()
          : _selectedIndex == 1
          ? _buildJournal()
          : _selectedIndex == 2
          ? _buildMyPets()
          : _buildProfile(),
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

  Widget _buildMyPets() {
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async{

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
              PetCard(context),
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
            InfoCard(context),
          ],
        ),
      ],
    );
  }


  Widget _buildAskMe(){
    return Scaffold(

    );
  }

  Widget _buildJournal() {
    return Scaffold(

    );
  }

  Widget _buildProfile() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage('https://i.imgur.com/9l1A4OS.jpeg'),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Fatmanur Genar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "fatmanur.genar1234",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Pet Owner"
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profil Fotoğrafı",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Profil resmini değiştir",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "İsim",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Görünür ismini değiştir",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hakkında",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hakkında kısmını değiştir",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.key_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Şifre",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Şifreyi değiştir",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
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
                    SizedBox(width: 50),
                    Text(
                      "Hesap Ayarları",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Çıkış",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hesaptan çıkış yap",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    print("Profile Page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_presentation_sharp, color: Colors.white),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hesabı sil",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hesabı kalıcı bir şekilde sil",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
