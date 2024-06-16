import 'package:flexible_text/flexible_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  FlexibleText text = FlexibleText(
    text: 'Hello :World:~1~',
    style: const TextStyle(color: Colors.black),
    richStyles: const [TextStyle(color: Colors.red)],
    textRecognizers: [
      TapGestureRecognizer()
        ..onTap = () {
          debugPrint('World tapped');
        }
    ],
    widgets: const [
      Icon(Icons.star),
    ],
  );
  runApp(text);
  // Will Show Hello World ⭐️
}
