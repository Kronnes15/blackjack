class PlayingCard {
  final String rank;  // "6", "7", ..., "A"
  final String suit;  // "♠", "♥", "♣", "♦"
  final int value;    // числове значення для гри (J,Q,K=10, A=11)

  PlayingCard({required this.rank, required this.suit, required this.value});
}
