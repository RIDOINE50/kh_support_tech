import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Import nécessaire pour le formateur de texte (date)
import '../../core/constants/app_colors.dart';
import 'register_step3_screen.dart'; // Import de l'étape suivante

class RegisterStep2Screen extends StatefulWidget {
  // 1. ON REÇOIT LE "SAC À DOS" (Map) DEPUIS L'ÉTAPE 1
  final Map<String, dynamic> formData;

  const RegisterStep2Screen({
    super.key, 
    required this.formData,
  });

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  // ✅ Contrôleurs vidés pour ne pas obliger l'utilisateur à effacer
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();

  String _sexe = 'homme'; // Valeur par défaut

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateController.dispose();
    _telController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER AVEC PROGRESSION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2B5B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    '2/6',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2B5B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // BARRE DE PROGRESSION
              Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < 2 ? const Color(0xFF0F2B5B) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // TITRE ET SOUS-TITRE
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              
              // ON AFFICHE LE PROFIL STOCKÉ DANS LE SAC À DOS
              Text(
                'Profil : ${widget.formData['profile'].toString().toUpperCase()}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0F2B5B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // FORMULAIRE SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nom', controller: _nomController, hintText: 'Entrez votre nom'),
                      const SizedBox(height: 16),
                      
                      _buildTextField('Prénom', controller: _prenomController, hintText: 'Entrez votre prénom'),
                      const SizedBox(height: 16),

                      // SÉLECTION DU SEXE
                      const Text(
                        'Sexe',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'homme',
                                  groupValue: _sexe,
                                  activeColor: const Color(0xFF0F2B5B),
                                  onChanged: (value) => setState(() => _sexe = value!),
                                ),
                                const Text('Homme', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'femme',
                                  groupValue: _sexe,
                                  activeColor: const Color(0xFF0F2B5B),
                                  onChanged: (value) => setState(() => _sexe = value!),
                                ),
                                const Text('Femme', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ✅ CHAMP DATE DE NAISSANCE (AVEC BARRES AUTOMATIQUES)
                      _buildTextField(
                        'Date de naissance',
                        controller: _dateController,
                        hintText: 'JJ/MM/AAAA', // Indice pour l'utilisateur
                        keyboardType: TextInputType.number, // Ouvre le clavier numérique
                        inputFormatters: [DateInputFormatter()], // Applique les barres automatiquement
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        'Téléphone', 
                        controller: _telController, 
                        keyboardType: TextInputType.phone,
                        hintText: 'Ex: +229 97 00 00 00',
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        'Adresse e-mail', 
                        controller: _emailController, 
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Ex: monadresse@email.com',
                      ),
                      const SizedBox(height: 32),

                      // BOUTONS PRÉCÉDENT ET SUIVANT
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                // 1. ON CRÉE UNE COPIE DU SAC À DOS ACTUEL
                                Map<String, dynamic> updatedData = Map.from(widget.formData);
                                
                                // 2. ON AJOUTE LES DONNÉES DE CETTE ÉTAPE 2
                                updatedData['nom'] = _nomController.text;
                                updatedData['prenom'] = _prenomController.text;
                                updatedData['sexe'] = _sexe;
                                updatedData['date_naissance'] = _dateController.text;
                                updatedData['telephone'] = _telController.text;
                                updatedData['email'] = _emailController.text;

                                // 3. ON NAVIGUE VERS L'ÉTAPE 3 EN LUI DONNANT LE SAC À DOS MIS À JOUR
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegisterStep3Screen(formData: updatedData),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F2B5B),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Suivant', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET RÉUTILISABLE POUR LES CHAMPS DE TEXTE
  // ✅ Ajout des paramètres `hintText` et `inputFormatters`
  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters, // Applique les formatteurs de texte (comme la date)
          decoration: InputDecoration(
            hintText: hintText, // Texte indicatif gris clair
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0F2B5B), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ CLASSE POUR AJOUTER AUTOMATIQUEMENT LES BARRES (/) DANS LA DATE
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 1. On retire toutes les barres existantes pour ne garder que les chiffres
    String text = newValue.text.replaceAll('/', ''); 
    
    // 2. On limite la longueur à 8 chiffres maximum (JJMMAAAA)
    if (text.length > 8) {
      text = text.substring(0, 8); 
    }
    
    // 3. On reconstruit la chaîne en ajoutant les barres aux bons endroits
    String newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        newText += '/';
      }
      newText += text[i];
    }
    
    // 4. On retourne la nouvelle valeur avec le curseur placé à la fin
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}