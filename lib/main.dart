import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDSWWPj1HyObKzcFiX8bxrj8DZKVbwsj20',
        appId: '1:1017078231894:android:31ae43efc865360b5fdcf7',
        messagingSenderId: '1017078231894',
        projectId: 'pawdi-7b40f',
        storageBucket: 'pawdi-7b40f.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}