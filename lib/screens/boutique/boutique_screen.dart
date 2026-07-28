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
    // ✅ DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
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

            // BARRE DE RECHERCHE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(12),
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

            const SizedBox(height: 20),

            // CONTENU SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATÉGORIES
                    _buildSectionTitle('Catégories', textColor),
                    const SizedBox(height: 12),
                    _buildCategoriesList(categoryBgColor, textColor),
                    
                    const SizedBox(height: 24),

                    // PRODUITS POPULAIRES
                    _buildSectionTitle('Produits populaires', textColor),
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

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      {'icon': Icons.laptop_mac, 'label': 'Ordinateurs'},
      {'icon': Icons.print, 'label': 'Imprimantes'},
      {'icon': Icons.device_hub, 'label': 'Réseaux'},
      {'icon': Icons.headphones, 'label': 'Accessoires'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: categoryBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              'Aucun produit disponible pour le moment.',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          );
        }

        final products = snapshot.data!;

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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Image du produit (ou icône par défaut)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: productPlaceholderBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: product['image'] != null && product['image'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                  ),
                  const SizedBox(width: 16),
                  
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
                  
                  // Bouton d'ajout au panier (style maquette - bleu)
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
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
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
                        size: 20,
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