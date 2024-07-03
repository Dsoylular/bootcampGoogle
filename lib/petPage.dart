import 'package:bootcamp_google/appColors.dart';
import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:flutter/material.dart';

class petPage extends StatefulWidget {
  const petPage({super.key});

  @override
  State<petPage> createState() => _petPageState();
}

class _petPageState extends State<petPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
