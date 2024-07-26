import 'dart:developer';

import 'package:bootcamp_google/helperFiles/app_colors.dart';
import 'package:bootcamp_google/helperFiles/photo_add_functions.dart';
import 'package:bootcamp_google/helperFiles/profile_button_firebase_functions.dart';
import 'package:flutter/material.dart';


import 'auth.dart';
import '../pages/login_register_page.dart';

Widget profileButton(String name, String explanation, Icon icon, int type, BuildContext context, Function(String) refresh) {
  final Size screenSize = MediaQuery.of(context).size;
  return ElevatedButton(
    onPressed: () async{
      if(name == 'Profil Fotoğrafı'){
        log('Profil fotoğrafı değiştiriliyor');
        updateProfilePicture(context, refresh);
      }
      else if(name == 'İsim'){
        log('İsim değiştiriliyor');
        _updateName(context, refresh);
      }
      else if(name == 'Soyisim'){
        log('Soyisim değiştiriliyor');
        _updateSurname(context, refresh);
      }
      else if(name == 'Hakkında'){
        log('Hakkında değiştiriliyor');
        _updateAbout(context, refresh);
      }
      else{
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

Future<void> _updateName(BuildContext context, Function(String) refreshName) async {
  TextEditingController nameController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(nameController, context, 'İsmini değiştir', 'İsim', refreshName, updateNameInFirebase);
    },
  );
}

Future<void> _updateSurname(BuildContext context, Function(String) refreshSurname) async{
  TextEditingController surnameController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(surnameController, context, 'Soyismini değiştir', 'Soyisim', refreshSurname, updateSurnameInFirebase);
    },
  );
}

Future<void> _updateAbout(BuildContext context, Function(String) refreshAbout) async {
  TextEditingController aboutController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(aboutController, context, "Hakkında bilgini değiştir", "Hakkında", refreshAbout, updateAboutInFirebase);
    },
  );
}

Widget customAlertDialog(
    TextEditingController controller,
    BuildContext context,
    String title,
    String hintText,
    Function(String) refreshInfo,
    Future <void> Function(String) updateFirebase,
    ){
  return AlertDialog(
    title: Text(title),
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
          String newInfo = controller.text;
          log('Yeni bilgi $newInfo');
          if((newInfo.compareTo("") != 0) && newInfo.trim().isNotEmpty) {
            await updateFirebase(newInfo);
            Navigator.of(context).pop();
            refreshInfo(newInfo);
          }
        },
      ),
    ],
  );
}

