class InscriptionModel {
  final int id;
  final int userId;
  final int formationId;
  final double montantPaye;
  final String statutPaiement;

  InscriptionModel({
    required this.id,
    required this.userId,
    required this.formationId,
    required this.montantPaye,
    required this.statutPaiement,
  });

  factory InscriptionModel.fromJson(Map<String, dynamic> json) {
    return InscriptionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      formationId: json['formation_id'] ?? 0,
      montantPaye: (json['montant_paye'] ?? json['montant'] ?? 0).toDouble(),
      statutPaiement: json['statut_paiement'] ?? 'en_attente',
    );
  }
}