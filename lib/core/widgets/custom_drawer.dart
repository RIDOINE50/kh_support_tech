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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          // 1. HEADER PROFESSIONNEL AVEC LOGO KH BICOLORE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 28, left: 28, right: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF0A1929), const Color(0xFF0F2B5B)]
                  : [const Color(0xFF0F2B5B), const Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F2B5B).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ✅ LOGO KH BICOLORE : K en OR, H en BLEU
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // K en OR avec dégradé
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFF9E29C), // Or clair
                                Color(0xFFD4AF37), // Or moyen
                                Color(0xFFAA8C2C), // Or foncé
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'K',
                              style: TextStyle(
                                color: Colors.white, // Important pour ShaderMask
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          // H en BLEU
                          const Text(
                            'H',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KH SERVICES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Solutions numériques',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. LISTE DES ITEMS DU MENU (Bien espacés et fluides)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _DrawerMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Marché et Achats',
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('marche_achat'),
                ),
                const SizedBox(height: 8),
                _DrawerMenuItem(
                  icon: Icons.storefront_outlined,
                  title: 'Boutique',
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('boutique'),
                ),
                const SizedBox(height: 8),
                _DrawerMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Assistance',
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('assistance'),
                ),
                const SizedBox(height: 8),
                _DrawerMenuItem(
                  icon: Icons.info_outline,
                  title: 'À propos',
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('apropos'),
                ),
                const SizedBox(height: 8),
                _DrawerMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  defaultTextColor: textColor,
                  defaultIconColor: defaultIconColor,
                  onTap: () => onMenuItemTap('parametres'),
                ),
                
                const SizedBox(height: 24),
                Divider(height: 1, color: dividerColor),
                const SizedBox(height: 16),
                
                // Déconnexion (Style distinct)
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

          // 3. FOOTER PROFESSIONNEL AVEC LOGO KH BICOLORE
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
                // ✅ Petit logo KH bicolore dans le footer
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFF9E29C),
                            Color(0xFFD4AF37),
                            Color(0xFFAA8C2C),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'K',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Text(
                        'H',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
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

// WIDGET RÉUTILISABLE POUR LES ITEMS (Plus fluide et espacé)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final finalTextColor = textColor ?? defaultTextColor;
    final finalIconColor = iconColor ?? defaultIconColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.grey[800]!.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: finalIconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: finalIconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: finalTextColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
              Icon(
                Icons.chevron_right,
                color: finalTextColor.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}