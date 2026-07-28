// Fichier : lib/screens/devis/mes_demandes_detail_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MesDemandesDetailSection extends StatelessWidget {
  final Map<String, dynamic> item; // Reçoit l'élément cliqué depuis l'écran précédent

  const MesDemandesDetailSection({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.03); // Ombre plus visible en mode sombre

    // Récupération sécurisée des détails de l'élément sélectionné
    final details = (item['details'] as List<dynamic>?)
            ?.map((e) => Map<String, String>.from(e))
            .toList() ??
        [];

    final statusColor = item['statutColor'] as Color? ?? Colors.grey;
    final isPdf = item['isPdf'] == true;

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        title: Text(
          item['reference'] as String? ?? 'Détails de la demande',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // ✅ Icône adaptative
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor, // ✅ Fond de carte adaptatif
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor), // ✅ Bordure adaptative
            boxShadow: [
              BoxShadow(
                color: shadowColor, // ✅ Ombre adaptative
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de la carte (Référence + Statut)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPdf ? Icons.picture_as_pdf : Icons.description,
                        color: isPdf ? Colors.red : AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['reference'] as String? ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor), // ✅ Texte adaptatif
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(isDark ? 0.2 : 0.1), // ✅ Fond du badge adaptatif (plus visible en mode sombre)
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['statut'] as String? ?? '',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item['titre'] as String? ?? '',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary), // ✅ Texte adaptatif
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: borderColor), // ✅ Séparateur adaptatif
              ),

              // Section des détails de la demande
              const Text(
                'Détails de la demande :',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              ...details.map((detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110,
                          child: Text(
                            '${detail['label']} :',
                            style: TextStyle(fontSize: 11, color: textSecondary), // ✅ Texte adaptatif
                          ),
                        ),
                        Expanded(
                          child: Text(
                            detail['value'] as String? ?? '',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor), // ✅ Texte adaptatif
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mode : ${item['mode'] ?? ''}', style: TextStyle(fontSize: 10, color: textSecondary)), // ✅ Texte adaptatif
                  Text(item['date'] as String? ?? '', style: TextStyle(fontSize: 10, color: textSecondary)), // ✅ Texte adaptatif
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}