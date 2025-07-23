class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String type;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      type: json['types'][0]['type']['name'],
    );
  }
}
