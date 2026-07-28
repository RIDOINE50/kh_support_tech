import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../services/auth_service.dart'; // Ajuste le chemin selon l'emplacement de ton fichier
// Si vous utilisez SharedPreferences
class PaymentScreen extends StatefulWidget {
  final String formationTitle;
  final int formationId;
  final double montant;

  const PaymentScreen({
    super.key,
    required this.formationTitle,
    required this.formationId,
    required this.montant,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'momo';
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
// Si vous utilisez SharedPreferences

// ... dans votre méthode _processPayment() :

void _processPayment() async {
  if (selectedMethod == 'momo' && phoneController.text.trim().isEmpty) {
    _showErrorSnackBar('Veuillez entrer votre numéro de téléphone');
    return;
  }

  setState(() => isLoading = true);

  // 1. Préparer les données de l'inscription
  final inscriptionData = {
    'formation_id': widget.formationId,
    'montant': widget.montant,
    'mode_paiement': selectedMethod,
    'telephone': phoneController.text.trim(),
  };

  try {
    // 2. Appeler ton AuthService (qui va chercher le token et appeler l'API de façon sécurisée)
    final authService = AuthService();
    final resultat = await authService.inscrireAFormation(inscriptionData);

    print("--- RÉPONSE DU SERVEUR ---");
    print("Résultat : $resultat");

    if (!mounted) return;
    setState(() => isLoading = false);

    // 3. Traiter le résultat renvoyé par AuthService
    if (resultat['success'] == true) {
      _showSuccessDialog();
    } else {
      // Si le serveur renvoie une erreur (ou 401 gérée par le service)
      String errorMessage = resultat['error'] ?? 'Erreur lors du traitement';
      if (errorMessage.contains('401') || errorMessage.contains('connecté')) {
        _showErrorSnackBar('Session expirée ou non connecté. Veuillez vous reconnecter.');
      } else {
        _showErrorSnackBar(errorMessage);
      }
    }
  } catch (e) {
    if (!mounted) return;
    setState(() => isLoading = false);
    _showErrorSnackBar('Erreur : $e');
  }
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Paiement Réussi !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre inscription à "${widget.formationTitle}" a été enregistrée avec succès.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Terminer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Paiement sécurisé',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [_softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.formationTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Montant à payer', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text(
                        '${widget.montant.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('Moyen de paiement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _buildPaymentOption(
              id: 'momo',
              title: 'Mobile Money',
              subtitle: 'MTN, Moov, Orange, Wave...',
              icon: Icons.phone_android,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              id: 'card',
              title: 'Carte Bancaire',
              subtitle: 'Visa, Mastercard',
              icon: Icons.credit_card,
            ),
            const SizedBox(height: 28),
            if (selectedMethod == 'momo') ...[
              const Text('Numéro de téléphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [_softShadow],
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Ex: +225 07 00 00 00 00',
                    prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Payer ${widget.montant.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == id;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [_softShadow],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.primary : Colors.grey).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: selectedMethod,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => selectedMethod = val!),
            ),
          ],
        ),
      ),
    );
  }

  BoxShadow get _softShadow => BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );
}