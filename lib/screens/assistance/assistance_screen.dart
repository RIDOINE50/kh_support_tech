import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import 'faq_screen.dart';

class AssistanceScreen extends StatelessWidget {
  const AssistanceScreen({super.key});

  // --- 1. WhatsApp (Numéro mis à jour : +229 01 61 12 71 45) ---
  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse(
      'https://wa.me/2290161127145?text=Bonjour,%20j\'ai%20besoin%20d\'aide%20concernant%20vos%20services.'
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir WhatsApp');
    }
  }

  // --- 2. Téléphone (Numéro mis à jour : 01 57 86 59 09) ---
  // On ajoute l'indicatif +229 pour que ça fonctionne sur tous les téléphones
  Future<void> _launchPhone() async {
    final Uri url = Uri.parse('tel:+2290157865909');
    if (!await launchUrl(url)) {
      debugPrint('Impossible d\'ouvrir le composeur téléphonique');
    }
  }

  // --- 3. E-mail (Adresse mise à jour : khtech2024@gmail.com) ---
  Future<void> _launchEmail() async {
    final Uri url = Uri.parse(
      'mailto:khtech2024@gmail.com?subject=Demande%20d\'assistance&body=Bonjour%20l\'équipe%20KH%20SUPPORT%20TECH,%0A%0AJ\'ai%20besoin%20d\'aide%20pour%20:'
    );
    if (!await launchUrl(url)) {
      debugPrint('Impossible d\'ouvrir l\'application e-mail');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ DÉTECTION DU MODE SOMBRE POUR ADAPTER LES COULEURS
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif (Blanc en clair, Noir/Gris foncé en sombre)
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor), // ✅ Icône adaptative
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Assistance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // ✅ Texte adaptatif
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Pour équilibrer la flèche retour
                ],
              ),
            ),

            // SOUS-TITRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Comment pouvons-nous vous aider ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // ✅ Texte adaptatif
                ),
              ),
            ),

            // LISTE DES OPTIONS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _AssistanceOption(
                    icon: Icons.chat_bubble,
                    iconColor: const Color(0xFF22C55E),
                    title: 'Chat en direct',
                    subtitle: 'Discutez avec un conseiller',
                    onTap: _launchWhatsApp, 
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.wechat,
                    iconColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    subtitle: '+229 01 61 12 71 45', // ✅ Nouveau numéro affiché
                    onTap: _launchWhatsApp,
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.call,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Appeler',
                    subtitle: '01 57 86 59 09', // ✅ Nouveau numéro affiché
                    onTap: _launchPhone,
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.email,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'E-mail',
                    subtitle: 'khtech2024@gmail.com', // ✅ Nouvel email affiché
                    onTap: _launchEmail,
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.help_outline,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'FAQ',
                    subtitle: 'Consultez les questions fréquentes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FaqScreen()),
                      );
                    },
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

// WIDGET RÉUTILISABLE POUR LES OPTIONS D'ASSISTANCE (Adapté au Mode Sombre)
class _AssistanceOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AssistanceOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Détection du thème à l'intérieur de la carte pour l'adapter parfaitement
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : const Color(0xFFF3F4F6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Fond de la carte adaptatif (Blanc ou Gris foncé)
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor), // ✅ Bordure adaptative (presque invisible en sombre)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.02), // ✅ Ombre plus visible en mode sombre
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor, // ✅ Titre adaptatif
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary, // ✅ Sous-titre adaptatif
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textSecondary, // ✅ Flèche adaptative
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}