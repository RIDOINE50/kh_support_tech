// Fichier : lib/screens/devis/marche_achat_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'formulaire_devis_screen.dart';
import 'importer_document_screen.dart';

class MarcheAchatScreen extends StatelessWidget {
  const MarcheAchatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.03);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Demande de devis', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: textColor, size: 26),
                Positioned(right: 0, top: 0, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ TITRE ULTRA COURT
            Text(
              'Nouvelle demande',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Choisissez votre méthode :',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 24),

            // ✅ OPTION 1 : TRÈS ÉPURÉE
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormulaireDevisScreen())),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(isDark ? 0.6 : 0.4), width: 1.5),
                  boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Formulaire en ligne', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                          const SizedBox(height: 8),
                          _buildBulletPoint('Simple et rapide', textColor: textSecondary),
                          const SizedBox(height: 4),
                          _buildBulletPoint('Pour les besoins standards', textColor: textSecondary),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // ✅ OPTION 2 : TRÈS ÉPURÉE
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImporterDocumentScreen())),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(isDark ? 0.5 : 0.3), width: 1.5),
                  boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.green, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Importer un fichier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                          const SizedBox(height: 8),
                          _buildBulletPoint('PDF, Word, Excel, ZIP', color: Colors.green, textColor: textSecondary),
                          const SizedBox(height: 4),
                          _buildBulletPoint('Taille max : 20 Mo', color: Colors.green, textColor: textSecondary),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 18),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            // ✅ ENCADRÉ INFORMATIF MINIMALISTE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Devis personnalisé garanti.',
                      style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, {Color color = AppColors.primary, required Color textColor}) {
    return Row(
      children: [
        Icon(Icons.check, size: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, color: textColor)),
      ],
    );
  }
}