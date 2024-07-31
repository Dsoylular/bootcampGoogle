import 'package:bootcamp_google/askMeFiles/respond_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../helperFiles/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final List<Map<String, String>> messages;
  final TextEditingController controller;
  final bool isUserMessage;

  const ChatBubble({
    super.key,
    required this.isUserMessage,
    required this.controller,
    required this.messages,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    String displayMessage = message.length > 200 ? "${message.substring(0, 200)}..." : message;

    return GestureDetector(
      onTap: isUserMessage
          ? (){
        controller.text = message;
      }
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RespondPage(respond: message, prompt: messages[0]['message'] ?? ""),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? pink.withOpacity(0.9) : darkBlue.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUserMessage ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUserMessage ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: MarkdownBody(
          data: displayMessage,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo',
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
