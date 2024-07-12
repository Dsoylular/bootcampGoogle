import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/appColors.dart';

class NewBlogPost extends StatefulWidget {
  const NewBlogPost({super.key});

  @override
  State<NewBlogPost> createState() => _NewBlogPostState();
}

class _NewBlogPostState extends State<NewBlogPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
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
                            "Oluştur",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pacifico',
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
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightBlue,
                ),
                onPressed: (){
                  //TODO: FILL
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Fotoğraf Ekle",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Baloo',
                        color: Colors.black
                      ),
                    ),
                    SizedBox(width: 130),
                    Icon(Icons.add_photo_alternate_outlined, color: Colors.black),
                  ],
                ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 550,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      SizedBox(width: 25),
                      Text(
                          'Başlık',
                        style: TextStyle(
                          fontFamily: 'Baloo',
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: brown, width: 2),
                        color: cream,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              hintText: 'Başlığı giriniz...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      SizedBox(width: 25),
                      Text(
                        'İçerik',
                        style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 22
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        border: Border.all(color: brown, width: 2),
                        color: cream,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: 'İçeriği giriniz...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pink,
                      fixedSize: const Size(350, 50),
                    ),
                      onPressed: () async {
                        User? currentUser = _auth.currentUser;
                        await FirebaseFirestore.instance
                            .collection('blogPosts')
                            .doc("blogID") // TODO: RANDOM ID HERE
                            .set({
                          'title': _titleController.text,
                          'text': _contentController.text,
                          'author': currentUser?.uid.toString(),
                          'pictureURL': '',
                          'like': 0,
                          'comments': [],
                          'blogID': 'blogID' // TODO: RANDOM ID HERE
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Oluştur",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Baloo',
                          fontSize: 18
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
