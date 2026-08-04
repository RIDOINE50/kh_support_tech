import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../services/cart_service.dart';
import 'checkout_screen.dart';

class BoutiqueScreen extends StatefulWidget {
  const BoutiqueScreen({super.key});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  // ✅ État pour stocker la catégorie sélectionnée (par défaut 'Tous')
  String _selectedCategory = 'Tous';

  Future<List<dynamic>> _fetchProduits() async {
    try {
      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/produits'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print("Erreur chargement produits : $e");
      return [];
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
    final categoryBgColor = isDark ? const Color(0xFF374151) : const Color(0xFFEFF6FF);
    final borderColor = isDark ? Colors.grey[800]! : const Color(0xFFF3F4F6);
    final productPlaceholderBg = isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: bgColor,
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
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Boutique',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, size: 24, color: textColor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: ListenableBuilder(
                          listenable: CartService(),
                          builder: (context, child) {
                            if (CartService().items.isEmpty) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${CartService().items.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BARRE DE RECHERCHE (Visuelle)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Rechercher un produit...',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // CONTENU SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATÉGORIES
                    _buildSectionTitle('Catégories', textColor),
                    const SizedBox(height: 12),
                    _buildCategoriesList(categoryBgColor, textColor),
                    
                    const SizedBox(height: 24),

                    // PRODUITS (Filtrés dynamiquement)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(_selectedCategory == 'Tous' ? 'Produits populaires' : '$_selectedCategory', textColor, horizontalPadding: 0),
                          if (_selectedCategory != 'Tous')
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = 'Tous';
                                });
                              },
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDynamicProductsList(context, cardColor, textColor, textSecondary, borderColor, productPlaceholderBg),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor, {double horizontalPadding = 16}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildCategoriesList(Color categoryBgColor, Color textColor) {
    final categories = [
      {'icon': Icons.apps, 'label': 'Tous'},
      {'icon': Icons.laptop_mac, 'label': 'Ordinateurs'},
      {'icon': Icons.print, 'label': 'Imprimantes'},
      {'icon': Icons.device_hub, 'label': 'Réseaux'},
      {'icon': Icons.headphones, 'label': 'Accessoires'},
    ];

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final String label = cat['label'] as String;
          final bool isSelected = _selectedCategory == label;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = label;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : categoryBgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.primary : textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicProductsList(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color textSecondary,
    Color borderColor,
    Color productPlaceholderBg,
  ) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchProduits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: Text(
                'Aucun produit disponible pour le moment.',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
            ),
          );
        }

        List<dynamic> products = snapshot.data!;

        // 🔍 LOGIQUE DE FILTRAGE PAR CATÉGORIE
        if (_selectedCategory != 'Tous') {
          products = products.where((product) {
            // On vérifie si la catégorie correspond (en s'adaptant à la casse ou aux clés possibles de ton backend)
            final catProduit = (product['categorie'] ?? product['category'] ?? '').toString().toLowerCase();
            return catProduit.contains(_selectedCategory.toLowerCase()) || 
                   _selectedCategory.toLowerCase().contains(catProduit);
          }).toList();
        }

        if (products.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: textSecondary),
                  const SizedBox(height: 10),
                  Text(
                    'Aucun produit trouvé dans "$_selectedCategory"',
                    style: TextStyle(color: textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final title = product['nom'] ?? 'Sans nom';
            final description = product['description'] ?? '';
            final double price = double.tryParse(product['prix'].toString()) ?? 0.0;
            final String priceFormatted = '${price.toStringAsFixed(0)} FCFA';
            final rating = double.tryParse((product['rating'] ?? 4.5).toString()) ?? 4.5;
            final reviews = product['reviews'] ?? 12;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Image du produit
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: productPlaceholderBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: product['image'] != null && product['image'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product['image'],
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.grey,
                                size: 35,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                            size: 35,
                          ),
                  ),
                  const SizedBox(width: 14),
                  
                  // Infos produit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '$rating ($reviews)',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          priceFormatted,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bouton d'ajout au panier
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        CartService().addItem(
                          CartItem(
                            id: product['id'].toString(),
                            title: title,
                            price: price,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$title ajouté au panier'),
                            duration: const Duration(seconds: 1500),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Voir',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}