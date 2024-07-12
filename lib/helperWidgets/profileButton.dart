import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../pages/login_register_page.dart';

Widget profileButton(String name, String explanation, Icon icon, int type, BuildContext context) {
  return ElevatedButton(
    onPressed: () async{
      if(name == 'İsim'){
        print('isim');
        _updateName(context);
      }
      else if(name == 'Soyisim'){
        print('soyisim');
        _updateSurname(context);
      }
      else if(name == 'Hakkında'){
        print('hakkında');
        _updateAbout(context);
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
      fixedSize: const Size(300, 50),
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

Future<void> _updateName(BuildContext context) async {
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

Future<void> _updateSurname(BuildContext context) async{
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

Future<void> _updateAbout(BuildContext context) async {
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