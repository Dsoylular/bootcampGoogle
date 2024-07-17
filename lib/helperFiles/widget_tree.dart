import 'package:bootcamp_google/MainPage.dart';
import 'package:bootcamp_google/helperFiles/auth.dart';
import 'package:bootcamp_google/loadingPage.dart';
import 'package:bootcamp_google/pages/home_page.dart';
import 'package:bootcamp_google/pages/login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const LoadingScreen();
          } else {
            return const LoginPage();
          }
        }
    );
  }
}
