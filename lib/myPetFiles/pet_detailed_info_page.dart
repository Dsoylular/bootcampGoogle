import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../helperFiles/app_colors.dart';
import '../helperFiles/markdown_style_sheet.dart';

class PetDetailedInfoPage extends StatefulWidget {
  final String respond;

  const PetDetailedInfoPage({required this.respond, super.key});

  @override
  State<PetDetailedInfoPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<PetDetailedInfoPage> {
  String get respond => widget.respond;

  @override
  Widget build(BuildContext context) {
    log("respond_page");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cevap Detayları',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo'
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: pink,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkBlue.withOpacity(0.2), cream],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: brown),
                ),
                child: MarkdownBody(
                  data: respond,
                  styleSheet: markdownStyleSheet,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
