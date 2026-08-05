import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../payment/payment_screen.dart'; 

class FormationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> formationData;

  const FormationDetailScreen({super.key, required this.formationData});

  @override
  State<FormationDetailScreen> createState() => _FormationDetailScreenState();
}

class _FormationDetailScreenState extends State<FormationDetailScreen> {
  late final String descriptionText;
  
  final List<String> modules = [
    "Introduction et fondamentaux",
    "Installation de l'environnement de travail",
    "Les concepts clés et la théorie",
    "Atelier pratique : Premier projet",
    "Techniques avancées et optimisation",
    "Projet final et certification"
  ];

  final List<String> galleryImages = [
    "https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600&h=400&fit=crop",
    "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&h=400&fit=crop",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=600&h=400&fit=crop",
  ];

  @override
  void initState() {
    super.initState();
    final apiDesc = widget.formationData['description']?.toString();
    descriptionText = (apiDesc != null && apiDesc.isNotEmpty)
        ? apiDesc
        : "Maîtrisez les fondamentaux et les techniques avancées de ce domaine. Cette formation complète vous permettra de développer des compétences pratiques et immédiatement applicables en entreprise.";
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.04); // Ombre plus marquée en mode sombre

    // RECUPERATION SECURISEE DES DONNEES
    final int formationId = widget.formationData['id'] ?? 0;
    final String title = widget.formationData['title'] ?? 'Formation';
    final String category = widget.formationData['categorie'] ?? 'INFORMATIQUE';
    final double rating = double.tryParse((widget.formationData['rating'] ?? 4.5).toString()) ?? 4.5;
    final int reviews = int.tryParse((widget.formationData['reviews'] ?? 12).toString()) ?? 12;
    final double price = double.tryParse((widget.formationData['price'] ?? 0).toString()) ?? 0.0;
    final String imageUrl = widget.formationData['imageUrl'] ?? '';

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      body: CustomScrollView(
        slivers: [
          // 1. HEADER AVEC GRANDE IMAGE
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary, // Reste bleu pour un beau contraste avec l'image
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: const [
              Icon(Icons.share, color: Colors.white),
              SizedBox(width: 8),
              Icon(Icons.favorite_border, color: Colors.white),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. TITRE ET INFOS PRINCIPALES
                Container(
                  padding: const EdgeInsets.all(20),
                  color: cardColor, // ✅ Fond de carte adaptatif
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle( // ✅ Texte adaptatif
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFBBF24), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '$rating ($reviews avis)',
                            style: TextStyle(color: textSecondary, fontSize: 13), // ✅ Texte adaptatif
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.visibility_outlined, color: textSecondary, size: 18),
                          const SizedBox(width: 4),
                          Text('1.2k vues', style: TextStyle(color: textSecondary, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. CARTES D'INFORMATIONS CLÉS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildInfoCard(Icons.access_time, 'Durée', 'Flexible', cardColor, textColor, textSecondary, shadowColor),
                      const SizedBox(width: 12),
                      _buildInfoCard(Icons.emoji_events_outlined, 'Niveau', 'Tous niveaux', cardColor, textColor, textSecondary, shadowColor),
                      const SizedBox(width: 12),
                      _buildInfoCard(Icons.verified_outlined, 'Certificat', 'Inclus', cardColor, textColor, textSecondary, shadowColor),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. DESCRIPTION
                _buildSectionTitle('Description', textColor),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor, // ✅ Fond adaptatif
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Text(
                    descriptionText,
                    style: TextStyle(color: textSecondary, fontSize: 14, height: 1.6), // ✅ Texte adaptatif
                  ),
                ),

                const SizedBox(height: 24),

                // 5. PROGRAMME / MODULES
                _buildSectionTitle('Programme de la formation', textColor),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor, // ✅ Fond adaptatif
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: modules.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String module = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15), // Légèrement plus visible en mode sombre
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                module,
                                style: TextStyle( // ✅ Texte adaptatif
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // 6. GALERIE PHOTOS
                _buildSectionTitle('Galerie photos', textColor),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: galleryImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          galleryImages[index],
                          width: 200,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 200,
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // 7. LOCALISATION
                _buildSectionTitle('Lieu de la formation', textColor),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor, // ✅ Fond adaptatif
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.location_on, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Centre KH Support Tech',
                              style: TextStyle( // ✅ Texte adaptatif
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '',
                              style: TextStyle(color: textSecondary, fontSize: 12), // ✅ Texte adaptatif
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // Espace pour la barre du bas
              ],
            ),
          ),
        ],
      ),

      // 8. BARRE FIXE EN BAS (Transmission exacte du Prix et de l'ID)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Fond adaptatif (au lieu de Colors.white)
          boxShadow: [
            BoxShadow(
              color: shadowColor, // ✅ Ombre adaptative
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prix total', style: TextStyle(color: textSecondary, fontSize: 12)), // ✅ Texte adaptatif
                  Text(
                    '${price.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          formationTitle: title,
                          formationId: formationId,
                          montant: price,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                  ),
                  child: const Text(
                    "S'inscrire maintenant",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helpers mis à jour pour accepter les couleurs dynamiques
  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color cardColor, Color textColor, Color textSecondary, Color shadowColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Fond adaptatif
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: textSecondary, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primary,
      child: const Center(
        child: Icon(Icons.school, size: 64, color: Colors.white38),
      ),
    );
  }
}