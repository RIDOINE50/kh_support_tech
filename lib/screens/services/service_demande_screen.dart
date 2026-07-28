import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:kh_support_tech/models/service_model.dart';
import '../../services/auth_service.dart'; // Ajuste le chemin si nécessaire

class ServiceDemandeScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDemandeScreen({super.key, required this.service});

  @override
  State<ServiceDemandeScreen> createState() => _ServiceDemandeScreenState();
}

class _ServiceDemandeScreenState extends State<ServiceDemandeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _adresseController.dispose();
    _telephoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _soumettreDemande() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> serviceData = {
        'service_id': widget.service.id,
        'description_probleme': _descriptionController.text.trim(),
        'adresse_intervention': _adresseController.text.trim(),
        'telephone_contact': _telephoneController.text.trim(),
        if (_dateController.text.trim().isNotEmpty)
          'date_souhaitee': _dateController.text.trim(),
      };

      final authService = AuthService();
      final resultat = await authService.soumettreDemandeService(serviceData);

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (resultat['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultat['message'] ?? 'Votre demande a été envoyée avec succès !'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultat['error'] ?? 'Une erreur est survenue.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur inattendue : $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Détection du mode sombre pour adapter les couleurs
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final iconColor = Theme.of(context).iconTheme.color ?? (isDark ? Colors.grey[400]! : Colors.grey);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor), // ✅ Icône adaptative
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Demande de service',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Résumé du service choisi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15), // Légèrement plus visible en mode sombre
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.build, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.nom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Prix estimé : ${widget.service.prixBase.toStringAsFixed(0)} FCFA',
                            style: TextStyle(fontSize: 14, color: textSecondary), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Décrivez votre problème',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor), // ✅ Texte adaptatif
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: TextStyle(color: textColor), // ✅ Texte saisie adaptatif
                decoration: InputDecoration(
                  hintText: 'Ex: Mon ordinateur ne s\'allume plus, écran noir...',
                  hintStyle: TextStyle(color: textSecondary), // ✅ Hint adaptatif
                  prefixIcon: Icon(Icons.description_outlined, color: iconColor), // ✅ Icône adaptative
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez décrire le problème';
                }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Adresse d\'intervention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _adresseController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Ex: Quartier Résidentiel, Rue 12, Porte 4',
                  hintStyle: TextStyle(color: textSecondary),
                  prefixIcon: Icon(Icons.location_on_outlined, color: iconColor),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Numéro de téléphone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Ex: +229 97 00 00 00',
                  hintStyle: TextStyle(color: textSecondary),
                  prefixIcon: Icon(Icons.phone_outlined, color: iconColor),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Date souhaitée (Optionnel)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Ex: Sélectionnez une date',
                  hintStyle: TextStyle(color: textSecondary),
                  prefixIcon: Icon(Icons.calendar_today_outlined, color: iconColor),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          // ✅ Le sélecteur de date s'adapte maintenant au mode sombre !
                          colorScheme: isDark
                              ? const ColorScheme.dark(primary: AppColors.primary)
                              : const ColorScheme.light(primary: AppColors.primary),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      final String month = picked.month.toString().padLeft(2, '0');
                      final String day = picked.day.toString().padLeft(2, '0');
                      _dateController.text = "${picked.year}-$month-$day";
                    });
                  }
                },
              ),
              const SizedBox(height: 32),

              // Bouton d'envoi
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _soumettreDemande,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Envoyer la demande',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}