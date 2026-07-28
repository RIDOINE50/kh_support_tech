import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../main.dart'; // ✅ 1. AJOUTÉ : Pour accéder au gestionnaire de thème global

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  // États des switches (interrupteurs)
  bool _isDarkMode = false; 
  bool _areNotificationsEnabled = true;
  bool _isFingerprintEnabled = true;

  @override
  Widget build(BuildContext context) {
    // Astuce : Utiliser la couleur de fond du thème permet de s'adapter automatiquement au mode sombre
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER EXACT (Flèche retour fonctionnelle + Titre)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // ✅ Flèche retour activée
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Paramètres',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Pour équilibrer visuellement
                ],
              ),
            ),

            // CONTENU SCROLLABLE
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // SECTION APPARENCE
                  _buildSectionTitle('APPARENCE', textColor),
                  _buildSwitchTile(
                    title: 'Mode sombre',
                    value: _isDarkMode,
                    onChanged: (val) {
                      setState(() => _isDarkMode = val);
                      
                      // ✅ 2. MODIFIÉ : C'est cette ligne qui active le mode sombre PARTOUT dans l'app
                      themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      
                      // Petit feedback visuel pour confirmer l'action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Mode sombre activé' : 'Mode clair activé'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // SECTION NOTIFICATIONS
                  _buildSectionTitle('NOTIFICATIONS', textColor),
                  _buildSwitchTile(
                    title: 'Activer les notifications',
                    value: _areNotificationsEnabled,
                    onChanged: (val) {
                      setState(() => _areNotificationsEnabled = val);
                    },
                  ),

                  const SizedBox(height: 24),

                  // SECTION SÉCURITÉ
                  _buildSectionTitle('SÉCURITÉ', textColor),
                  _buildSwitchTile(
                    title: 'Empreinte digitale',
                    value: _isFingerprintEnabled,
                    onChanged: (val) {
                      setState(() => _isFingerprintEnabled = val);
                    },
                  ),
                  _buildNavigationTile(
                    title: 'Confidentialité',
                    textColor: textColor,
                    onTap: () {
                      // Action future : Naviguer vers l'écran de confidentialité
                    },
                  ),

                  const SizedBox(height: 32),

                  // SECTION À PROPOS (Version)
                  _buildNavigationTile(
                    title: 'À propos de l\'application',
                    subtitle: 'Version 1.0.0',
                    textColor: textColor,
                    onTap: () {
                      // Action future : Afficher les détails de la version ou les licences
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

  // TITRE DE SECTION (Majuscules, gris, petit)
  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor.withOpacity(0.6), // S'adapte au mode sombre
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ITEM AVEC SWITCH (INTERRUPTEUR)
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF22C55E), // Vert comme sur la maquette
            activeTrackColor: const Color(0xFF22C55E).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  // ITEM AVEC FLÈCHE DE NAVIGATION
  Widget _buildNavigationTile({
    required String title,
    String? subtitle,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textColor.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}