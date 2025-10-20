import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../models/deck.dart';
import '../widgets/card_widget.dart';

class BlackjackScreen extends StatefulWidget {
  @override
  _BlackjackScreenState createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
  List<PlayingCard> playerCards = [];
  List<PlayingCard> dealerCards = [];
  List<PlayingCard> deck = [];
  String result = '';
  bool gameOver = true; // гра ще не почата

  bool useFullDeck = false;
  Color playerColor = Colors.blue; // замість червоного

  PlayingCard? flyingCard;
  bool isForPlayer = true;
  bool deckHighlight = false;

  int get totalPlayer => playerCards.fold(0, (sum, card) => sum + card.value);
  int get totalDealer => dealerCards.fold(0, (sum, card) => sum + card.value);

  void startGame() {
    deckHighlight = true;
    deck = createDeck(fullDeck: useFullDeck);
    playerCards.clear();
    dealerCards.clear();
    flyingCard = null;
    result = '';
    gameOver = false;
    setState(() {});

    // Вимикаємо підсвітку через 500ms
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        deckHighlight = false;
      });
    });
  }

  void playerDraw() async {
    if (gameOver || deck.isEmpty) return;

    setState(() {
      flyingCard = deck.removeAt(0);
      isForPlayer = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      playerCards.add(flyingCard!);
      flyingCard = null;

      if (dealerCards.isEmpty) dealerCards.add(deck.removeAt(0));

      if (totalPlayer > 21) {
        result = 'Перебір! Dealer виграв 😢';
        gameOver = true;
      } else {
        dealerDraw();
      }
    });
  }

  void dealerDraw() async {
    if (gameOver || deck.isEmpty) return;

    if (totalDealer < 17) {
      setState(() {
        flyingCard = deck.removeAt(0);
        isForPlayer = false;
      });

      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        dealerCards.add(flyingCard!);
        flyingCard = null;
      });

      dealerDraw();
    }
  }

  void playerStay() {
    if (gameOver) return;

    setState(() {
      while (totalDealer < 17 && deck.isNotEmpty) dealerCards.add(deck.removeAt(0));

      if (totalDealer > 21 || totalPlayer > totalDealer)
        result = 'Ти виграв 🎉';
      else if (totalDealer > totalPlayer)
        result = 'Dealer виграв 😢';
      else
        result = 'Нічия 🤝';

      gameOver = true;
    });
  }

  Widget deckWidget({Color? patternColor, bool highlight = false}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: highlight ? Colors.purple : Colors.black, // підсвітка фіолетова
            blurRadius: highlight ? 10 : 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: CustomPaint(
        painter: DeckPatternPainter(
          patternColor: patternColor ?? Colors.purple[300]!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blackjack 21')),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              // Налаштування
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Колода: '),
                  Switch(
                      value: useFullDeck,
                      onChanged: (val) {
                        setState(() {
                          useFullDeck = val;
                        });
                      }),
                  Text(useFullDeck ? '54 карти' : '36 карт'),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: gameOver ? startGame : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gameOver ? Colors.yellow : Colors.red,
                    ),
                    child: Text(gameOver ? 'Нова гра' : 'Гра йде...'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Колір гравця: '),
                  DropdownButton<Color>(
                    value: playerColor,
                    items: [
                      DropdownMenuItem(child: Text('Синій'), value: Colors.blue),
                      DropdownMenuItem(child: Text('Зелений'), value: Colors.green),
                      DropdownMenuItem(child: Text('Жовтий'), value: Colors.orange),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => playerColor = val);
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
              // Ігрове поле
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Дилер зверху
                    Column(
                      children: [
                        Text('Dealer', style: TextStyle(fontSize: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dealerCards
                              .map<Widget>((c) => CardWidget(
                            card: c,
                            colorOverride: playerColor,
                            isFaceDown: !gameOver,
                            usePatternForBack: true,
                          ))
                              .toList(),
                        ),
                        Text('Сума: ${gameOver ? totalDealer : '?'}'),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Колода по центру
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        deckWidget(
                          patternColor: playerColor,
                          highlight: deckHighlight,
                        ),
                        if (flyingCard != null)
                          AnimatedAlign(
                            duration: Duration(milliseconds: 500),
                            alignment: isForPlayer ? Alignment(0, 0.5) : Alignment(0, -0.5),
                            child: CardWidget(
                              card: flyingCard!,
                              colorOverride: isForPlayer ? playerColor : Colors.black,
                              isFaceDown: !isForPlayer,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Гравець знизу
                    Column(
                      children: [
                        Text('Гравець', style: TextStyle(fontSize: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: playerCards
                              .map<Widget>((c) => CardWidget(
                            card: c,
                            colorOverride: playerColor,
                          ))
                              .toList(),
                        ),
                        Text('Сума: $totalPlayer'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Кнопки дій
              if (!gameOver) ...[
                ElevatedButton(onPressed: playerDraw, child: Text('Взяти карту')),
                ElevatedButton(onPressed: playerStay, child: Text('Залишитися')),
              ],
              if (gameOver) ...[
                SizedBox(height: 10),
                Text(result, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

// Клас для візерунка колоди
class DeckPatternPainter extends CustomPainter {
  final Color patternColor;

  DeckPatternPainter({required this.patternColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Градієнтний фон
    Rect rect = Offset.zero & size;
    Paint bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple[900]!, Colors.purple[100]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(8)), bgPaint);

    // Ромбічна сітка
    double padding = 5;
    double step = 12;

    Paint linePaint = Paint()
      ..color = patternColor
      ..strokeWidth = 1.5;

    for (double y = padding; y < size.height - padding; y += step) {
      for (double x = padding; x < size.width - padding; x += step) {
        canvas.drawLine(
            Offset(x, y), Offset(x + step / 2, y + step / 2), linePaint);
        canvas.drawLine(
            Offset(x + step / 2, y), Offset(x, y + step / 2), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
