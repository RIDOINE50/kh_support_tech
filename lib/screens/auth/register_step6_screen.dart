import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ AJOUTÉ : Pour sauvegarder les données
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../main/main_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'app_legal_texts.dart';

class RegisterStep6Screen extends StatefulWidget {
  final Map<String, dynamic> formData;

  const RegisterStep6Screen({
    super.key, 
    required this.formData,
  });

  @override
  State<RegisterStep6Screen> createState() => _RegisterStep6ScreenState();
}

class _RegisterStep6ScreenState extends State<RegisterStep6Screen> {
  bool _acceptTerms = true;
  bool _acceptPrivacy = true;
  bool _isLoading = false;

  void _openLegalScreen(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsAndConditionsScreen(
          title: title,
          content: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.formData['profile'] ?? 'Particulier';
    final nom = widget.formData['nom'] ?? '';
    final prenom = widget.formData['prenom'] ?? '';
    final telephone = widget.formData['telephone'] ?? '';
    final email = widget.formData['email'] ?? '';
    final commune = widget.formData['commune'] ?? '';
    final departement = widget.formData['departement'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER & PROGRESSION (6/6)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Étape 6 sur 6',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                  ),
                  const Text(
                    '6/6',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2B5B)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2B5B),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // TITRE ET SOUS-TITRE
              const Text(
                'Récapitulatif',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vérifiez vos informations avant de\ncréer votre compte.',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
              ),
              const SizedBox(height: 24),

              // CARTE DE RÉSUMÉ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(Icons.person_outline, 'Profil', profile.toString().toUpperCase()),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildSummaryRow(Icons.badge_outlined, 'Nom complet', '$nom $prenom'),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildSummaryRow(Icons.phone_outlined, 'Téléphone', telephone),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildSummaryRow(Icons.email_outlined, 'E-mail', email),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildSummaryRow(Icons.location_on_outlined, 'Localisation', '$commune, $departement'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CASES À COCHER AVEC LIENS CLIQUABLES
              _buildLegalCheckboxRow(
                prefixText: 'J\'accepte les ',
                linkText: 'conditions générales d\'utilisation',
                onTapLink: () => _openLegalScreen(AppLegalTexts.termsTitle, AppLegalTexts.termsContent),
                value: _acceptTerms,
                onChanged: (val) => setState(() => _acceptTerms = val ?? false),
              ),
              const SizedBox(height: 12),
              _buildLegalCheckboxRow(
                prefixText: 'J\'accepte la ',
                linkText: 'politique de confidentialité',
                onTapLink: () => _openLegalScreen(AppLegalTexts.privacyTitle, AppLegalTexts.privacyContent),
                value: _acceptPrivacy,
                onChanged: (val) => setState(() => _acceptPrivacy = val ?? false),
              ),
              const Spacer(),

              // BOUTONS FINAUX
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF374151),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Précédent', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: (_acceptTerms && _acceptPrivacy && !_isLoading)
                          ? () async {
                              setState(() => _isLoading = true);

                              AuthService authService = AuthService();
                              var result = await authService.registerComplete(widget.formData);

                              if (mounted) {
                                setState(() => _isLoading = false);

                                if (result['success'] == true) {
                                  // ✅ SAUVEGARDE DES DONNÉES DANS LE TÉLÉPHONE
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  
                                  // 1. Sauvegarder le token (pour rester connecté)
                                  if (result['token'] != null) {
                                    await prefs.setString('token', result['token']);
                                  } else if (result['access_token'] != null) {
                                    await prefs.setString('token', result['access_token']);
                                  }

                                  // 2. Sauvegarder le nom complet et l'email (pour le profil)
                                  final fullName = '$nom $prenom'.trim();
                                  await prefs.setString('name', fullName.isNotEmpty ? fullName : 'Utilisateur');
                                  await prefs.setString('email', email.isNotEmpty ? email : 'email@exemple.com');

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ ${result['message']}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MainScreen()),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('❌ ${result['error'] ?? 'Erreur lors de l\'inscription'}'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 4),
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? const Color(0xFF9CA3AF) : const Color(0xFF22C55E),
                        disabledBackgroundColor: const Color(0xFF9CA3AF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Créer mon compte', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.check, color: Colors.white, size: 18),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalCheckboxRow({
    required String prefixText,
    required String linkText,
    required VoidCallback onTapLink,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            activeColor: const Color(0xFF0F2B5B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.4),
              children: [
                TextSpan(text: prefixText),
                TextSpan(
                  text: linkText,
                  style: const TextStyle(
                    color: Color(0xFF0F2B5B),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTapLink,
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}