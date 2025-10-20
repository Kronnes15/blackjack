import 'playing_card.dart';

List<PlayingCard> createDeck({bool fullDeck = false}) {
  List<String> suits = ['♠', '♥', '♣', '♦'];
  List<String> ranks36 = ['6','7','8','9','10','J','Q','K','A'];
  List<String> ranks54 = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];

  List<PlayingCard> deck = [];

  for (var suit in suits) {
    for (var rank in fullDeck ? ranks54 : ranks36) {
      int value;
      if (rank == 'A') value = 11;
      else if (['J','Q','K'].contains(rank)) value = 10;
      else value = int.tryParse(rank) ?? 0;
      deck.add(PlayingCard(rank: rank, suit: suit, value: value));
    }
  }

  deck.shuffle();
  return deck;
}
