class FormationModel {
  final int id;
  final String nom;
  final String? description;
  final String? duree;
  final double prix;
  final String? image;
  final String? categorie;
  final String statut;

  FormationModel({
    required this.id,
    required this.nom,
    this.description,
    this.duree,
    required this.prix,
    this.image,
    this.categorie,
    required this.statut,
  });

  factory FormationModel.fromJson(Map<String, dynamic> json) {
    return FormationModel(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'],
      duree: json['duree'],
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      image: json['image'],
      categorie: json['categorie'],
      statut: json['statut'] ?? 'actif',
    );
  }
}