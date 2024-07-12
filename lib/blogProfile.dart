import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/appColors.dart';
import 'helperWidgets/myAppBar.dart'; // Assuming you have a custom app bar implementation

class BlogProfile extends StatefulWidget {
  final String? blogID;
  final dynamic user;

  BlogProfile({Key? key, required this.blogID, required this.user}) : super(key: key);

  @override
  State<BlogProfile> createState() => _BlogProfileState();
}

class _BlogProfileState extends State<BlogProfile> {
  String profileUrl = ""; // Unused for now
  String title = "";
  String text = "";
  int like = 0;
  List<dynamic> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getBlogData(widget.blogID!);
    _getComments(widget.blogID!);
  }

  Future<void> _getBlogData(String blogID) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('blogPosts')
        .doc(blogID)
        .get();

    if (snapshot.exists) {
      setState(() {
        title = snapshot['title'];
        text = snapshot['text'];
        like = snapshot['like'];
      });
    }
  }

  Future<void> _getComments(String blogID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('blogPosts')
        .doc(blogID)
        .collection('comments')
        .get();

    setState(() {
      comments = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Assuming FirebaseAuth.instance.currentUser is used to get current user

  Future<void> _addComment(String blogID, String commentText) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    await FirebaseFirestore.instance
        .collection('blogPosts')
        .doc(blogID)
        .collection('comments')
        .add({
      'commentText': commentText,
      'profilePicture': snapshot['profilePicture'],
      'userName': snapshot['userName'],
    });

    commentController.clear();
    _getComments(blogID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context), // Custom app bar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
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
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: darkBlue,
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Baloo',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: brown, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/kediIcon.png',
                              image: widget.user['profilePicture'],
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
                            widget.user['userName'],
                            style: const TextStyle(fontFamily: 'Baloo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(text),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  const Text(
                    "Yorumlar",
                    style: TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/chat.png',
                    fit: BoxFit.cover,
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    comments.length.toString(),
                    style: const TextStyle(
                      fontFamily: 'Baloo',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                // Check if profilePicture and userName are not null
                String profilePictureUrl = comments[index]['profilePicture'] ?? 'assets/images/default_profile.png';
                String userName = comments[index]['userName'] ?? 'Anonymous';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/kediIcon.png',
                              image: profilePictureUrl,
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
                            userName,
                            style: const TextStyle(fontFamily: 'Baloo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comments[index]['commentText']),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Yorumunuzu girin...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        _addComment(widget.blogID!, commentController.text);
                      }
                    },
                    child: const Text('Yorum Yap'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
