import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/appColors.dart';

class BlogProfile extends StatefulWidget {
  String? blogID;
  var user;
  BlogProfile({super.key, required this.blogID, required this.user});

  @override
  State<BlogProfile> createState() => _BlogProfileState();
}

class _BlogProfileState extends State<BlogProfile> {
  String profileUrl = "";
  String title = "";
  String text = "";
  int like = 0;

  String? get blogID => widget.blogID;
  get user => widget.user;

  @override
  void initState() {
    print("AAAAAAAAAAAAA");
    super.initState();
    _getBlogData(blogID!);
  }

  Future<void> _getBlogData(String blogID) async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('blogPosts')
        .doc(blogID)
        .get();

    if (snapshot.exists) {
      setState(() {
        // profileUrl = snapshot['profilePicture'];
        title = snapshot['title'];
        text = snapshot['text'];
        like = snapshot['like'];
        // print("DFİSDLFİSDLFSİŞD $title");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
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
                  Container(
                    width: 300,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Baloo',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // TODO: IMAGE ADDING
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: cream,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: brown, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/kediIcon.png',
                            image: user['profilePicture'],
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
                          user['userName'],
                          style: const TextStyle(
                              fontFamily: 'Baloo'
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 25),
              const Text(
                "Yorumlar",
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16
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
                "12", // TODO: CONNECT WITH FIREBASE!
                style: const TextStyle(
                  fontFamily: 'Baloo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
