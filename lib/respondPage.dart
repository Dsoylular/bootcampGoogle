import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'helperWidgets/appColors.dart';
import 'helperWidgets/myAppBar.dart';

class RespondPage extends StatefulWidget {
  final String respond;

  const RespondPage({required this.respond, super.key});

  @override
  State<RespondPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<RespondPage> {
  String get respond => widget.respond;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkBlue.withOpacity(0.2), cream],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(height: 20),
              ),
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
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Baloo',
                    ),
                    h1: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    strong: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    blockquote: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                    code: const TextStyle(
                      color: Colors.yellowAccent,
                      backgroundColor: Colors.black,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement save functionality
                    },
                    icon: Icon(
                      Icons.save,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement send functionality
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 30),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: pink.withOpacity(0.8),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              //   ),
              //   onPressed: () {
              //     // TODO: Implement "Tekrar Sor" functionality
              //   },
              //   child: Text(
              //     "Tekrar Sor",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontFamily: 'Baloo',
              //       fontSize: 18,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
