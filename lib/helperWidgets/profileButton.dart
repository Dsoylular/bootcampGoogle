import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../auth.dart';
import '../pages/login_register_page.dart';

Widget profileButton(String name, String explanation, Icon icon, int type, BuildContext context, Function(String) refresh) {
  final Size screenSize = MediaQuery.of(context).size;
  return ElevatedButton(
    onPressed: () async{
      if(name == 'Profil Fotoğrafı'){
        print('Profil fotoğrafı');
        updateProfilePicture(context, refresh);
      }
      else if(name == 'İsim'){
        print('isim');
        _updateName(context, refresh);
      }
      else if(name == 'Soyisim'){
        print('soyisim');
        _updateSurname(context, refresh);
      }
      else if(name == 'Hakkında'){
        print('hakkında');
        _updateAbout(context, refresh);
      }
      else{
        print("object");
        await Auth().signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
              (Route<dynamic> route) => false,
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: type == 0 ? darkBlue : pink,
      fixedSize: Size(screenSize.width * 0.85, 50),
      elevation: 8
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                explanation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<String?> updateProfilePicture(BuildContext context, Function(String) refreshProfilePhoto) async {
  try {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);

    String? imageUrl = await showDialog<String?>(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (BuildContext context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Ön Gösterim"),
              content: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
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
                if (!isLoading)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text(
                      "İptal",
                      style: TextStyle(
                        color: darkBlue,
                      ),
                    ),
                  ),
                if (!isLoading)
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      String? imageUrl = await uploadAndCropImage(imageFile);

                      setState(() {
                        isLoading = false;
                      });

                      if (imageUrl != null) {
                        refreshProfilePhoto(imageUrl);
                        Navigator.of(context).pop(imageUrl);
                      } else {
                        Navigator.of(context).pop(null);
                      }
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
      },
    );

    return imageUrl;
  } catch (e) {
    print("Error updating profile picture: $e");
    return null;
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
        // BE CAREFUL USER HAS TO BE INITIALIZED - BERK
        Reference ref = FirebaseStorage.instance.ref().child('profile_pictures').child(user?.uid ?? "");
        UploadTask uploadTask = ref.putData(imageData);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        // Get download URL of uploaded image
        String imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
          'pictureURL': imageUrl,
        });

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


Future<void> _updateName(BuildContext context, Function(String) refreshName) async {
  TextEditingController nameController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('İsmini değiştir'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: nameController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'İsim',
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: brown),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: brown)
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Gönder',
              style: TextStyle(
                color: brown,
              ),
            ),
            onPressed: () async {
              String newName = nameController.text;
              print('Yeni isim $newName');
              if((newName.compareTo("") != 0) && newName.trim().isNotEmpty) {
                await _updateNameInFirebase(newName);
                Navigator.of(context).pop();
                refreshName(newName);
              }
            },
          ),
        ],
      );
    },
  );
}
Future<void> _updateNameInFirebase(String newName) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'firstName': newName,
      });
      print('Name updated successfully in Firebase.');
    }
  } catch (e) {
    print('Error updating name in Firebase: $e');
  }
}

Future<void> _updateSurname(BuildContext context, Function(String) refreshSurname) async{
  TextEditingController surnameEditor = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Soyismini değiştir'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: surnameEditor,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Soyisim',
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: brown),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: brown)
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Gönder',
              style: TextStyle(
                color: brown,
              ),
            ),
            onPressed: () async {
              String newSurname = surnameEditor.text;
              print('Yeni isim $newSurname');
              if((newSurname.compareTo("") != 0) && newSurname.trim().isNotEmpty) {
                await _updateSurnameInFirebase(newSurname);
                Navigator.of(context).pop();
                refreshSurname(newSurname);
              }
            },
          ),
        ],
      );
    },
  );
}
Future<void> _updateSurnameInFirebase(String newSurname) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'lastName': newSurname,
      });
      print('Surname updated successfully in Firebase.');
    }
  } catch (e) {
    print('Error updating surname in Firebase: $e');
  }
}

Future<void> _updateAbout(BuildContext context, Function(String) refreshAbout) async {
  TextEditingController aboutController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Hakkında bilgini değiştir'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: aboutController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Hakkında',
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: brown),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: brown)
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Gönder',
              style: TextStyle(
                color: brown,
              ),
            ),
            onPressed: () async {
              String newAbout = aboutController.text;
              print('Yeni isim $newAbout');
              if((newAbout.compareTo("") != 0) && newAbout.trim().isNotEmpty) {
                await _updateAboutInFirebase(newAbout);
                Navigator.of(context).pop();
                refreshAbout(newAbout);
              }
            },
          ),
        ],
      );
    },
  );
}
Future<void> _updateAboutInFirebase(String newAbout) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'description': newAbout,
      });
      print('Name updated successfully in Firebase.');
    }
  } catch (e) {
    print('Error updating name in Firebase: $e');
  }
}