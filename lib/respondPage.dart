import 'package:bootcamp_google/helperWidgets/myAppBar.dart';
import 'package:flutter/material.dart';

import 'helperWidgets/appColors.dart';

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
      appBar: appBar(context),
      body: Column(
        children: [
          Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  height: 500,
                  width: 300,
                  decoration: BoxDecoration(
                    color: darkBlue.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    border: Border.all(color: brown),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Text(
                        respond,
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontFamily: 'Baloo',
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    IconButton(
                      onPressed: (){
                        //TODO: ADD FUNCTIONALITY
                      },
                      icon: const Icon(
                        Icons.save,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        // TODO: ADD FUNCTIONALITY
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink.withOpacity(0.8),
              fixedSize: const Size(300, 50),
            ),
            onPressed: (){

            },
            child: const Text(
              "Tekrar Sor",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Baloo',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}