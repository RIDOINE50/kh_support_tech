import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Import du package
import '../../core/constants/app_colors.dart';
import 'faq_screen.dart'; // Nous allons créer ce fichier à l'étape 3

class AssistanceScreen extends StatelessWidget {
  const AssistanceScreen({super.key});

  // --- FONCTIONS POUR OUVRIR LES APPLICATIONS ---

  // 1. WhatsApp
  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/22997123456?text=Bonjour,%20j\'ai%20besoin%20d\'aide%20concernant%20vos%20services.');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir WhatsApp');
    }
  }

  // 2. Téléphone
  Future<void> _launchPhone() async {
    final Uri url = Uri.parse('tel:+22997123456');
    if (!await launchUrl(url)) {
      debugPrint('Impossible d\'ouvrir le composeur téléphonique');
    }
  }

  // 3. E-mail
  Future<void> _launchEmail() async {
    final Uri url = Uri.parse(
      'mailto:support@khsupporttech.com?subject=Demande%20d\'assistance&body=Bonjour%20l\'équipe%20KH%20SUPPORT%20TECH,%0A%0AJ\'ai%20besoin%20d\'aide%20pour%20:'
    );
    if (!await launchUrl(url)) {
      debugPrint('Impossible d\'ouvrir l\'application e-mail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Assistance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // SOUS-TITRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: const Text(
                'Comment pouvons-nous vous aider ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
                    onTap: () {
                      // Pour l'instant, on redirige aussi vers WhatsApp ou on peut créer un écran de chat simple
                      _launchWhatsApp(); 
                    },
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.wechat, // Icône style messagerie
                    iconColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    subtitle: 'Envoyez-nous un message',
                    onTap: _launchWhatsApp,
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.call,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Appeler',
                    subtitle: '+229 97 12 34 56',
                    onTap: _launchPhone,
                  ),
                  const SizedBox(height: 12),
                  _AssistanceOption(
                    icon: Icons.email,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'E-mail',
                    subtitle: 'support@khsupporttech.com',
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

// WIDGET RÉUTILISABLE POUR LES OPTIONS D'ASSISTANCE
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}