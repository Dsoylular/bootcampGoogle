import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/appColors.dart'; // Ensure you have imported your app-specific colors

class NewBlogPost extends StatefulWidget {
  const NewBlogPost({super.key});

  @override
  _NewBlogPostState createState() => _NewBlogPostState();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement photo upload functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightBlue,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Fotoğraf Ekle",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Baloo',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Başlık',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'İçerik',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: brown, width: 2.0),
                ),
                filled: true,
                fillColor: cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                User? currentUser = _auth.currentUser;
                var docRef = await FirebaseFirestore.instance.collection('blogPosts').add({
                  'title': _titleController.text,
                  'text': _contentController.text,
                  'author': currentUser?.uid.toString(),
                  'pictureURL': '',
                  'like': 0,
                  'likedPeople': [],
                  'comments': [],
                  'blogId': '',
                  'isVet': false,
                  'timestamp': Timestamp.now(),
                });
                await docRef.update({'blogId': docRef.id});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Oluştur",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Baloo',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
