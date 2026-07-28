// Fichier : lib/screens/devis/mes_demandes_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'mes_demandes_detail_screen.dart'; // Importe ton écran de détail

class MesDemandesScreen extends StatelessWidget {
  const MesDemandesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;

    // Liste de toutes les demandes de l'utilisateur
    final List<Map<String, dynamic>> listeDemandes = [
      {
        'reference': 'DEV-2026-0016',
        'titre': 'Fourniture de 20 ordinateurs portables',
        'mode': 'Formulaire',
        'date': '05/07/2026 à 14:30',
        'statut': 'En étude',
        'statutColor': Colors.orange,
        'isPdf': false,
        'details': [
          {'label': 'Catégorie', 'value': 'Matériel informatique'},
          {'label': 'Objet', 'value': 'Fourniture de 20 ordinateurs portables'},
          {'label': 'Quantité', 'value': '20'},
          {'label': 'Date souhaitée', 'value': '15/08/2026'},
          {'label': 'Adresse', 'value': 'Parakou, Quartier Bannikanni, Bénin'},
        ]
      },
      {
        'reference': 'DEV-2026-0015',
        'titre': 'Appel d\'offres - Équipements informatiques',
        'mode': 'Document (PDF)',
        'date': '04/07/2026 à 10:45',
        'statut': 'Devis disponible',
        'statutColor': Colors.blue,
        'isPdf': true,
        'details': [
          {'label': 'Catégorie', 'value': 'Matériel informatique'},
          {'label': 'Fichier', 'value': 'appel_offre_2026.pdf (8,24 Mo)'},
          {'label': 'Date souhaitée', 'value': '15/08/2026'},
          {'label': 'Montant devis', 'value': '6 850 000 FCFA HT'},
        ]
      },
    ];

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        title: Text(
          'Mes Demandes de Devis',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // ✅ Icône retour adaptative (si ajoutée)
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listeDemandes.length,
        itemBuilder: (context, index) {
          final item = listeDemandes[index];
          final statusColor = item['statutColor'] as Color;
          final isPdf = item['isPdf'] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor, // ✅ Fond de carte adaptatif
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor), // ✅ Bordure adaptative
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Icon(
                isPdf ? Icons.picture_as_pdf : Icons.description,
                color: isPdf ? Colors.red : AppColors.primary,
                size: 24,
              ),
              title: Text(
                item['reference'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item['titre'] as String,
                    style: TextStyle(fontSize: 12, color: textColor), // ✅ Texte adaptatif
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Statut : ${item['statut']}', 
                    style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: textSecondary), // ✅ Icône adaptative
              onTap: () {
                // On navigue vers l'écran de détail en passant 'item: item'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MesDemandesDetailSection(item: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}