// Fichier : lib/screen/devis/formulaire_devis_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class FormulaireDevisScreen extends StatefulWidget {
  const FormulaireDevisScreen({super.key});

  @override
  State<FormulaireDevisScreen> createState() => _FormulaireDevisScreenState();
}

class _FormulaireDevisScreenState extends State<FormulaireDevisScreen> {
  int _currentStep = 0; // 0: Informations, 1: Détails, 2: Récapitulatif
  bool _isLoading = false;

  // Contrôleurs pour les champs de saisie
  final _entrepriseController = TextEditingController(text: 'ETS Global Services');
  final _contactController = TextEditingController(text: 'Marc Houndé');
  final _telephoneController = TextEditingController(text: '+229 97 34 56 78');
  final _emailController = TextEditingController(text: 'contact@ets-global.com');

  String _categorieSelected = 'Matériel informatique';
  final _objetController = TextEditingController(text: 'Fourniture de 20 ordinateurs portables');
  final _descriptionController = TextEditingController(
    text: 'Nous souhaitons acquérir 20 ordinateurs portables avec les caractéristiques suivantes :\n- Processeur i5 ou équivalent\n- RAM 8 Go minimum\n- Disque dur SSD 512 Go\n- Windows 11\nMerci de nous faire votre meilleure proposition.',
  );
  final _quantiteController = TextEditingController(text: '20');
  final _dateSouhaiteeController = TextEditingController(text: '15/08/2026');
  final _adresseController = TextEditingController(text: 'Parakou, Quartier Bannikanni, Bénin');

  @override
  void dispose() {
    _entrepriseController.dispose();
    _contactController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _objetController.dispose();
    _descriptionController.dispose();
    _quantiteController.dispose();
    _dateSouhaiteeController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _envoyerDemandeAdmin();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _envoyerDemandeAdmin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("\n==================================================");
      print("🚀 DÉBUT DE LA TENTATIVE D'ENVOI DU DEVIS");
      print("==================================================");

      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token') ?? prefs.getString('access_token');

      print("🔑 Token récupéré depuis SharedPreferences : $token");

      if (token == null || token.isEmpty) {
        print("❌ ERREUR : Aucun token trouvé ! L'utilisateur n'est pas authentifié.");
        setState(() => _isLoading = false);
        _showErrorDialog('Vous devez être connecté pour envoyer un devis. Veuillez vous reconnecter.');
        return;
      }

      final Map<String, dynamic> donneesDemande = {
        'type': _categorieSelected,
        'entreprise': _entrepriseController.text,
        'contact': _contactController.text,
        'telephone': _telephoneController.text,
        'email': _emailController.text,
        'sujet': _objetController.text, 
        'description': _descriptionController.text,
        'quantite': int.tryParse(_quantiteController.text) ?? 1,
        'date_souhaitee': _dateSouhaiteeController.text,
        'adresse': _adresseController.text,
      };

      print("📦 Données prêtes à être envoyées au serveur :");
      donneesDemande.forEach((cle, valeur) {
        print("   - $cle : $valeur (${valeur.runtimeType})");
      });

      print("📤 Appel de l'ApiService...");

      final apiService = ApiService();
      final result = await apiService.demanderDevis(
        devisFields: donneesDemande,
        file: null, 
        token: token,
      );

      print("📥 RÉSULTAT RETOURNÉ PAR APISERVICE :");
      print(jsonEncode(result));
      print("==================================================\n");

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(result['error'] ?? result['message'] ?? 'Erreur lors de l\'envoi du devis.');
      }
    } catch (e, stackTrace) {
      print("\n❌❌❌ ERREUR CRITIQUE DANS FLUTTER ❌❌❌");
      print("Message : $e");
      print("Trace : $stackTrace");
      print("==================================================\n");

      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erreur de connexion : $e');
    }
  }

  void _showSuccessDialog() {
    // Détection du thème pour la dialog
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.black54;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor, // ✅ Fond de dialog adaptatif
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Demande envoyée !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre demande de devis a été transmise avec succès à l\'administrateur. Vous pouvez suivre son avancement dans l\'onglet "Mes demandes".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pop(context); 
                },
                child: const Text('Terminer', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text('Erreur Serveur', style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 14, color: textColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade300;
    final inactiveStepBg = isDark ? Colors.grey[800]! : Colors.grey.shade300;
    final inactiveStepText = isDark ? Colors.grey[400]! : Colors.grey.shade600;
    final overlayColor = Colors.black.withOpacity(isDark ? 0.6 : 0.3);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        title: Text(
          _currentStep == 2 ? 'Récapitulatif' : 'Remplir le formulaire',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // ✅ Icône adaptative
          onPressed: _prevStep,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Indicateur d'étape
              Container(
                color: cardColor, // ✅ Fond de la barre d'étape adaptatif
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(0, 'Informations', inactiveStepBg, inactiveStepText, textColor),
                    _buildStepDivider(borderColor),
                    _buildStepIndicator(1, 'Détails', inactiveStepBg, inactiveStepText, textColor),
                    _buildStepDivider(borderColor),
                    _buildStepIndicator(2, 'Récapitulatif', inactiveStepBg, inactiveStepText, textColor),
                  ],
                ),
              ),
              Divider(height: 1, color: borderColor), // ✅ Séparateur adaptatif
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildCurrentStepContent(cardColor, textColor, textSecondary, borderColor),
                ),
              ),
              // Barre d'action en bas
              Container(
                padding: const EdgeInsets.all(16),
                color: cardColor, // ✅ Fond de la barre d'action adaptatif
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            foregroundColor: AppColors.primary,
                          ),
                          onPressed: _isLoading ? null : _prevStep,
                          child: const Text('Retour', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _nextStep,
                        child: Text(
                          _currentStep == 2 ? 'Envoyer votre demande' : 'Suivant',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: overlayColor, // ✅ Overlay adaptatif (plus sombre en mode nuit)
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title, Color inactiveBg, Color inactiveText, Color textColor) {
    bool isActive = _currentStep >= stepIndex;
    bool isCurrent = _currentStep == stepIndex;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : inactiveBg, // ✅ Fond adaptatif
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: AppColors.secondary, width: 2) : null,
          ),
          child: Center(
            child: Text(
              '${stepIndex + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : inactiveText, // ✅ Texte adaptatif
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isCurrent ? AppColors.primary : textColor, // ✅ Texte adaptatif
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(Color borderColor) {
    return Container(
      width: 40,
      height: 2,
      color: borderColor, // ✅ Couleur adaptative
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    );
  }

  Widget _buildCurrentStepContent(Color cardColor, Color textColor, Color textSecondary, Color borderColor) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Informations(cardColor, textColor, textSecondary, borderColor);
      case 1:
        return _buildStep2Details(cardColor, textColor, textSecondary, borderColor);
      case 2:
        return _buildStep3Recapitulatif(cardColor, textColor, borderColor);
      default:
        return Container();
    }
  }

  Widget _buildStep1Informations(Color cardColor, Color textColor, Color textSecondary, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informations générales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 16),
        _buildTextField('Nom de l\'entreprise *', _entrepriseController, cardColor, textColor, textSecondary, borderColor),
        const SizedBox(height: 12),
        _buildTextField('Personne de contact *', _contactController, cardColor, textColor, textSecondary, borderColor),
        const SizedBox(height: 12),
        _buildTextField('Téléphone *', _telephoneController, cardColor, textColor, textSecondary, borderColor, keyboardType: TextInputType.phone),
        const SizedBox(height: 12),
        _buildTextField('Email *', _emailController, cardColor, textColor, textSecondary, borderColor, keyboardType: TextInputType.emailAddress),
      ],
    );
  }

  Widget _buildStep2Details(Color cardColor, Color textColor, Color textSecondary, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Détails de la demande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 16),
        Text('Catégorie *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor, // ✅ Fond adaptatif
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor), // ✅ Bordure adaptative
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _categorieSelected,
              isExpanded: true,
              style: TextStyle(color: textColor), // ✅ Texte du dropdown adaptatif
              items: ['Matériel informatique', 'Réseaux & Télécoms', 'Développement Logiciel', 'Formations']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: TextStyle(fontSize: 14, color: textColor))))
                  .toList(),
              onChanged: (val) => setState(() => _categorieSelected = val!),
              icon: Icon(Icons.arrow_drop_down, color: textColor), // ✅ Icône adaptative
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField('Objet de la demande *', _objetController, cardColor, textColor, textSecondary, borderColor),
        const SizedBox(height: 12),
        _buildTextField('Description détaillée *', _descriptionController, cardColor, textColor, textSecondary, borderColor, maxLines: 5),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField('Quantité *', _quantiteController, cardColor, textColor, textSecondary, borderColor, keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Date souhaitée *', _dateSouhaiteeController, cardColor, textColor, textSecondary, borderColor, suffixIcon: Icons.calendar_today)),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField('Adresse de livraison *', _adresseController, cardColor, textColor, textSecondary, borderColor),
      ],
    );
  }

  Widget _buildStep3Recapitulatif(Color cardColor, Color textColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Récapitulatif de votre demande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 16),
        _buildRecapSection('Informations générales', [
          'Entreprise : ${_entrepriseController.text}',
          'Contact : ${_contactController.text}',
          'Téléphone : ${_telephoneController.text}',
          'Email : ${_emailController.text}',
        ], cardColor, textColor, borderColor),
        const SizedBox(height: 16),
        _buildRecapSection('Détails de la demande', [
          'Catégorie : $_categorieSelected',
          'Objet : ${_objetController.text}',
          'Quantité : ${_quantiteController.text}',
          'Date souhaitée : ${_dateSouhaiteeController.text}',
          'Adresse : ${_adresseController.text}',
          'Description :\n${_descriptionController.text}',
        ], cardColor, textColor, borderColor),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Color cardColor, Color textColor, Color textSecondary, Color borderColor, {int maxLines = 1, TextInputType? keyboardType, IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor), // ✅ Texte saisi adaptatif
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor, // ✅ Fond du champ adaptatif
            hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)), // ✅ Hint adaptatif
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18, color: AppColors.primary) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildRecapSection(String title, List<String> details, Color cardColor, Color textColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor, // ✅ Fond adaptatif
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor), // ✅ Bordure adaptative
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Divider(height: 16, color: borderColor), // ✅ Séparateur adaptatif
          ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(detail, style: TextStyle(fontSize: 12, color: textColor, height: 1.3)), // ✅ Texte adaptatif
              )),
        ],
      ),
    );
  }
}