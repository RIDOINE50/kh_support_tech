import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'register_step5_screen.dart';

class RegisterStep4Screen extends StatefulWidget {
  final Map<String, dynamic> formData;

  const RegisterStep4Screen({super.key, required this.formData});

  @override
  State<RegisterStep4Screen> createState() => _RegisterStep4ScreenState();
}

class _RegisterStep4ScreenState extends State<RegisterStep4Screen> {
  // --- CONTRÔLEURS SPÉCIFIQUES PAR PROFIL ---
  
  // Entreprise
  final _nomEntrepriseCtrl = TextEditingController();
  final _ifuCtrl = TextEditingController();
  final _rccmCtrl = TextEditingController();
  final _fonctionContactCtrl = TextEditingController();
  String? _secteurActivite;
  String? _nbEmployes;

  // Élève / Étudiant
  final _etablissementCtrl = TextEditingController();
  String? _classeNiveau;

  // Administration
  final _ministereCtrl = TextEditingController();
  final _matriculeCtrl = TextEditingController();
  String? _fonctionAdmin;

  // Professionnel
  final _entrepriseProCtrl = TextEditingController();
  final _specialiteCtrl = TextEditingController();
  String? _profession;
  String? _experience;

  @override
  void dispose() {
    // Nettoyage de TOUS les contrôleurs pour éviter les fuites de mémoire
    _nomEntrepriseCtrl.dispose();
    _ifuCtrl.dispose();
    _rccmCtrl.dispose();
    _fonctionContactCtrl.dispose();
    _etablissementCtrl.dispose();
    _ministereCtrl.dispose();
    _matriculeCtrl.dispose();
    _entrepriseProCtrl.dispose();
    _specialiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.formData['profile'];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2B5B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('4/6', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2B5B))),
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
                        color: index < 4 ? const Color(0xFF0F2B5B) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              
              Text(
                _getTitleForProfile(profile),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 8),
              Text(
                'Profil : ${profile.toString().toUpperCase()}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F2B5B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ AFFICHAGE DYNAMIQUE ET RICHE DES CHAMPS
                      _buildDynamicFields(profile),
                      const SizedBox(height: 32),

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
                                // ✅ SAUVEGARDE INTELLIGENTE DES DONNÉES SELON LE PROFIL
                                Map<String, dynamic> updatedData = Map.from(widget.formData);

                                if (profile == 'entreprise') {
                                  updatedData['nom_entreprise'] = _nomEntrepriseCtrl.text;
                                  updatedData['ifu'] = _ifuCtrl.text;
                                  updatedData['rccm'] = _rccmCtrl.text;
                                  updatedData['secteur_activite'] = _secteurActivite;
                                  updatedData['nb_employes'] = _nbEmployes;
                                  updatedData['fonction_contact'] = _fonctionContactCtrl.text;
                                } 
                                else if (profile == 'eleve' || profile == 'etudiant') {
                                  updatedData['etablissement'] = _etablissementCtrl.text;
                                  updatedData['classe_niveau'] = _classeNiveau;
                                } 
                                else if (profile == 'administration' || profile == 'collectivite') {
                                  updatedData['ministere_direction'] = _ministereCtrl.text;
                                  updatedData['matricule'] = _matriculeCtrl.text;
                                  updatedData['fonction_admin'] = _fonctionAdmin;
                                } 
                                else if (profile == 'professionnel' || profile == 'enseignant') {
                                  updatedData['entreprise_actuelle'] = _entrepriseProCtrl.text;
                                  updatedData['specialite'] = _specialiteCtrl.text;
                                  updatedData['profession'] = _profession;
                                  updatedData['experience'] = _experience;
                                } 
                                else {
                                  // Particulier, ONG, Association
                                  updatedData['nom_organisation'] = _nomEntrepriseCtrl.text; // Réutilise un contrôleur
                                  updatedData['activite_principale'] = _ifuCtrl.text;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegisterStep5Screen(formData: updatedData),
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

  // --- MÉTHODES DYNAMIQUES ---

  String _getTitleForProfile(String? profile) {
    switch (profile) {
      case 'entreprise': return 'Informations de l\'Entreprise';
      case 'eleve':
      case 'etudiant': return 'Informations Scolaires';
      case 'administration':
      case 'collectivite': return 'Informations Administratives';
      case 'enseignant':
      case 'professionnel': return 'Informations Professionnelles';
      default: return 'Informations Complémentaires';
    }
  }

  Widget _buildDynamicFields(String? profile) {
    switch (profile) {
      case 'entreprise':
        return Column(
          children: [
            _buildTextField('Nom de l\'entreprise', controller: _nomEntrepriseCtrl, hint: 'Ex: Tech Solutions', isRequired: true),
            const SizedBox(height: 16),
            _buildDropdownField('Secteur d\'activité', _secteurActivite, ['Informatique', 'Commerce', 'Services', 'BTP', 'Agriculture', 'Autre'], (v) => setState(() => _secteurActivite = v), isRequired: true),
            const SizedBox(height: 16),
            _buildTextField('Numéro IFU', controller: _ifuCtrl, hint: 'Numéro d\'identification fiscale', isRequired: false),
            const SizedBox(height: 16),
            _buildTextField('Numéro RCCM', controller: _rccmCtrl, hint: 'Registre du commerce', isRequired: false),
            const SizedBox(height: 16),
            _buildDropdownField('Nombre d\'employés', _nbEmployes, ['1 - 10', '11 - 50', '51 - 200', 'Plus de 200'], (v) => setState(() => _nbEmployes = v), isRequired: false),
            const SizedBox(height: 16),
            _buildTextField('Fonction du contact', controller: _fonctionContactCtrl, hint: 'Ex: Directeur Général, RH', isRequired: true),
          ],
        );
      
      case 'eleve':
      case 'etudiant':
        return Column(
          children: [
            _buildTextField('Nom de l\'établissement', controller: _etablissementCtrl, hint: 'Ex: Lycée Bélier, Université d\'Abomey', isRequired: true),
            const SizedBox(height: 16),
            _buildDropdownField('Classe / Niveau', _classeNiveau, ['6ème', '3ème', 'Seconde', 'Terminale', 'Licence', 'Master', 'Doctorat'], (v) => setState(() => _classeNiveau = v), isRequired: true),
          ],
        );

      case 'administration':
      case 'collectivite':
        return Column(
          children: [
            _buildTextField('Ministère / Direction', controller: _ministereCtrl, hint: 'Ex: Ministère de l\'Éducation', isRequired: true),
            const SizedBox(height: 16),
            _buildDropdownField('Fonction', _fonctionAdmin, ['Directeur', 'Sous-Directeur', 'Chef de service', 'Agent', 'Autre'], (v) => setState(() => _fonctionAdmin = v), isRequired: true),
            const SizedBox(height: 16),
            _buildTextField('Matricule / Grade', controller: _matriculeCtrl, hint: 'Ex: 12345/A', isRequired: false),
          ],
        );

      case 'enseignant':
      case 'professionnel':
        return Column(
          children: [
            _buildDropdownField('Profession', _profession, ['Développeur', 'Enseignant', 'Consultant', 'Médecin', 'Avocat', 'Autre'], (v) => setState(() => _profession = v), isRequired: true),
            const SizedBox(height: 16),
            _buildTextField('Entreprise / Établissement', controller: _entrepriseProCtrl, hint: 'Lieu de travail actuel', isRequired: false),
            const SizedBox(height: 16),
            _buildDropdownField('Expérience', _experience, ['Débutant (0-2 ans)', 'Intermédiaire (3-5 ans)', 'Confirmé (6-10 ans)', 'Expert (+10 ans)'], (v) => setState(() => _experience = v), isRequired: false),
            const SizedBox(height: 16),
            _buildTextField('Spécialité', controller: _specialiteCtrl, hint: 'Ex: Cybersécurité, Mathématiques', isRequired: false),
          ],
        );

      default: // Particulier, ONG, Association
        return Column(
          children: [
            _buildTextField('Nom de l\'organisation (si applicable)', controller: _nomEntrepriseCtrl, hint: 'Facultatif', isRequired: false),
            const SizedBox(height: 16),
            _buildTextField('Activité principale', controller: _ifuCtrl, hint: 'Ex: Commerce, Agriculture, Humanitaire', isRequired: false),
          ],
        );
    }
  }

  Widget _buildTextField(String label, {required TextEditingController controller, String? hint, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F2B5B), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text('Sélectionnez', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF111827))),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}