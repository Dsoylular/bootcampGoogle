import 'dart:developer' as developer;
import 'dart:math';

import 'package:bootcamp_google/blogFiles/blog_profile.dart';
import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:bootcamp_google/helperFiles/gemini_codes.dart';
import 'package:bootcamp_google/myPetFiles/myPetHelperFiles/info_cards.dart';
import 'package:bootcamp_google/myPetFiles/myPetHelperFiles/pet_card.dart';
import 'package:bootcamp_google/profileFiles/profile_button.dart';
import 'package:bootcamp_google/myPetFiles/new_pet.dart';
import 'package:bootcamp_google/pages/login_register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'askMeFiles/chat_bubble.dart';
import 'askMeFiles/saved_chats.dart';
import 'blogFiles/new_blog_post.dart';
import 'helperFiles/my_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'type': 'user', 'message': 'Aklınızdaki soruyu sorun.'},
    {'type': 'response', 'message': 'Cevabını yapay zekadan alın!'}
  ];
  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;
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
  bool isLogin = false;
  bool petChosen = false;

  Map<String, String> userPets = {};
  Map<String, String> petsID = {};
  Map<String, String> petsPicture = {};

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
          ? _buildBlog()
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
      controller: _scrollController,
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
                  fontFamily: 'Baloo',
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: cream,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      width: screenWidth,
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
              width: screenWidth,
              alignment: Alignment.topCenter,
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "    Sor Bana    ",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Pacifico',
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
                border: Border.all(color: brown),
              ),
              child: ListTile(
                title: Text(question, style: const TextStyle(fontWeight: FontWeight.w300)),
                onTap: () {
                  _messageController.text = question;
                  _scrollController.jumpTo(0);
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
                : Stack(
              children: [
                ListView.builder(
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
                Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.collections_bookmark,
                    ),
                    onPressed: () {
                      developer.log("Directing to saved chats");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedChats(),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                  if(isLogin)...[
                    (!petChosen) ? Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            _showPetSelectionMenu(context);
                          },
                        ),
                      ],
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
                  developer.log('Selected pet: $pet');
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



  Widget _buildBlog() {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isLogin) SizedBox(height: screenSize.height * 0.05),
            _blogUpperDesign(screenSize),
            _blogPosts(),
          ],
        ),
      ),
    );
  }
  Widget _blogUpperDesign(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.02),
      child: Container(
        height: screenSize.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkBlue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(screenSize.width * 0.07),
        ),
        child: Row(
          children: [
            Container(
              width: screenSize.width * 0.6,
              height: double.infinity,
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(screenSize.width * 0.07),
              ),
              child: const Center(
                child: Text(
                  "PawBlog",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.02),
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
                    padding: EdgeInsets.all(screenSize.width * 0.03),
                    backgroundColor: pink,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _blogPosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blogPosts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Hiçbir blog yazısı bulunmamakta'));
        }
        final blogPosts = snapshot.data!.docs;
        final screenSize = MediaQuery.of(context).size;

        return Column(
          children: blogPosts.map((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final userId = post['author'];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                      padding: EdgeInsets.all(screenSize.width * 0.03),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                        ),
                                      );
                                    },
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/kediIcon.png',
                                        image: profilePicture,
                                        fit: BoxFit.cover,
                                        width: screenSize.width * 0.1,
                                        height: screenSize.width * 0.1,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/kediIcon.png',
                                            fit: BoxFit.cover,
                                            width: screenSize.width * 0.1,
                                            height: screenSize.width * 0.1,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          username,
                                          style: TextStyle(
                                            fontFamily: 'Baloo',
                                            fontSize: screenSize.width * 0.04,
                                          ),
                                        ),
                                        if (isVet) ...[
                                          const SizedBox(height: 2),
                                          const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!isLogin) return;
                                      bool liked = post['likedPeople']?.contains(curUserId) ?? false;
                                      setState(() {
                                        post['like'] += liked ? -1 : 1;
                                        if (liked) {
                                          post['likedPeople'].remove(curUserId);
                                        } else {
                                          post['likedPeople'].add(curUserId);
                                        }
                                      });
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('blogPosts')
                                            .doc(doc.id)
                                            .update({
                                          'like': FieldValue.increment(liked ? -1 : 1),
                                          'likedPeople': liked ? FieldValue.arrayRemove([curUserId]) : FieldValue.arrayUnion([curUserId]),
                                        });
                                      } catch (e) {
                                        developer.log('Error updating like count: $e');
                                        setState(() {
                                          post['like'] += liked ? 1 : -1;
                                          if (liked) {
                                            post['likedPeople'].add(curUserId);
                                          } else {
                                            post['likedPeople'].remove(curUserId);
                                          }
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_up, color: post['likedPeople'].contains(curUserId) ? Colors.blue : Colors.grey, size: 22),
                                        const SizedBox(width: 5),
                                        Text(
                                          post['like'].toString(),
                                          style: TextStyle(
                                            fontFamily: 'Baloo',
                                            fontSize: screenSize.width * 0.04,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                            ),
                                          );
                                        },
                                        child: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 22),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        commentsLength.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Baloo',
                                          fontSize: screenSize.width * 0.04,
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
                                    fontSize: screenSize.width * 0.05,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogProfile(blogID: post['blogId'], user: user),
                                    ),
                                  );
                                },
                                child: Text(
                                  "${post['text'].toString().substring(0, min(100, post['text'].toString().length))}...",
                                  style: TextStyle(
                                    fontFamily: 'Baloo',
                                    fontSize: screenSize.width * 0.035,
                                    color: Colors.black87,
                                  ),
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




  Widget _buildMyPets() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _myPetsUpperBar(),
          const SizedBox(height: 30),
          _myPetsSituation(),
        ],
      ),
    );
  }
  Widget _myPetsUpperBar(){
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cream.withOpacity(0.6),
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
                  fontFamily: 'Baloo',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  developer.log("Clicked Add");
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
                  "+",
                  style: TextStyle(
                    fontSize: 24,
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
                  backgroundImage: getProfileImage(profilePictureUrl),
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
                        fontFamily: 'Baloo',
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
                        fontFamily: 'Baloo',
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVet! ? "Veteriner" : "Evcil Hayvan Sahibi",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Baloo',
                        color: brown,
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
                      about ?? "Bilgi yok!",
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
          const Icon(Icons.account_circle, color: Colors.white),
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
            'Kullanıcı İsmi',
            'Kullanıcı ismini değiştir',
            const Icon(Icons.edit, color: Colors.white),
            0,
          context,
          refreshUserName
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
            SizedBox(width: 40),
            Text(
              "Ek Alanlar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        profileButton(
            'Pawdi Hakkında',
            '',
            const Icon(Icons.pets, color: Colors.white),
            1,
          context,
          refreshProfilePhoto
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
  void refreshUserName(String newUserName){
    setState(() {
      userName = newUserName;
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

getProfileImage(String? profilePictureUrl) {
  if(profilePictureUrl != null && profilePictureUrl != ""){
    try{
      return NetworkImage(profilePictureUrl);
    }
    catch(e){
      return const AssetImage('assets/images/kediIcon.png') as ImageProvider<Object>;
    }
  }
  return const AssetImage('assets/images/kediIcon.png') as ImageProvider<Object>;
}
