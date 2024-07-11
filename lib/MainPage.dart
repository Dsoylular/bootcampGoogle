import 'dart:ui';

import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:bootcamp_google/helperWidgets/infoCards.dart';
import 'package:bootcamp_google/helperWidgets/petCard.dart';
import 'package:bootcamp_google/pages/login_register_page.dart';
import 'package:bootcamp_google/respondPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bootcamp_google/auth.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  String? profilePictureUrl;
  String? userName;
  String? name;
  String? surname;
  bool? isVet;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          profilePictureUrl = snapshot['profilePicture'];
          userName = snapshot['userName'];
          isVet = snapshot['isVet'];
          name = snapshot['firstName'];
          surname = snapshot['lastName'];
          print(profilePictureUrl);
          print(isVet);
          print(name);
        });
      }
    }
    print("AAAAAAAA $profilePictureUrl");
  }

  void _sendMessage() {
    setState(() {
      var message = "";
      message = _messageController.text.trim();
      if (message.isNotEmpty) {
        _messages.clear();
        _messages.add({'type': 'user', 'message': message});
        _messages.add({'type': 'response', 'message': _getResponseMessage()});
        _messageController.clear();
      }
    });
  }


  String _getResponseMessage() {
    return "Thank you for your message.\nPlease wait for the response...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? null : appBar(context),
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
            label: 'Bana Sor!',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Evcil Hayvanlarım',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profil',
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
                    "Evcil Hayvanlarım",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      print("Clicked ADD"); // TODO: Connect with backend
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "+   Ekle",
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
                  " Durum",
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

  Widget _buildAskMe() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    'assets/images/cuteCat.jpeg',
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
                        "    Sor Bana    ",
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
          Container(
            decoration: BoxDecoration(
              color: cream,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _messages.isEmpty
                      ? const SizedBox(
                    height: 130,
                    child: Center(
                      child: Text(
                        'Gönderilmiş mesaj yok.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message['type'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ChatBubble(
                          message: message['message']!,
                          isUserMessage: message['type'] == 'user',
                        ),
                      );
                    },
                  ),
                  const Divider(),
              Container(
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: (){
                        //TODO: FILL
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null, // Set to null for unlimited lines
                        keyboardType: TextInputType.multiline, // Allow multiline input
                        textInputAction: TextInputAction.newline, // Change keyboard's enter button to newline
                        decoration: const InputDecoration(
                          hintText: 'Sorunuzu giriniz...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              SizedBox(width: 16),
              Text(
                "Sıkça Sorulan Sorular",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            ],
          ),
          Divider(thickness: 2, color: brown),
          _buildFaqSection(),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    final faqs = {
      "Genel": ["Can you help me set up a virtual pet sitter and suggest a product that can give treats to my dog while I'm at work?", "Based on my active lifestyle, apartment living, and preference for medium-sized dogs, can you suggest some breeds that might be a good fit for me?"],
      "Beslenme": ["I have a Labrador Retriever. Can you help me create a balanced diet plan for her?", "What do tarantulas eat?"],
      "Sağlık": ["My cat has been sneezing a lot lately. What could be the cause, and should I be worried?", "How can I help my rescue dog overcome his fear of thunderstorms?", "Give me step-by-step instructions for handling [pet injury] before I can reach a vet."],
      "Tuvalet": ["Tuvalet soru 1", "Tuvalet soru 2"],
      "Eğitim": ["Can you help me create a training plan to teach my dog to come when called?", "My new kitten is shy around strangers. How can I help her become more social?", "Suggest an interactive game that my cat would enjoy playing."]
    };

    return Column(
      children: faqs.entries.map((entry) {
        return ExpansionTile(
          title: Text(
            entry.key,
            style: TextStyle(fontSize: 16, fontFamily: 'Baloo', color: brown),
          ),
          children: entry.value.map((question) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: brown)
              ),
              child: ListTile(
                title: Text(question, style: const TextStyle(fontWeight: FontWeight.w300)),
                onTap: () {
                  print("Deniz");
                  _messageController.text = question;
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }


  Widget _buildJournal() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 300,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Pawdi Forum",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pacifico',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.orangeAccent,
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: brown),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        image: profilePictureUrl != null
                            ? NetworkImage(profilePictureUrl!)
                            : const AssetImage('assets/images/kediIcon.png') as ImageProvider<Object>,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "$name $surname",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$userName",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(isVet == true ? "Veteriner" : "Evcil Hayvan Sahibi"),
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
                // ElevatedButton(
                //   onPressed: () {
                //     print("Profile Page");
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: darkBlue,
                //     fixedSize: const Size(300, 50),
                //   ),
                //   child: const Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Icon(Icons.mail_outlined, color: Colors.white),
                //       SizedBox(width: 10),
                //       Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               "E-mail",
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             Text(
                //               "E-mail adresini değiştir",
                //               style: TextStyle(
                //                 color: Colors.white70,
                //                 fontSize: 12,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 30),
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
                      Icon(Icons.person_outlined, color: Colors.white),
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
            onPressed: () async {
              await Auth().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                    (Route<dynamic> route) => false,
              );
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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUserMessage
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RespondPage(respond: message),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? pink.withOpacity(0.9) : darkBlue.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUserMessage ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUserMessage ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

