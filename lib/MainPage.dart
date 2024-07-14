import 'dart:math';

import 'package:bootcamp_google/blogProfile.dart';
import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:bootcamp_google/helperWidgets/geminiCodes.dart';
import 'package:bootcamp_google/helperWidgets/infoCards.dart';
import 'package:bootcamp_google/helperWidgets/petCard.dart';
import 'package:bootcamp_google/helperWidgets/profileButton.dart';
import 'package:bootcamp_google/newBlogPost.dart';
import 'package:bootcamp_google/newPet.dart';
import 'package:bootcamp_google/respondPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'helperWidgets/myAppBar.dart';



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
  String? curUserId;
  bool? isVet;
  bool _isLoading = false;
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
          curUserId = currentUser.uid.toString();
          print(profilePictureUrl);
          print(isVet);
          print(name);
        });
      }
    }
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
                    isUserMessage: message['type'] == 'user',
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
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      //TODO: FILL THIS BUTTON
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
    return await talkWithGemini(message);
  }


  Widget _buildJournal() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                String profilePicture = user['profilePicture'];
                String username = user['userName'];

                // Fetch the length of the 'comments' collection
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
                                  if (post['isVet']) ...[
                                    const SizedBox(width: 5),
                                    const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                                  ],
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if (post['likedPeople'] != null && !post['likedPeople'].contains(curUserId)) {
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
                                      } else {
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  print("Clicked ADD"); // TODO: Connect with backend
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
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 10),
          PetCard(context),
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
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        InfoCard(context),
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
  Widget _profileHeader(){
    return Container(
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
          context
        ),
        const SizedBox(height: 30),
        profileButton(
            'İsim',
            'Görünür ismi değiştir',
            const Icon(Icons.person_outline, color: Colors.white),
            0,
          context
        ),
        const SizedBox(height: 30),
        profileButton(
            'Soyisim',
            'Görünür soyismi değiştir',
            const Icon(Icons.person_outline, color: Colors.white),
            0,
          context
        ),
        const SizedBox(height: 30),
        profileButton(
            "Hakkında",
            "Hakkında kısmını değiştir",
            const Icon(Icons.info_outlined, color: Colors.white),
          0,
          context
        ),
        // const SizedBox(height: 30),
        // profileButton(
        //     'Şifre',
        //     'Şifreyi değiştir',
        //     const Icon(Icons.key_outlined, color: Colors.white),
        //   0,
        //   context
        // ),
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
          context
        ),
        const SizedBox(height: 30),
        profileButton(
          'Hesabı Sil',
          'Hesabı kalıcı bir şekilde sil',
          const Icon(Icons.cancel_presentation_sharp, color: Colors.white),
          1,
          context
        ),
        const SizedBox(height: 30),
      ],
    );
  }

}


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    String displayMessage = message.length > 200 ? "${message.substring(0, 200)}..." : message;

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

