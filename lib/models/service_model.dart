class ServiceModel {
  final int id;
  final String nom;
  final String description;
  final String categorie;
  final int prixBase;
  final String delaiIntervention;
  final String image;

  ServiceModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorie,
    required this.prixBase,
    required this.delaiIntervention,
    required this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      categorie: json['categorie'] ?? '',
      prixBase: json['prixBase'] ?? 0,
      delaiIntervention: json['delaiIntervention'] ?? '',
      image: json['image'] ?? '',
    );
  }
}