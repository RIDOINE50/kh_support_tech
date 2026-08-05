import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product; // Remplacez 'dynamic' par votre modèle de produit si vous en avez un (ex: Product)

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantite = 1;

  void _incrementer() {
    setState(() {
      quantite++;
    });
  }

  void _decrementer() {
    if (quantite > 1) {
      setState(() {
        quantite--;
      });
    }
  }

  void _ajouterAuPanier() {
    // ⚠️ Adaptez selon la structure de votre CartService
    // CartService().addItem(widget.product, quantite);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantite x ${widget.product.title} ajouté(s) au panier !'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Détails du produit', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Container(
              width: double.infinity,
              height: 300,
              color: cardColor,
              child: widget.product.image != null && widget.product.image.isNotEmpty
                  ? Image.network(
                      widget.product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du produit et Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.product.price.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Description
                  Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'Aucune description disponible pour ce produit.',
                    style: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  // Sélecteur de quantité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantité :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _decrementer,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                            iconSize: 28,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$quantite',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ),
                          IconButton(
                            onPressed: _incrementer,
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                            iconSize: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bouton fixe en bas pour ajouter au panier
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _ajouterAuPanier,
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text(
              'Ajouter au panier',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}