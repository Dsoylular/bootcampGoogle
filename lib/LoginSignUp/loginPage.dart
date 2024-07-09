import 'package:bootcamp_google/MainPage.dart';
import 'package:bootcamp_google/helperWidgets/appColors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [darkBlue, darkBlue.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: const Column(
              children: [
                SizedBox(height: 120),
                Text(
                    "Pawdi",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Baloo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          const Row(
            children: [
              SizedBox(width: 40),
              Text(
                "Hesabınıza giriş yapın",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 40),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ));
                  },
                  child: Text("Delete This!!!")
              ),
            ],
          ),
        ],
      ),
    );
  }
}
