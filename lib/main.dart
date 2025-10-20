import 'package:flutter/material.dart';
import 'screens/blackjack_screen.dart';

void main() => runApp(BlackjackApp());

class BlackjackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack 21',
      home: BlackjackScreen(),
    );
  }
}
