import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateNameInFirebase(String newName) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'firstName': newName,
      });
      log('Name updated successfully in Firebase.');
    }
  } catch (e) {
    log('Error updating name in Firebase: $e');
  }
}

Future<void> updateSurnameInFirebase(String newSurname) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'lastName': newSurname,
      });
      log('Surname updated successfully in Firebase.');
    }
  } catch (e) {
    log('Error updating surname in Firebase: $e');
  }
}


Future<void> updateAboutInFirebase(String newAbout) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'description': newAbout,
      });
      log('Name updated successfully in Firebase.');
    }
  } catch (e) {
    log('Error updating name in Firebase: $e');
  }
}