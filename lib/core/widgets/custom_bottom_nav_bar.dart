import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ✅ LISTE AVEC COULEURS UNIQUES POUR CHAQUE ICÔNE
  static const List<_NavItemData> _items = [
    _NavItemData(
      icon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Accueil',
      color: Color(0xFF3B82F6), // Bleu
    ),
    _NavItemData(
      icon: Icons.handyman_rounded,
      inactiveIcon: Icons.handyman_outlined,
      label: 'Services',
      color: Color(0xFFF59E0B), // Orange
    ),
    _NavItemData(
      icon: Icons.school_rounded,
      inactiveIcon: Icons.school_outlined,
      label: 'Formations',
      color: Color(0xFF8B5CF6), // Violet
    ),
    _NavItemData(
      icon: Icons.store_rounded,
      inactiveIcon: Icons.store_outlined,
      label: 'Boutique',
      color: Color(0xFF10B981), // Vert
    ),
    _NavItemData(
      icon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: 'Compte',
      color: Color(0xFFEF4444), // Rouge/Rose
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final shadowColor = isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              final isSelected = currentIndex == index;
              final item = _items[index];

              // ✅ Couleur de l'icône : saturée si sélectionné, pâle sinon
              final iconColor = isSelected 
                  ? item.color 
                  : item.color.withOpacity(isDark ? 0.5 : 0.6);
              
              // ✅ Couleur du texte : saturée si sélectionné, pâle sinon
              final textColor = isSelected 
                  ? item.color 
                  : (isDark ? Colors.grey[400]! : AppColors.textSecondary);

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? item.color.withOpacity(0.12) // ✅ Fond coloré pâle quand sélectionné
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isSelected ? item.icon : item.inactiveIcon,
                            key: ValueKey(isSelected),
                            color: iconColor, // ✅ Couleur dynamique
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isSelected ? 11 : 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: textColor, // ✅ Couleur du texte dynamique
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ✅ Classe modifiée pour inclure la couleur
class _NavItemData {
  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  final Color color; // ✅ Nouvelle propriété

  const _NavItemData({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
    required this.color,
  });
}