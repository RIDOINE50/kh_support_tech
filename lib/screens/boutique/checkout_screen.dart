import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // ✅ SÉPARATION DES NUMÉROS POUR ÉVITER TOUTE CONFUSION
  static const String whatsappNumberLink = '2290161127145'; // <-- C'est ce numéro qui s'ouvrira dans WhatsApp
  static const String momoNumberDisplay = '01 57 86 59 09'; // <-- C'est ce numéro qui s'affiche pour le dépôt MoMo
  static const String momoName = 'KH SERVICES';
  
  bool _isNumberCopied = false;

  @override
  void dispose() {
    _localisationController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  void _copierNumero() {
    Clipboard.setData(const ClipboardData(text: '0157865909'));
    setState(() => _isNumberCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Numéro MoMo copié'), duration: Duration(seconds: 1)),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isNumberCopied = false);
    });
  }

  // ✅ 1. Fonction pour le bouton WhatsApp PERMANENT (Mène au 01 61 12 71 45)
  Future<void> _contacterSupportWhatsApp() async {
    final String message = 'Bonjour KH SERVICES, j\'ai une question concernant ma commande en cours sur l\'application.';
    final Uri url = Uri.parse('https://wa.me/$whatsappNumberLink?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("❌ ERREUR TERMINAL : Impossible d'ouvrir WhatsApp (Support).");
    }
  }

  // ✅ 2. Fonction pour le bouton WhatsApp APRÈS VALIDATION (Mène au 01 61 12 71 45)
  Future<void> _envoyerPreuveWhatsApp(double montantTotal) async {
    final String message = 'Bonjour KH SERVICES. 👋\n\n'
        'Je viens d\'effectuer le paiement de *${montantTotal.toStringAsFixed(0)} FCFA* \n'
        'pour ma commande (Mode: ${modeLivraison == 'livraison' ? 'Livraison' : 'Retrait'}).\n\n'
        'Veuillez trouver ci-joint la capture d\'écran de mon reçu.';

    final Uri url = Uri.parse('https://wa.me/$whatsappNumberLink?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("❌ ERREUR TERMINAL : Impossible d'ouvrir WhatsApp (Preuve).");
    }
  }

  Future<void> _validerCommande() async {
    if (CartService().items.isEmpty) {
      print("❌ ERREUR TERMINAL : Tentative de validation avec un panier vide.");
      return;
    }

    if (modeLivraison == 'livraison' && _localisationController.text.trim().isEmpty) {
      print("❌ ERREUR TERMINAL : Le champ localisation est vide.");
      return;
    }

    if (_telephoneController.text.trim().isEmpty) {
      print("❌ ERREUR TERMINAL : Le champ numéro de téléphone est vide.");
      return;
    }

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        print("❌ ERREUR TERMINAL : Token manquant ou session expirée.");
        setState(() => isLoading = false);
        return;
      }

      List<Map<String, dynamic>> lignesCommande = CartService().items.map((item) => {
        'produit_id': item.id,
        'quantite': item.quantity,
        'prix_unitaire': item.price,
      }).toList();

      final double montantTotal = CartService().totalAmount;

      Map<String, dynamic> commandeData = {
        'type': 'materiel',
        'description': modeLivraison == 'livraison' 
            ? 'Livraison à domicile. Adresse : ${_localisationController.text} | Tél : ${_telephoneController.text}' 
            : 'Retrait en boutique | Tél : ${_telephoneController.text}',
        'montant_total': montantTotal,
        'lignes': lignesCommande,
        'statut': 'en_attente_paiement',
      };

      print("📤 ENVOI API (Terminal) : Envoi des données à Laravel...");
      final resultat = await _apiService.creerCommande(commandeData, token);
      print("📥 RÉPONSE API (Terminal) : $resultat");

      if (!mounted) return;
      setState(() => isLoading = false);

      if (resultat['success'] == true) {
        print("✅ SUCCÈS TERMINAL : Commande créée avec succès.");
        CartService().clear();
        _showMoMoInstructionsDialog(montantTotal);
      } else {
        print("❌ ERREUR BACKEND/LARAVEL (Terminal) : ${resultat['error']}");
      }
    } catch (e) {
      print("❌ ERREUR EXCEPTION (Terminal) : $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _showMoMoInstructionsDialog(double montantTotal) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Commande enregistrée !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Veuillez effectuer le dépôt Mobile Money ci-dessous :',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(momoName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(momoNumberDisplay, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _copierNumero,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isNumberCopied ? Colors.green : AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: Text(
                            _isNumberCopied ? 'Copié !' : 'Copier',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Montant à payer :', style: TextStyle(fontSize: 14)),
                        Text(
                          '${montantTotal.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _envoyerPreuveWhatsApp(montantTotal); // Ouvre WhatsApp vers le 01 61 12 71 45
                  },
                  icon: const Icon(Icons.wechat, color: Colors.white, size: 24),
                  label: const Text(
                    'J\'ai payé, envoyer la preuve',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        ),
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
    final dividerColor = Theme.of(context).dividerColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final chipUnselectedBg = isDark ? Colors.grey[800] : Colors.grey[200];

    final totalAmount = CartService().totalAmount;

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
                Text('${totalAmount.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
                    : const Text('Valider la commande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 16),

            // ✅ NOUVEAU : BOUTON WHATSAPP PERMANENT (Mène au 01 61 12 71 45)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _contacterSupportWhatsApp,
                icon: const Icon(Icons.wechat, color: Color(0xFF25D366), size: 24),
                label: const Text(
                  'Une question ? Contacter le support',
                  style: TextStyle(color: Color(0xFF25D366), fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF25D366).withOpacity(0.05),
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