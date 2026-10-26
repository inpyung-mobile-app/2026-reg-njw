class TarotCard {
  final int number;
  final String name;
  final String storytelling;
  final String image;

  TarotCard({
    required this.number,
    required this.name,
    required this.storytelling,
    required this.image,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) => TarotCard(
    number: json['number'],
    name: json['name'],
    storytelling: json['storytelling'],
    image: json['image'],
  );
}
