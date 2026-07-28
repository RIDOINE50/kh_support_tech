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

  // ✅ LISTE MISE À JOUR : "Réservations" remplacé par "Devis"
  static const List<_NavItemData> _items = [
    _NavItemData(
      icon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Accueil',
    ),
    _NavItemData(
      icon: Icons.handyman_rounded,
      inactiveIcon: Icons.handyman_outlined,
      label: 'Services',
    ),
    _NavItemData(
      icon: Icons.school_rounded,
      inactiveIcon: Icons.school_outlined,
      label: 'Formations',
    ),
    _NavItemData(
      icon: Icons.description_rounded, // ✅ Icône pour les Devis
      inactiveIcon: Icons.description_outlined,
      label: 'Maeché et achats', // ✅ Label changé
    ),
    _NavItemData(
      icon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: 'Compte',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final unselectedColor = isDark ? Colors.grey[400]! : AppColors.textSecondary;
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
                          ? AppColors.primary.withOpacity(0.15)
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
                            color: isSelected ? AppColors.primary : unselectedColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isSelected ? 11 : 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.primary : unselectedColor,
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

class _NavItemData {
  final IconData icon;
  final IconData inactiveIcon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
  });
}