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
    // Récupère le prix peu importe le nom de la colonne dans Laravel ou le JSON
    var rawPrix = json['prix_base'] ?? json['prixBase'] ?? json['prix'] ?? json['price'] ?? 0;
    
    int parsedPrix = 0;
    if (rawPrix != null) {
      parsedPrix = double.tryParse(rawPrix.toString())?.toInt() ?? 0;
    }

    return ServiceModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      categorie: json['categorie'] ?? '',
      prixBase: parsedPrix,
      delaiIntervention: json['delai_intervention'] ?? json['delaiIntervention'] ?? json['delai'] ?? '',
      image: json['image'] ?? '',
    );
  }
}