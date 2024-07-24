import 'dart:math';

import 'package:bootcamp_google/blogFiles/blogProfile.dart';
import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:bootcamp_google/helperFiles/gemini_codes.dart';
import 'package:bootcamp_google/helperFiles/info_cards.dart';
import 'package:bootcamp_google/helperFiles/pet_card.dart';
import 'package:bootcamp_google/helperFiles/profile_button.dart';
import 'package:bootcamp_google/myPetFiles/newPet.dart';
import 'package:bootcamp_google/pages/login_register_page.dart';
import 'package:bootcamp_google/askMeFiles/respond_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'blogFiles/newBlogPost.dart';
import 'helperFiles/my_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [{'type': 'user', 'message': 'Aklınızdaki soruyu sorun.'},
    {'type': 'response', 'message': 'Cevabını yapay zekadan alın!'}];
  String? profilePictureUrl;
  String? userName;
  String? name;
  String? surname;
  String? about;
  String? curUserId;
  String chosenPetName = "";
  String chosenPetID = "";
  bool? isVet;
  bool _isLoading = false;
  bool petChosen = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, String> userPets = {};
  Map<String, String> petsID = {};
  Map<String, String> petsPicture = {};

  bool isLogin = false;

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
      isLogin = true;
      _selectedIndex = 2;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          profilePictureUrl = snapshot['pictureURL'];
          userName = snapshot['userName'];
          isVet = snapshot['isVet'];
          name = snapshot['firstName'];
          surname = snapshot['lastName'];
          about = snapshot['description'];
          curUserId = currentUser.uid.toString();
        });
      }
      QuerySnapshot petSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('pets')
          .get();

      for (var doc in petSnapshot.docs) {
        petsID[doc['petName']] = doc.id;
        petsPicture[doc['petName']] = doc['petImage'];
      }
      setState(() {
        userPets = petsID;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: (_selectedIndex == 0 || !isLogin) ? null : appBar(context),
      body: _selectedIndex == 0
          ? _buildAskMe()
          : _selectedIndex == 1
          ? _buildJournal()
          : _selectedIndex == 2
          ? (isLogin ? _buildMyPets() : _buildNotLogin())
          : (isLogin ? _buildProfile() : _buildNotLogin()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
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


  Widget _buildAskMe() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _askMeUpperDesign(),
          _messagingInterface(),
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
  Widget _askMeUpperDesign() {
    return Container(
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
    );
  }
  Widget _buildFaqSection() {
    final faqs = {
      'Genel': [
        "Hangi aşıları yaptırmalıyım ve aşı takvimi nedir?",
        "Parazitlerden korunma için hangi ilaçları kullanmalıyım?",
        "Kısırlaştırma operasyonunun faydaları ve riskleri nelerdir?",
        "Evcil hayvanımı ne sıklıkla sağlık kontrolüne götürmeliyim?",
        "Hangi belirtiler acil veteriner müdahalesi gerektirir?",
        "Evcil hayvanımda alerji belirtileri var, ne yapmalıyım?",
        "Evcil hayvanımın kilosunu nasıl ideal seviyede tutabilirim?",
        "Evcil hayvanım için yeterli egzersiz nasıl sağlanır?"
      ],
      'Kedi': [
        "Kedimin sağlıklı bir diyet için nelere ihtiyacı var?",
        "Kedim neden tüylerini yutuyor ve kusuyor?",
        "Kedimin tırnak bakımı nasıl yapılmalıdır?",
        "Kedimin tuvalet eğitimi nasıl sağlanır?",
        "Kedim neden mobilyaları tırmalıyor ve nasıl önleyebilirim?"
      ],
      'Köpek': [
        "Köpeğim için en uygun beslenme planı nedir?",
        "Köpeğimin diş sağlığını nasıl koruyabilirim?",
        "Köpeğimin sosyalleşmesi için neler yapmalıyım?",
        "Köpeğimi yürüyüşe ne sıklıkla çıkarmalıyım?",
        "Köpeğim neden havlıyor ve nasıl önleyebilirim?"
      ],
      'Kuşlar': [
        "Kuşum için en uygun beslenme programı nedir?",
        "Kuşumun kafesi nasıl olmalı? Hangi malzemeleri kullanmalıyım?",
        "Kuşum neden tüylerini yoluyor veya agresif davranıyor?",
        "Kuşumun veteriner kontrolü ne sıklıkla yapılmalı?",
        "Kuşumun hangi aşıları olması gerekiyor?"
      ],
      'Sürüngenler': [
        "Sürüngenim için en uygun diyet nedir? Canlı yem mi vermeliyim?",
        "Terraryum nasıl olmalı? Hangi sıcaklık ve nem seviyeleri idealdir?",
        "Sürüngenimin hareket ve davranışları normal mi?",
        "Yaygın sürüngen hastalıkları nelerdir ve nasıl tedavi edilir?",
        "Sürüngenimin üreme sürecini nasıl yönetmeliyim?"
      ],
      'Kemirgenler': [
        "Kemirgenim için en uygun beslenme planı nedir?",
        "Kemirgenimin kafesi nasıl olmalı? Hangi malzemeleri kullanmalıyım?",
        "Kemirgenimin kemirme ve tünel kazma davranışlarını nasıl yönlendirebilirim?",
        "Kemirgenimin veteriner kontrolü ne sıklıkla yapılmalı?",
        "Kemirgenimin sosyal ihtiyaçları nelerdir?"
      ],
      'Balıklar': [
        "Akvaryumumun su kalitesini nasıl koruyabilirim?",
        "Balıklarım için en uygun yemler nelerdir?",
        "Balık hastalıkları nasıl tedavi edilir?",
        "Akvaryum dekorasyonu ve bitki seçimi nasıl olmalı?",
        "Akvaryuma yeni balık eklerken nelere dikkat etmeliyim?"
      ],
      'Egzotik Hayvanlar': [
        "Egzotik hayvanım için en uygun beslenme programı nedir?",
        "Egzotik hayvanımın yaşam alanını nasıl düzenlemeliyim?",
        "Egzotik hayvanımın agresif veya çekingen davranışlarını nasıl düzeltebilirim?",
        "Egzotik hayvanımın veteriner kontrolü ne sıklıkla yapılmalı?",
        "Egzotik hayvanımın özel bakım ihtiyaçları nelerdir?"
      ],
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
                  _messageController.text = question;
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _messagingInterface() {
    return Container(
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
                    messages: _messages,
                    isUserMessage: message['type'] == 'user',
                    controller: _messageController,
                  ),
                );
              },
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if(isLogin)...[(!petChosen) ? IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      _showPetSelectionMenu(context);
                    },
                  ) : Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          _showPetSelectionMenu(context);
                        },
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/kediIcon.png',
                            image: petsPicture[chosenPetName] ?? 'assets/images/kediIcon.png',
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/kediIcon.png',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  ],
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
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
    );
  }
  void _showPetSelectionMenu(BuildContext context) {
    List<String> pets = userPets.keys.toList();
    pets.add("Hiçbiri");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: pets.map((pet) {
              return ListTile(
                title: Text(pet),
                onTap: () {
                  Navigator.pop(context);
                  print('Selected pet: $pet');
                  // print("$petsPicture");
                  setState(() {
                    petChosen = (pet != 'Hiçbiri') ? true : false;
                    chosenPetName = (pet != 'Hiçbiri') ? pet : "";
                    chosenPetID = (pet != 'Hiçbiri') ? petsID[pet]! : "";
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
  void _sendMessage() async {
    var message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.clear();
        _messages.add({'type': 'user', 'message': message});
        _isLoading = true;
      });

      final response = await _getResponseMessage(message);

      setState(() {
        _messages.add({'type': 'response', 'message': response ?? ""});
        _messageController.clear();
        _isLoading = false;
      });
    }
  }
  Future<String?> _getResponseMessage(String message) async {
    return await talkWithGemini(message, chosenPetID);
  }


  Widget _buildJournal() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(!isLogin)...[
              const SizedBox(height: 40),
            ],
            _journalUpperDesign(),
            _journalPosts(),
          ],
        ),
      ),
    );
  }
  Widget _journalPosts(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blogPosts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No blog posts available');
        }
        final blogPosts = snapshot.data!.docs;
        return Column(
          children: blogPosts.map((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final userId = post['author'];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final user = userSnapshot.data!.data() as Map<String, dynamic>;
                String profilePicture = user['pictureURL'] ?? " ";
                String username = user['userName'];
                bool isVet = user['isVet'];
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blogPosts')
                      .doc(doc.id)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, commentsSnapshot) {
                    int commentsLength = commentsSnapshot.hasData
                        ? commentsSnapshot.data!.docs.length
                        : 0;

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/kediIcon.png',
                                      image: profilePicture,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/kediIcon.png',
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontFamily: 'Baloo',
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (isVet) ...[
                                    const SizedBox(width: 5),
                                    const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                                  ],
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if(!isLogin){}
                                      else if (post['likedPeople'] != null && !post['likedPeople'].contains(curUserId)) {
                                        setState(() {
                                          post['like'] += 1;
                                          post['likedPeople'].add(curUserId);
                                        });
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('blogPosts')
                                              .doc(doc.id)
                                              .update({
                                            'like': FieldValue.increment(1),
                                            'likedPeople': FieldValue.arrayUnion([curUserId]),
                                          });
                                        } catch (e) {
                                          print('Error updating like count: $e');
                                          post['like'] -= 1;
                                        }
                                      }
                                      else {
                                        setState(() {
                                          post['like'] -= 1;
                                          post['likedPeople'].remove(curUserId);
                                        });
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('blogPosts')
                                              .doc(doc.id)
                                              .update({
                                            'like': FieldValue.increment(-1),
                                            'likedPeople': FieldValue.arrayRemove([curUserId]),
                                          });
                                        } catch (e) {
                                          print('Error updating like count: $e');
                                          post['like'] += 1;
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_up, color: post['likedPeople'].contains(curUserId) ? Colors.blue : Colors.grey, size: 20),
                                        const SizedBox(width: 5),
                                        Text(
                                          post['likedPeople'].length.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Baloo',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20)
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        commentsLength.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Baloo',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.grey, thickness: 1),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                    ),
                                  );
                                },
                                child: Text(
                                  post['title'],
                                  style: TextStyle(
                                    fontFamily: 'Baloo',
                                    fontSize: 18,
                                    color: darkBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${post['text'].toString().substring(0, min(40, post['text'].toString().length))}...",
                                style: const TextStyle(
                                  fontFamily: 'Baloo',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
  Widget _journalUpperDesign(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkBlue.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Container(
              width: 300,
              height: double.infinity,
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "PawBlog",
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
              child: Visibility(
                visible: isLogin,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewBlogPost(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMyPets() {
    return Column(
      children: [
        _myPetsUpperBar(),
        const SizedBox(height: 30),
        _myPetsSituation(),
      ],
    );
  }
  Widget _myPetsUpperBar(){
    return Container(
      height: 360,
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
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Baloo',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  print("Clicked ADD");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewPet(),
                    ),
                  );
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
                    fontFamily: 'Baloo',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 10),
          petCard(context),
        ],
      ),
    );
  }
  Widget _myPetsSituation(){
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(width: 30),
            Text(
              " Durum",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        infoCard(context),
      ],
    );
  }

  Widget _buildProfile() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 20),
            _profileButtons(),
          ],
        ),
      ),
    );
  }
  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: brown,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl!)
                      : const AssetImage('assets/images/kediIcon.png') as ImageProvider<Object>,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name $surname",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "@$userName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVet! ? "Veteriner" : "Evcil Hayvan Sahibi",
                      style: TextStyle(
                        fontSize: 16,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: about ?? ""));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hakkında kopyalandı'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      about ?? "No information provided",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
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
  Widget _profileButtons(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        profileButton(
          'Profil Fotoğrafı',
          'Profil resmini değiştir',
          const Icon(Icons.person_outline_outlined, color: Colors.white),
          0,
          context,
          refreshProfilePhoto
        ),
        const SizedBox(height: 30),
        profileButton(
            'İsim',
            'Görünür ismi değiştir',
            const Icon(Icons.person_outline, color: Colors.white),
            0,
          context,
          refreshName
        ),
        const SizedBox(height: 30),
        profileButton(
            'Soyisim',
            'Görünür soyismi değiştir',
            const Icon(Icons.person_outline, color: Colors.white),
            0,
          context,
          refreshSurname
        ),
        const SizedBox(height: 30),
        profileButton(
            "Hakkında",
            "Hakkında kısmını değiştir",
            const Icon(Icons.info_outlined, color: Colors.white),
          0,
          context,
          refreshAbout
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
        profileButton(
            'Çıkış',
            'Hesaptan çıkış yap',
            const Icon(Icons.exit_to_app, color: Colors.white),
            1,
          context,
          refreshProfilePhoto
        ),
        const SizedBox(height: 30),
        profileButton(
          'Hesabı Sil',
          'Hesabı kalıcı bir şekilde sil',
          const Icon(Icons.cancel_presentation_sharp, color: Colors.white),
          1,
          context,
          refreshProfilePhoto
        ),
        const SizedBox(height: 30),
      ],
    );
  }
  void refreshProfilePhoto(String newUrl) {
    setState(() {
      profilePictureUrl = newUrl;
    });
  }
  void refreshName(String newName){
    setState(() {
      name = newName;
    });
  }
  void refreshSurname(String newSurname){
    setState(() {
      surname = newSurname;
    });
  }
  void refreshAbout(String newAbout){
    setState(() {
      about = newAbout;
    });
  }

  Widget _buildNotLogin() {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/notLoginPageDesign.png',
            fit: BoxFit.cover,
            width: double.infinity,
            alignment: Alignment.topCenter,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Bu alanı görmek için giriş yapmanız gerekiyor',
                  style: TextStyle(
                    fontSize: 18,
                    color: brown,
                    fontFamily: 'Baloo'
                    // fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                      )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                    'Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Baloo'
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class ChatBubble extends StatelessWidget {
  final String message;
  final List<Map<String, String>> messages;
  final bool isUserMessage;
  final TextEditingController controller;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
    required this.controller,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    String displayMessage = message.length > 200 ? "${message.substring(0, 200)}..." : message;

    return GestureDetector(
      onTap: isUserMessage
          ? (){
            controller.text = message;
          }
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RespondPage(respond: message, prompt: messages[0]['message'] ?? ""),
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
        child: MarkdownBody(
          data: displayMessage,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

