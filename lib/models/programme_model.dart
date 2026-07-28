class Programme {
  final int id;
  final String titre;
  final String description;
  final String? image;

  Programme({
    required this.id,
    required this.titre,
    required this.description,
    this.image,
  });

  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      image: json['image'],
    );
  }
}