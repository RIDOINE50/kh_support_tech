import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../core/constants/app_colors.dart';
import '../../services/formation_api.dart'; 
import 'package:kh_support_tech/screens/payment/payment_screen.dart';
import 'formation_detail_screen.dart';
// ✅ 1. IMPORT DU MAINSCREEN
import '../main/main_screen.dart'; 

// Modèle de données (inchangé)
class Formation {
  final int id;
  final String title;
  final String duration;
  final double price;
  final String category;
  final double rating;
  final int reviews;
  final String? imageUrl;
  final String? description;

  Formation({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    this.imageUrl,
    this.description,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'] ?? 0,
      title: json['nom'] ?? 'Formation',
      duration: json['duree'] ?? 'Non spécifiée',
      price: double.tryParse((json['prix'] ?? 0).toString()) ?? 0.0,
      category: (json['categorie'] ?? 'Autres').toString(),
      rating: double.tryParse((json['rating'] ?? 4.5).toString()) ?? 4.5,
      reviews: json['reviews'] ?? 12,
      imageUrl: json['image'],
      description: json['description'],
    );
  }
}

class FormationsScreen extends StatefulWidget {
  const FormationsScreen({super.key});

  @override
  State<FormationsScreen> createState() => _FormationsScreenState();
}

class _FormationsScreenState extends State<FormationsScreen> {
  String _selectedFilter = 'Toutes';
  String _searchQuery = '';
  List<Formation> _allFormations = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _filters = ['Toutes', 'Informatique', 'IA', 'Drone', 'Autres'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerFormationsReelles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _chargerFormationsReelles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<dynamic> jsonData = await FormationApi.getFormations();
      setState(() {
        _allFormations = jsonData.map((json) => Formation.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de charger les formations. Vérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  // ✅ 2. MÉTHODE INFAILLIBLE POUR RETOURNER À L'ACCUEIL (MainScreen)
  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false, 
    );
  }

  List<Formation> get _filteredFormations {
    return _allFormations.where((formation) {
      final matchesFilter = _selectedFilter == 'Toutes' ||
          formation.category.toLowerCase() == _selectedFilter.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          formation.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> _lancerContact(String titreFormation) async {
    final String numeroWhatsApp = '22997123456'; 
    final String message = Uri.encodeComponent('Bonjour, je suis intéressé par la formation : "$titreFormation". Pouvez-vous me donner plus de détails ?');
    final Uri url = Uri.parse('https://wa.me/$numeroWhatsApp?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp. Vérifiez que l\'application est installée.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    
    final searchBgColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6);
    final filterBorderColor = isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB);
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.08);
    final placeholderBg = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final placeholderIcon = isDark ? Colors.grey[400]! : const Color(0xFF9CA3AF);

    final listToDisplay = _filteredFormations;
    
    // ✅ 3. TAILLE DE L'IMAGE AUGMENTÉE DE 2PX (110 -> 112)
    const double imageSize = 112; 

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 48, color: textSecondary),
                    const SizedBox(height: 16),
                    Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _chargerFormationsReelles,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Réessayer'),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                          onPressed: _goToHome, 
                        ),
                        Expanded(
                          child: Text(
                            'Formations',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: searchBgColor, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textColor),
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: textSecondary, size: 20),
                          hintText: 'Rechercher une formation...',
                          hintStyle: TextStyle(color: textSecondary),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : (isDark ? Colors.transparent : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppColors.primary : filterBorderColor),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textColor,
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
                  const SizedBox(height: 8),
                  Expanded(
                    child: listToDisplay.isEmpty
                        ? Center(child: Text('Aucune formation ne correspond à votre recherche.', style: TextStyle(color: textSecondary)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: listToDisplay.length,
                            itemBuilder: (context, index) {
                              final formation = listToDisplay[index];
                              return _buildFormationCard(
                                formation, cardColor, textColor, textSecondary, shadowColor, placeholderBg, placeholderIcon, imageSize,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFormationCard(
    Formation formation, 
    Color cardColor, 
    Color textColor, 
    Color textSecondary,
    Color shadowColor,
    Color placeholderBg,
    Color placeholderIcon,
    double imageSize,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormationDetailScreen(
              formationData: {
                'id': formation.id,
                'title': formation.title,
                'subtitle': '${formation.duration} - ${formation.price.toStringAsFixed(0)} FCFA',
                'price': formation.price,
                'imageUrl': formation.imageUrl ?? '',
                'rating': formation.rating,
                'reviews': formation.reviews,
                'categorie': formation.category,
                'description': formation.description ?? '',
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: formation.imageUrl != null && formation.imageUrl!.isNotEmpty
                  ? Image.network(
                      formation.imageUrl!,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(placeholderBg, placeholderIcon, imageSize),
                    )
                  : _buildPlaceholderImage(placeholderBg, placeholderIcon, imageSize),
            ),
            const SizedBox(width: 14),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formation.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formation.duration} • ${formation.price.toStringAsFixed(0)} FCFA',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${formation.rating} (${formation.reviews})',
                        style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  formationTitle: formation.title,
                                  formationId: formation.id,
                                  montant: double.tryParse(formation.price.toString()) ?? 0.0,
                                )
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('S\'inscrire', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      InkWell(
                        onTap: () => _lancerContact(formation.title),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, color: Colors.green, size: 18),
                              SizedBox(width: 4),
                              Text('Contact', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(Color bgColor, Color iconColor, double size) {
    return Container(
      width: size,
      height: size,
      color: bgColor,
      child: Icon(Icons.school, color: iconColor, size: size * 0.45),
    );
  }
}