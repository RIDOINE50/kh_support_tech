import 'formation_model.dart';

class InscriptionModel {
  final int id;
  final int userId;
  final int formationId;
  final String dateInscription;
  final String statutPaiement;
  final double montantPaye;
  final String statutParticipation;
  final FormationModel? formation;

  InscriptionModel({
    required this.id,
    required this.userId,
    required this.formationId,
    required this.dateInscription,
    required this.statutPaiement,
    required this.montantPaye,
    required this.statutParticipation,
    this.formation,
  });

  factory InscriptionModel.fromJson(Map<String, dynamic> json) {
    return InscriptionModel(
      id: json['id'],
      userId: json['user_id'],
      formationId: json['formation_id'],
      dateInscription: json['date_inscription'] ?? json['created_at'] ?? '',
      statutPaiement: json['statut_paiement'] ?? 'en_attente',
      montantPaye: double.tryParse(json['montant_paye'].toString()) ?? 0.0,
      statutParticipation: json['statut_participation'] ?? 'inscrit',
      formation: json['formation'] != null 
          ? FormationModel.fromJson(json['formation']) 
          : null,
    );
  }
}