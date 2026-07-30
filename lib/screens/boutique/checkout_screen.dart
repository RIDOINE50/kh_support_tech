import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../services/cart_service.dart';
import '../../services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String modeLivraison = 'livraison'; 
  final _localisationController = TextEditingController();
  final _telephoneController = TextEditingController();
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _contacterWhatsApp() async {
    final String numero = '2290161127145';
    final String message = 'Bonjour, j\'ai une question concernant ma commande sur KH Support Tech.';
    final Uri whatsappUrl = Uri.parse('https://wa.me/$numero?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp. Veuillez vérifier qu\'il est installé.')),
      );
    }
  }

  Future<void> _validerCommande() async {
    if (CartService().items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Votre panier est vide.')),
      );
      return;
    }

    if (modeLivraison == 'livraison' && _localisationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre localisation/adresse.')),
      );
      return;
    }

    if (_telephoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre numéro de téléphone.')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expirée. Veuillez vous reconnecter.')),
        );
        setState(() => isLoading = false);
        return;
      }

      List<Map<String, dynamic>> lignesCommande = CartService().items.map((item) => {
        'produit_id': item.id,
        'quantite': item.quantity,
        'prix_unitaire': item.price,
      }).toList();

      Map<String, dynamic> commandeData = {
        'type': 'materiel',
        'description': modeLivraison == 'livraison' 
            ? 'Livraison à domicile. Adresse : ${_localisationController.text} | Tél : ${_telephoneController.text}' 
            : 'Retrait en boutique | Tél : ${_telephoneController.text}',
        'montant_total': CartService().totalAmount,
        'lignes': lignesCommande,
      };

      final resultat = await _apiService.creerCommande(commandeData, token);

      if (resultat['success'] == true) {
        CartService().clear();
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès 🎉'),
            content: const Text('Votre commande a été envoyée avec succès ! L\'administrateur va la traiter. Vous pouvez nous contacter sur WhatsApp pour le suivi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pop(context); 
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${resultat['error']}')),
        );
      }
    } catch (e) {
      print('Erreur exception : $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
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
    final dividerColor = Theme.of(context).dividerColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final chipUnselectedBg = isDark ? Colors.grey[800] : Colors.grey[200];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Valider la commande', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Mode de réception', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text('Livraison à domicile', style: TextStyle(color: modeLivraison == 'livraison' ? Colors.white : textColor, fontWeight: FontWeight.w500)),
                    selected: modeLivraison == 'livraison',
                    selectedColor: AppColors.primary,
                    backgroundColor: chipUnselectedBg,
                    onSelected: (val) => setState(() => modeLivraison = 'livraison'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Retrait en boutique', style: TextStyle(color: modeLivraison == 'retrait' ? Colors.white : textColor, fontWeight: FontWeight.w500)),
                    selected: modeLivraison == 'retrait',
                    selectedColor: AppColors.primary,
                    backgroundColor: chipUnselectedBg,
                    onSelected: (val) => setState(() => modeLivraison = 'retrait'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (modeLivraison == 'livraison') ...[
              TextField(
                controller: _localisationController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Votre localisation / Adresse précise',
                  labelStyle: TextStyle(color: textSecondary),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textSecondary.withOpacity(0.5))),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2)),
                  filled: true,
                  fillColor: cardColor,
                  prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            TextField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                labelStyle: TextStyle(color: textSecondary),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textSecondary.withOpacity(0.5))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2)),
                filled: true,
                fillColor: cardColor,
                prefixIcon: Icon(Icons.phone, color: textSecondary),
              ),
            ),
            
            const SizedBox(height: 25),
            
            Text('Résumé du panier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
            const SizedBox(height: 10),
            
            ...CartService().items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: dividerColor),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                subtitle: Text('Quantité: ${item.quantity}', style: TextStyle(color: textSecondary)),
                trailing: Text('${(item.price * item.quantity).toStringAsFixed(0)} FCFA', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              ),
            )),
            
            Divider(color: dividerColor, thickness: 2),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                Text('${CartService().totalAmount.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // ✅ BOUTON PRINCIPAL DE VALIDATION
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : _validerCommande,
                child: isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                    : const Text('Payer / Valider la commande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 15),

            // ✅ NOUVEAU BOUTON WHATSAPP (CORRIGÉ ET PROPRE)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _contacterWhatsApp,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), 
                  foregroundColor: Colors.white, 
                  side: const BorderSide(color: Color(0xFF25D366), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.wechat, size: 26), 
                label: const Text(
                  'Nous contacter sur WhatsApp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}