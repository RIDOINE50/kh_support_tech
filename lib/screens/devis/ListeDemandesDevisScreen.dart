import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ListeDemandesDevisScreen extends StatelessWidget {
  const ListeDemandesDevisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.02); // Ombre plus visible en mode sombre

    // Liste de toutes les demandes de devis de l'utilisateur
    final List<Map<String, dynamic>> listeDemandes = [
      {
        'reference': 'DEV-2026-0016',
        'titre': 'Fourniture de 20 ordinateurs portables',
        'date': '05/07/2026',
        'statut': 'En étude',
        'statutColor': Colors.orange,
        'mode': 'Formulaire',
      },
      {
        'reference': 'DEV-2026-0015',
        'titre': 'Appel d\'offres - Équipements informatiques',
        'date': '04/07/2026',
        'statut': 'Devis disponible',
        'statutColor': Colors.blue,
        'mode': 'Document (PDF)',
      },
      {
        'reference': 'DEV-2026-0012',
        'titre': 'Maintenance des onduleurs du site principal',
        'date': '28/06/2026',
        'statut': 'Validée',
        'statutColor': Colors.green,
        'mode': 'Formulaire',
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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: textColor), // ✅ Icônes adaptatives
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listeDemandes.length,
        itemBuilder: (context, index) {
          final item = listeDemandes[index];
          final statusColor = item['statutColor'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor, // ✅ Fond de carte adaptatif
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor), // ✅ Bordure adaptative
              boxShadow: [
                BoxShadow(
                  color: shadowColor, // ✅ Ombre adaptative
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(isDark ? 0.2 : 0.1), // ✅ Légèrement plus visible en mode sombre
                child: Icon(
                  item['mode'] == 'Document (PDF)' ? Icons.picture_as_pdf : Icons.description,
                  color: statusColor,
                  size: 20,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['reference'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(isDark ? 0.2 : 0.1), // ✅ Fond du badge adaptatif
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['statut'] as String,
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['titre'] as String,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor), // ✅ Texte adaptatif
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mode : ${item['mode']}', 
                          style: TextStyle(fontSize: 10, color: textSecondary) // ✅ Texte adaptatif
                        ),
                        Text(
                          item['date'] as String, 
                          style: TextStyle(fontSize: 10, color: textSecondary) // ✅ Texte adaptatif
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Action au clic : tu pourras naviguer vers l'écran de détails qu'on a fait juste avant
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const MesDemandesDetailSection()));
              },
            ),
          );
        },
      ),
    );
  }
}