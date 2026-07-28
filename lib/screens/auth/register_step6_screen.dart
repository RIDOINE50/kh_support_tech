import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart'; // ✅ Pour appeler l'inscription réelle
import '../main/main_screen.dart';              // ✅ Pour rediriger vers le Dashboard (adapte le chemin si ton fichier est ailleurs)

class RegisterStep6Screen extends StatefulWidget {
  // ✅ 1. ON REÇOIT LE SAC À DOS COMPLET DES ÉTAPES PRÉCÉDENTES
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
  bool _isLoading = false; // ✅ Pour gérer l'état de chargement

  @override
  Widget build(BuildContext context) {
    // ✅ 2. ON EXTRAIT LES VRAIES DONNÉES DU SAC À DOS (avec des valeurs par défaut au cas où)
    final profile = widget.formData['profile'] ?? 'Particulier';
    final nom = widget.formData['nom'] ?? 'KPATCHA';
    final prenom = widget.formData['prenom'] ?? 'Hounnonnon';
    final telephone = widget.formData['telephone'] ?? '+229 97 12 34 56';
    final email = widget.formData['email'] ?? 'kpatcha@gmail.com';
    final commune = widget.formData['commune'] ?? 'Abomey-Calavi';
    final departement = widget.formData['departement'] ?? 'Atlantique';

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

              // CARTE DE RÉSUMÉ (DYNAMIQUE)
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

              // CASES À COCHER (Conditions)
              _buildCheckboxRow(
                'J\'accepte les conditions générales d\'utilisation',
                _acceptTerms,
                (val) => setState(() => _acceptTerms = val ?? false),
              ),
              const SizedBox(height: 12),
              _buildCheckboxRow(
                'J\'accepte la politique de confidentialité',
                _acceptPrivacy,
                (val) => setState(() => _acceptPrivacy = val ?? false),
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
                      // ✅ 3. APPEL RÉEL À L'API LARAVEL
                      onPressed: (_acceptTerms && _acceptPrivacy && !_isLoading)
                          ? () async {
                              setState(() => _isLoading = true);

                              // Appel du service d'authentification avec TOUT le formData
                              AuthService authService = AuthService();
                              var result = await authService.registerComplete(widget.formData);

                              setState(() => _isLoading = false);

                              if (mounted) {
                                if (result['success'] == true) {
                                  // ✅ SUCCÈS : Message vert + Redirection directe au Dashboard
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ ${result['message']}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MainScreen()),
                                    (route) => false, // Efface l'historique pour qu'on ne puisse pas revenir en arrière
                                  );
                                } else {
                                  // ❌ ERREUR : Afficher le message de Laravel (ex: "L'email est déjà pris")
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('❌ ${result['error'] ?? 'Erreur lors de l\'inscription'}'),
                                      backgroundColor: Colors.red,
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

  // --- WIDGETS RÉUTILISABLES ---

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

  Widget _buildCheckboxRow(String text, bool value, ValueChanged<bool?> onChanged) {
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
              children: [
                TextSpan(
                  text: text,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.4),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}