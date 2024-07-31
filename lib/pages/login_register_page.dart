import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helperFiles/auth.dart';
import '../helperFiles/app_colors.dart';
import '../loading_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _isPasswordVisible = false;
  bool _isVet = false;

  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      String email = _controllerEmail.text.trim();
      String password = _controllerPassword.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          errorMessage = 'Email ve şifre boş olamaz.';
        });
        return;
      }

      await Auth().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      navPushRep();
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException {
      setState(() {
        errorMessage = "Mail veya şifre hatalı!";
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      String confirmPassword = _controllerConfirmPassword.text.trim();
      String email = _controllerEmail.text.trim();
      String password = _controllerPassword.text.trim();
      String firstName = _controllerFirstName.text.trim();
      String lastName = _controllerLastName.text.trim();
      String userName = _controllerUserName.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          errorMessage = 'Email ve şifre boş olamaz.';
        });
        return;
      }

      if (password != confirmPassword) {
        setState(() {
          errorMessage = 'Şifreler eşleşmiyor.';
        });
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'pictureURL': '',
        'description': '',
        'isVet': _isVet,
        'pets': [],
      });

      navPushRep();
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException {
      setState(() {
        errorMessage = "Mail veya şifre hatalı!";
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        errorMessage = "Bir hata oluştu, lütfen tekrar deneyin.";
      });
    }
  }


  Widget _title() {
    return Row(
      children: [
        const SizedBox(width: 30),
        Text(
          isLogin ? 'Hesabınıza giriş yapınız:' : 'Yeni hesap oluşturun:',
          style: const TextStyle(fontSize: 18, fontFamily: 'Baloo'),
        ),
      ],
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: brown)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: brown)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        errorMessage == '' ? '' : 'Hata: $errorMessage',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: pink,
        ),
        child: Text(
          isLogin ? 'Giriş Yap' : 'Kayıt Ol',
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo',
              fontSize: 16),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: isLogin ? 'Hesabın yok mu? ' : 'Zaten hesabınız var mı? ',
              style: const TextStyle(color: Colors.black, fontFamily: 'Baloo'),
            ),
            TextSpan(
              text: isLogin ? 'Kayıt ol!' : 'Giriş yap!',
              style: TextStyle(color: darkBlue, fontFamily: 'Baloo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vetCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Checkbox(
            activeColor: pink,
            value: _isVet,
            onChanged: (newValue) {
              setState(() {
                _isVet = newValue!;
              });
            },
          ),
          const Text(
            'Veteriner misiniz?',
            style: TextStyle(fontSize: 16, fontFamily: 'Baloo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [darkBlue, darkBlue.withOpacity(0.8)],
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
                  SizedBox(height: 160),
                  Text(
                    "Pawdi",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Baloo',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            _title(),
            const SizedBox(height: 10),
            _entryField('Email', _controllerEmail),
            if (!isLogin) ...[
              const SizedBox(height: 10),
              _entryField('Kullanıcı Adı', _controllerUserName),
              const SizedBox(height: 10),
              _entryField('First Name', _controllerFirstName),
              const SizedBox(height: 10),
              _entryField('Last Name', _controllerLastName),
            ],
            const SizedBox(height: 10),
            _entryField('Password', _controllerPassword, isPassword: true),
            if (!isLogin) ...[
              const SizedBox(height: 10),
              _entryField('Confirm Password', _controllerConfirmPassword,
                  isPassword: true),
            _vetCheckbox(),
            ],
            _errorMessage(),
            const SizedBox(height: 10),
            _submitButton(),
            const SizedBox(height: 10),
            _loginOrRegisterButton(),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingScreen()
                  ),
                );
              },
              child: const Text(
                "Giriş yapmadan devam et",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Baloo'
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void navPushRep() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoadingScreen()),
    );
  }
}
