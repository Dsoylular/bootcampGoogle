import 'dart:developer';

import 'package:bootcamp_google/MainPage.dart';
import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:bootcamp_google/helperFiles/photo_add_functions.dart';
import 'package:bootcamp_google/helperFiles/profile_button_firebase_functions.dart';
import 'package:flutter/material.dart';

import '../profileFiles/PawdiInfo.dart';
import 'auth.dart';
import '../pages/login_register_page.dart';

Widget profileButton(String name, String explanation, Icon icon, int type, BuildContext context, Function(String) refresh) {
  final Size screenSize = MediaQuery.of(context).size;
  return ElevatedButton(
    onPressed: () async {
      if (name == 'Profil Fotoğrafı') {
        log('Profil fotoğrafı değiştiriliyor');
        updateProfilePicture(context, refresh);
      } else if (name == 'İsim') {
        log('İsim değiştiriliyor');
        _updateName(context, refresh);
      } else if (name == 'Soyisim') {
        log('Soyisim değiştiriliyor');
        _updateSurname(context, refresh);
      } else if (name == 'Hakkında') {
        log('Hakkında değiştiriliyor');
        _updateAbout(context, refresh);
      } else if (name == 'Hesabı Sil') {
        log('Hesap Siliniyor');
        _confirmDeleteAccount(context);
      }
      else if(name == 'Kullanıcı İsmi'){
        log('Kullanıcı ismi değiştiriliyor');
        _updateUserName(context, refresh);
      }
      else if(name == "Pawdi Hakkında"){
        log('Pawdi Hakkında');
        _showPawdiInfo(context);
      }
      else {
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
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
                  fontFamily: 'Baloo'
                ),
              ),
              Text(
                explanation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Baloo'
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showPawdiInfo(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PawdiInfo())
  );
}

Future<void> _updateUserName(BuildContext context, Function(String) refreshUsername) {
  TextEditingController userNameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(
          controller: userNameController,
          context: context,
          title: 'Kullanıcı Adını Değiştir',
          hintText: 'Kullanıcı İsmi',
          refreshInfo: refreshUsername,
          updateFirebase: updateUserNameInFirebase,
          maxLength: 25,
          validationFunction: (value) {
            if (value.length > 25) return 'Kullanıcı adı 25 karakterden uzun olamaz.';
            if (!RegExp(r'^[a-z]+$').hasMatch(value)) return 'Kullanıcı adı sadece küçük harflerden oluşmalıdır.';
            return null;
          }
      );
    },
  );
}

Future<void> _updateName(BuildContext context, Function(String) refreshName) async {
  TextEditingController nameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(
          controller: nameController,
          context: context,
          title: 'İsmini değiştir',
          hintText: 'İsim',
          refreshInfo: refreshName,
          updateFirebase: updateNameInFirebase,
          maxLength: 25,
          validationFunction: (value) {
            if (value.length > 25) return 'İsim 25 karakterden uzun olamaz.';
            return null;
          }
      );
    },
  );
}

Future<void> _updateSurname(BuildContext context, Function(String) refreshSurname) async {
  TextEditingController surnameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(
          controller: surnameController,
          context: context,
          title: 'Soyismini değiştir',
          hintText: 'Soyisim',
          refreshInfo: refreshSurname,
          updateFirebase: updateSurnameInFirebase,
          maxLength: 25,
          validationFunction: (value) {
            if (value.length > 25) return 'Soyisim 25 karakterden uzun olamaz.';
            return null;
          }
      );
    },
  );
}

Future<void> _updateAbout(BuildContext context, Function(String) refreshAbout) async {
  TextEditingController aboutController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(
          controller: aboutController,
          context: context,
          title: "Hakkında bilgini değiştir",
          hintText: "Hakkında",
          refreshInfo: refreshAbout,
          updateFirebase: updateAboutInFirebase,
          maxLength: 350,
          validationFunction: (value) {
            if (value.length > 350) return 'Hakkında bilgisi 350 karakterden uzun olamaz.';
            return null;
          }
      );
    },
  );
}

Future<void> _confirmDeleteAccount(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Hesabı Sil',
          style: TextStyle(
            fontFamily: 'Baloo',
          ),
        ),
        content: const Text('Hesabınızı silmek üzeresiniz. Bu işlem geri alınamaz. Emin misiniz?'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'İptal',
              style: TextStyle(
                  fontFamily: 'Baloo',
                  color: pink
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Sil',
              style: TextStyle(
                  fontFamily: 'Baloo',
                  color: pink
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAccount(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _deleteAccount(BuildContext context) async {
  try {
    final user = Auth().currentUser;
    if (user != null) {
      await user.delete();
      await Auth().signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
            (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    log('Hesap silme hatası: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Hesap silme işlemi başarısız.'),
        backgroundColor: pink,
      ),
    );
  }
}

Widget customAlertDialog({
  required TextEditingController controller,
  required BuildContext context,
  required String title,
  required String hintText,
  required Function(String) refreshInfo,
  required Future<void> Function(String) updateFirebase,
  int maxLength = 100,
  String? Function(String)? validationFunction,
}) {
  return AlertDialog(
    title: Text(title, style: const TextStyle(fontFamily: 'Baloo')),
    content: SizedBox(
      width: double.maxFinite,
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: brown),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: brown),
          ),
        ),
        maxLength: maxLength,
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text(
          'Gönder',
          style: TextStyle(
            color: pink,
            fontFamily: 'Baloo'
          ),
        ),
        onPressed: () async {
          String newInfo = controller.text;
          log('Yeni bilgi $newInfo');
          String? errorMessage = validationFunction?.call(newInfo);
          if (errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: pink,
              ),
            );
            return;
          }
          if (newInfo.trim().isNotEmpty) {
            await updateFirebase(newInfo);
            Navigator.of(context).pop();
            refreshInfo(newInfo);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Girdiğiniz bilgi boş olamaz.'),
                backgroundColor: pink,
              ),
            );
          }
        },
      ),
    ],
  );
}
