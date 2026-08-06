import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../main.dart'; // Pour accéder au gestionnaire de thème global

// ✅ AJOUT DES IMPORTS POUR LA NAVIGATION
import '../apropos/apropos_screen.dart';
import '../profile/profile_screen.dart';

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
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER (Flèche retour fonctionnelle + Titre)
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
                      'Paramètres',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
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
                      
                      // Active le mode sombre PARTOUT dans l'app
                      themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      
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
                  
                  // ✅ BOUTON CONFIDENTIALITÉ ➔ REDIRIGE VERS LE PROFIL
                  _buildNavigationTile(
                    title: 'Confidentialité',
                    textColor: textColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // SECTION À PROPOS (Version)
                  // ✅ BOUTON À PROPOS ➔ REDIRIGE VERS L'ÉCRAN À PROPOS
                  _buildNavigationTile(
                    title: 'À propos de l\'application',
                    subtitle: 'Version 1.0.0',
                    textColor: textColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AProposScreen()),
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

  // TITRE DE SECTION
  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ITEM AVEC SWITCH
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
            activeColor: const Color(0xFF22C55E),
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