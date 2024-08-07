import 'dart:developer';
import 'dart:io';

import 'package:bootcamp_google/helperFiles/my_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import '../helperFiles/photo_add_functions.dart';

class NewBlogPost extends StatefulWidget {
  const NewBlogPost({super.key});

  @override
  _NewBlogPostState createState() => _NewBlogPostState();
}

class _NewBlogPostState extends State<NewBlogPost> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? selectedImageFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    log("new_blog_post");
    return Scaffold(
      appBar: appBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectBlogImage(context);
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
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: brown, width: 2.0),
                    ),
                    filled: true,
                    fillColor: cream,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'İçerik',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
                  onPressed: _isLoading ? null : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    if (_titleController.text.isEmpty) {
                      _showSnackBar("Başlık boş olamaz!", Colors.red);
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    } else if (_contentController.text.isEmpty) {
                      _showSnackBar("İçerik boş olamaz!", Colors.red);
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    }

                    User? currentUser = _auth.currentUser;
                    String? photoURL;

                    if (selectedImageFile != null) {
                      photoURL = await uploadAndCropBlogImage(selectedImageFile!);
                    }

                    var docRef = await FirebaseFirestore.instance.collection('blogPosts').add({
                      'title': _titleController.text,
                      'text': _contentController.text,
                      'author': currentUser?.uid.toString(),
                      'pictureURL': photoURL ?? "",
                      'like': 0,
                      'likedPeople': [],
                      'blogId': '',
                      'isVet': false,
                      'timestamp': Timestamp.now(),
                    });

                    await docRef.update({'blogId': docRef.id});
                    _navPop();

                    setState(() {
                      _isLoading = false;
                    });
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
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: pink,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectBlogImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      File imageFile = File(pickedFile.path);
      selectedImageFile = imageFile;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Ön Gösterim",
              style: TextStyle(fontFamily: 'Baloo'),
            ),
            content: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "İptal",
                  style: TextStyle(
                    color: darkBlue,
                    fontFamily: 'Baloo',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _showSnackBar("Fotoğraf Eklendi", Colors.green);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Seç",
                  style: TextStyle(
                    color: darkBlue,
                    fontFamily: 'Baloo',
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      log("Error selecting image: $e");
    }
  }

  void _navPop() {
    Navigator.pop(context);
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        backgroundColor: color,
      ),
    );
  }
}
