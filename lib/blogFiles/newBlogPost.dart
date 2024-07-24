import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bootcamp_google/helperFiles/my_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewBlogPost extends StatefulWidget {
  const NewBlogPost({super.key});

  @override
  _NewBlogPostState createState() => _NewBlogPostState();
}

class _NewBlogPostState extends State<NewBlogPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  File? selectedImageFile;
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addNewPicture(context);
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

                if (selectedImageFile != null) {
                  String? photoURL = await uploadAndCropImage(selectedImageFile!);

                  if (photoURL != null) {
                    var docRef = await FirebaseFirestore.instance.collection('blogPosts').add({
                      'title': _titleController.text,
                      'text': _contentController.text,
                      'author': currentUser?.uid.toString(),
                      'pictureURL': photoURL,
                      'like': 0,
                      'likedPeople': [],
                      'blogId': '',
                      'isVet': false,
                      'timestamp': Timestamp.now(),
                    });

                    await docRef.update({'blogId': docRef.id});
                    Navigator.pop(context);
                  } else {
                    // Handle the error of image upload failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image upload failed")),
                    );
                  }
                } else {
                  // Handle the case when no image is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No image selected")),
                  );
                }
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

  Future<void> addNewPicture(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      selectedImageFile = File(pickedFile.path);

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Ön Gösterim"),
            content: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(selectedImageFile!),
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
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Seç",
                  style: TextStyle(
                    color: darkBlue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error selecting image: $e");
    }
  }

  Future<String?> uploadAndCropImage(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      ui.Image? image = await loadImage(imageFile);
      if (image != null) {
        int size = image.width < image.height ? image.width : image.height;
        ui.Rect square = ui.Rect.fromCenter(
          center: Offset(image.width / 2, image.height / 2),
          width: size.toDouble(),
          height: size.toDouble(),
        );
        ui.Image? croppedImage = await cropImage(image, square);

        // Convert cropped image to bytes
        ByteData? byteData = await croppedImage!.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? imageData = byteData?.buffer.asUint8List();

        if (imageData != null) {
          Reference ref = FirebaseStorage.instance.ref().child('blog_pictures').child(user?.uid ?? "");
          UploadTask uploadTask = ref.putData(imageData);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

          // Get download URL of uploaded image
          String imageUrl = await snapshot.ref.getDownloadURL();

          return imageUrl;
        }
      }
    } catch (e) {
      print("Error uploading and cropping image: $e");
    }
    return null;
  }

  Future<ui.Image?> loadImage(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<ui.Image?> cropImage(ui.Image image, ui.Rect cropRect) async {
    int targetWidth = cropRect.width.toInt();
    int targetHeight = cropRect.height.toInt();
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = ui.Canvas(recorder);
    canvas.drawImageRect(image, cropRect, ui.Rect.fromLTRB(0, 0, targetWidth.toDouble(), targetHeight.toDouble()), Paint());
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }
}
