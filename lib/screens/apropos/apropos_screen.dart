import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  // ✅ Fonction pour ouvrir directement Google Maps
  Future<void> _openMaps() async {
    final Uri url = Uri.parse('https://maps.app.goo.gl/kGdbJj3soUckbsJa7');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir Google Maps');
    }
  }

  // ✅ Fonction pour aller vers l'écran des images de l'équipe
  void _goToTeamImages(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TeamImagesScreen()),
    );
  }

  // ✅ Fonction pour les détails texte
  void _goToDetail(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AboutDetailScreen(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final dividerColor = Theme.of(context).dividerColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'À propos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // LISTE DES ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _AboutMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Présentation',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    dividerColor: dividerColor,
                    onTap: () => _goToDetail(context, 'Présentation', 
                      'KH SUPPORT TECH : Votre Partenaire en Excellence Numérique\n\n'
                      'Fondée avec la vision de démocratiser l\'accès aux technologies de pointe, KH SUPPORT TECH s\'est imposée comme un acteur majeur dans le domaine des solutions informatiques et numériques en Afrique.\n\n'
                      'NOTRE APPROCHE\n\n'
                      'Nous croyons fermement que la technologie doit être un levier de croissance. C\'est pourquoi nous adoptons une approche humaine et personnalisée, en prenant le temps de comprendre vos enjeux avant de vous proposer des solutions sur mesure.\n\n'
                      'NOS DOMAINES D\'EXPERTISE\n\n'
                      '• Maintenance informatique et support technique\n'
                      '• Développement de solutions logicielles\n'
                      '• Formation professionnelle aux nouvelles technologies\n'
                      '• Vente de matériel informatique de qualité'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.flag,
                    title: 'Mission & Vision',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    dividerColor: dividerColor,
                    onTap: () => _goToDetail(context, 'Mission & Vision', 
                      'NOTRE MISSION\n\n'
                      'Accompagner les entreprises et les particuliers dans leur transformation digitale en leur fournissant des solutions technologiques innovantes et adaptées.\n\n'
                      'NOTRE VISION\n\n'
                      'Devenir le leader régional des services informatiques intégrés, reconnu pour notre expertise, notre innovation et notre engagement envers le développement des compétences numériques.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.groups_outlined,
                    title: 'Notre équipe',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    dividerColor: dividerColor,
                    onTap: () => _goToTeamImages(context),
                  ),
                  _AboutMenuItem(
                    icon: Icons.handshake_outlined,
                    title: 'Nos partenaires',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    dividerColor: dividerColor,
                    onTap: () => _goToDetail(context, 'Nos partenaires', 
                      'DES PARTENARIATS STRATÉGIQUES DE QUALITÉ\n\n'
                      'Nous collaborons avec des acteurs majeurs du secteur technologique pour vous garantir des solutions de pointe.\n\n'
                      '• Constructeurs de matériel informatique de renommée mondiale\n'
                      '• Éditeurs de logiciels leaders du marché\n'
                      '• Fournisseurs de solutions cloud internationales\n'
                      '• Opérateurs télécoms locaux et régionaux'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Localisation',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    dividerColor: dividerColor,
                    onTap: _openMaps,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ✅ ÉCRAN POUR LES 4 IMAGES AVEC LEURS LÉGENDES
// ==========================================
class TeamImagesScreen extends StatelessWidget {
  const TeamImagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Notre équipe',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            
            // Zone des 4 images avec légendes personnalisées
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTeamPhoto(
                      context, 
                      'assets/images/equipe1.jpeg', 
                      'Les élèves regroupés pour une belle photo de fin de formation 🎉',
                    ),
                    const SizedBox(height: 20),
                    _buildTeamPhoto(
                      context, 
                      'assets/images/equipe2.jpeg', 
                      'Immersion en plein atelier de programmation et codage 💻',
                    ),
                    const SizedBox(height: 20),
                    _buildTeamPhoto(
                      context, 
                      'assets/images/equipe3.jpeg', 
                      'Travail collaboratif et partage de compétences entre passionnés 🚀',
                    ),
                    const SizedBox(height: 20),
                    _buildTeamPhoto(
                      context, 
                      'assets/images/equipe4.jpeg', 
                      'Notre équipe d\'encadreurs et de formateurs engagés pour votre réussite ✨',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Widget sécurisé pour afficher l'image et sa légende en dessous
  Widget _buildTeamPhoto(BuildContext context, String assetPath, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final errorTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            assetPath,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 40, color: errorTextColor),
                      const SizedBox(height: 8),
                      Text(label, style: TextStyle(color: errorTextColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color textColor;
  final Color subTextColor;
  final Color dividerColor;

  const _AboutMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.textColor,
    required this.subTextColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: subTextColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
              ),
            ),
            Icon(Icons.chevron_right, color: subTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ÉCRAN DE DÉTAIL (Pour le texte)
// ==========================================
class AboutDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const AboutDetailScreen({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: content.split('\n\n').map((paragraph) {
                    bool isTitle = paragraph == paragraph.toUpperCase() && paragraph.length < 50;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        paragraph,
                        style: TextStyle(
                          fontSize: isTitle ? 18 : 16,
                          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                          color: isTitle ? primaryColor : textColor,
                          height: 1.6,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}