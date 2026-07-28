import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ActualitesScreen extends StatefulWidget {
  const ActualitesScreen({super.key});

  @override
  State<ActualitesScreen> createState() => _ActualitesScreenState();
}

class _ActualitesScreenState extends State<ActualitesScreen> {
  String _selectedFilter = 'Toutes';
  final List<String> _filters = ['Toutes', 'Articles', 'Promotions', 'Événements'];

  // Données mockées basées sur la maquette
  final List<Map<String, dynamic>> _news = [
    {
      'title': 'Nouveau centre de formation',
      'subtitle': 'Ouverture prochaine à Cotonou',
      'date': '20 Mai 2024',
      'bgColor': const Color(0xFFDBEAFE), // Bleu clair
      'icon': Icons.computer,
      'iconColor': AppColors.primary,
    },
    {
      'title': 'Promotion spéciale',
      'subtitle': '-20% sur toutes nos formations IA',
      'date': '18 Mai 2024',
      'bgColor': const Color(0xFF1F2937), // Fond sombre
      'icon': Icons.psychology,
      'iconColor': Colors.cyan,
    },
    {
      'title': 'Webinaire gratuit',
      'subtitle': 'L\'IA au service des entreprises',
      'date': '15 Mai 2024',
      'bgColor': const Color(0xFFFEF3C7), // Jaune clair
      'icon': Icons.person,
      'iconColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER EXACT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Actualités',
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

            const SizedBox(height: 8),

            // FILTRES (CHIPS)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // LISTE DES ACTUALITÉS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _news.length,
                itemBuilder: (context, index) {
                  final item = _news[index];
                  return _buildNewsCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARTE D'ACTUALITÉ
  Widget _buildNewsCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icône carrée
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: item['bgColor'] as Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: item['iconColor'] as Color,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          
          // Contenu texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item['date'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
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