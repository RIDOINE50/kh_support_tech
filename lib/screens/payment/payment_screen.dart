import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour copier le numéro
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';

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
  // Numéro pour l'affichage et pour le lien (le même qui marche dans Formations)
  static const String numeroWhatsApp = '2290161127145';
  static const String momoNumberDisplay = '01 57 86 59 09';
  static const String momoName = 'KH SERVICES';
  
  bool _isNumberCopied = false;

  @override
  void dispose() {
    super.dispose();
  }

  // ✅ 1. Fonction pour copier le numéro MoMo
  void _copierNumero() {
    Clipboard.setData(const ClipboardData(text: '0157865909'));
    setState(() => _isNumberCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Numéro copié dans le presse-papier !'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isNumberCopied = false);
    });
  }

  // ✅ 2. Fonction pour ouvrir WhatsApp (COPIE EXACTE DE LA LOGIQUE FORMATIONS)
  Future<void> _envoyerPreuveWhatsApp() async {
    // On encode TOUT le message d'un coup, exactement comme dans FormationsScreen
    final String message = Uri.encodeComponent(
      'Bonjour KH SERVICES. 👋\n\n'
      'Je viens d\'effectuer le paiement de *${widget.montant.toStringAsFixed(0)} FCFA* \n'
      'pour la formation : *${widget.formationTitle}*.\n\n'
      'Veuillez trouver ci-joint la capture d\'écran de mon reçu de transaction.\n'
      'Merci de bien vouloir valider mon inscription.'
    );

    final Uri url = Uri.parse('https://wa.me/$numeroWhatsApp?text=$message');

    // ✅ C'EST ICI LA CORRECTION : On essaie directement de lancer, sans passer par canLaunchUrl
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir WhatsApp. Vérifiez que l\'application est installée.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          'Paiement Mobile Money',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. RÉCAPITULATIF
            const Text(
              'Récapitulatif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
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

            // 2. INSTRUCTIONS DE PAIEMENT MOMO
            const Text(
              'Instructions de paiement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
                boxShadow: [_softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veuillez effectuer un transfert Mobile Money (MTN, Moov, Celtiis, Wave) vers :',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            momoName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            momoNumberDisplay,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. ÉTAPES À SUIVRE
            _buildStep('1', 'Faites le transfert du montant exact sur le numéro ci-dessus.'),
            const SizedBox(height: 12),
            _buildStep('2', 'Prenez une capture d\'écran du reçu de la transaction.'),
            const SizedBox(height: 12),
            _buildStep('3', 'Cliquez sur le bouton vert ci-dessous pour nous envoyer la preuve.'),
            
            const SizedBox(height: 40),
          ],
        ),
      ),

      // 4. BOUTON D'ACTION WHATSAPP
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
            child: ElevatedButton.icon(
              onPressed: _envoyerPreuveWhatsApp,
              icon: const Icon(Icons.wechat, color: Colors.white, size: 24), 
              label: const Text(
                'J\'ai payé, envoyer la preuve',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // Vert WhatsApp
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
        ),
      ],
    );
  }

  BoxShadow get _softShadow => BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );
}