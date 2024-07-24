import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet(
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
);
