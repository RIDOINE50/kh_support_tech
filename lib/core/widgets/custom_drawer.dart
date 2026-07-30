import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String) onMenuItemTap;

  const CustomDrawer({
    super.key,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Détection du mode sombre pour adapter les couleurs
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Couleurs dynamiques du thème
    final drawerBgColor = Theme.of(context).scaffoldBackgroundColor;
    final footerBgColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB);
    final dividerColor = Theme.of(context).dividerColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final defaultIconColor = Theme.of(context).iconTheme.color ?? (isDark ? Colors.grey[400]! : Colors.black54);

    return Drawer(
      backgroundColor: drawerBgColor,
      child: Column(
        children: [
          // 1. HEADER PROFESSIONNEL AVEC LOGO KH
          Container(
            width: double.infinity,
            // ✅ CORRECTION ICI : On augmente le 'top' à 60 et les côtés à 24 pour aérer le design
            padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24), // ✅ Arrondi légèrement plus prononcé pour l'élégance
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'KH',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KH SUPPORT TECH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Solutions numériques',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ On garde un petit espace entre le header bleu et le premier élément du menu
          const SizedBox(height: 12),

          // 2. LISTE DES ITEMS DU MENU
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _DrawerMenuItem(icon: Icons.event_available_outlined, title: 'Programmes', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('programmes')),
                _DrawerMenuItem(icon: Icons.shopping_bag_outlined, title: 'Marché et Achats', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('marche_achat')),
                _DrawerMenuItem(icon: Icons.storefront_outlined, title: 'Boutique', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('boutique')),
                _DrawerMenuItem(icon: Icons.headset_mic_outlined, title: 'Assistance', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('assistance')),
                _DrawerMenuItem(icon: Icons.info_outline, title: 'À propos', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('apropos')),
                _DrawerMenuItem(icon: Icons.settings_outlined, title: 'Paramètres', defaultTextColor: textColor, defaultIconColor: defaultIconColor, onTap: () => onMenuItemTap('parametres')),
                
                Divider(height: 32, color: dividerColor),
                
                // Déconnexion (Style distinct, reste rouge dans les deux modes)
                _DrawerMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Déconnexion',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('deconnexion'),
                ),
              ],
            ),
          ),

          // 3. FOOTER PROFESSIONNEL AVEC LOGO KH
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: footerBgColor,
              border: Border(
                top: BorderSide(color: dividerColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'KH',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '© 2024 KH Support Tech',
                        style: TextStyle(
                          fontSize: 11,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET RÉUTILISABLE POUR LES ITEMS
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? badge;
  final Color? textColor;
  final Color? iconColor;
  final Color defaultTextColor;
  final Color defaultIconColor;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    this.badge,
    this.textColor,
    this.iconColor,
    required this.defaultTextColor,
    required this.defaultIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final finalTextColor = textColor ?? defaultTextColor;
    final finalIconColor = iconColor ?? defaultIconColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: finalIconColor, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: finalTextColor,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}