import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../screens/blackjack_screen.dart'; // для DeckPatternPainter

class CardWidget extends StatelessWidget {
  final PlayingCard card;
  final Color? colorOverride;
  final bool isFaceDown;

  // Параметр для закритих карт
  final bool usePatternForBack;

  CardWidget({
    required this.card,
    this.colorOverride,
    this.isFaceDown = false,
    this.usePatternForBack = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFaceDown && usePatternForBack) {
      return Container(
        width: 60,
        height: 90,
        child: CustomPaint(
          painter: DeckPatternPainter(
            patternColor: colorOverride ?? Colors.purple[300]!,
          ),
        ),
      );
    }

    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: colorOverride ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          '${card.rank}${card.suit}',
          style: TextStyle(
            fontSize: 20,
            color: card.suit == '♥' || card.suit == '♦' ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
