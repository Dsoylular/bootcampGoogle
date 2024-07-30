import 'dart:developer';

import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> updatePetProfilePicture(BuildContext context, String petName, String petID, Function(String) refreshProfilePhoto) async {
  try {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);

    String? imageUrl = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
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

                      String? imageUrl = await uploadAndCropPetImage(imageFile, petName, petID);

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
    log("Error updating profile picture: $e");
    return null;
  }
}

Future<String?> uploadAndCropPetImage(File imageFile, String petName, String petID) async {
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

      ByteData? byteData = await croppedImage!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? imageData = byteData?.buffer.asUint8List();

      if (imageData != null) {
        Reference ref = FirebaseStorage.instance.ref().child('pet_photos').child(petName);
        UploadTask uploadTask = ref.putData(imageData);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        String imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('pets').doc(petID).update({
          'petImage': imageUrl,
        });

        return imageUrl;
      }
    }
  } catch (e) {
    log("Error uploading and cropping image: $e");
  }
  return null;
}


Future<void> addNewBlogPicture(BuildContext context) async {
  File? selectedImageFile;

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
          title: const Text(
              "Ön Gösterim",
            style: TextStyle(
              fontFamily: 'Baloo'
            ),
          ),
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
                  fontFamily: 'Baloo'
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                uploadAndCropBlogImage(selectedImageFile!);
                Navigator.of(context).pop();
              },
              child: Text(
                "Seç",
                style: TextStyle(
                  color: darkBlue,
                  fontFamily: 'Baloo'
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

Future<String?> uploadAndCropBlogImage(File imageFile) async {
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

      ByteData? byteData = await croppedImage!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? imageData = byteData?.buffer.asUint8List();

      if (imageData != null) {
        Reference ref = FirebaseStorage.instance.ref().child('blog_pictures').child(user?.uid ?? "");
        UploadTask uploadTask = ref.putData(imageData);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        String imageUrl = await snapshot.ref.getDownloadURL();

        return imageUrl;
      }
    }
  } catch (e) {
    log("Error uploading and cropping image: $e");
  }
  return null;
}

Future<String?> updateProfilePicture(BuildContext context, Function(String) refreshProfilePhoto) async {
  try {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);

    String? imageUrl = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
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
    log("Error updating profile picture: $e");
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

      ByteData? byteData = await croppedImage!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? imageData = byteData?.buffer.asUint8List();

      if (imageData != null) {
        Reference ref = FirebaseStorage.instance.ref().child('profile_pictures').child(user?.uid ?? "");
        UploadTask uploadTask = ref.putData(imageData);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        String imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
          'pictureURL': imageUrl,
        });

        return imageUrl;
      }
    }
  } catch (e) {
    log("Error uploading and cropping image: $e");
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