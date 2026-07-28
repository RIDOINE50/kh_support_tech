// Fichier : lib/screen/devis/importer_document_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class ImporterDocumentScreen extends StatefulWidget {
  const ImporterDocumentScreen({super.key});

  @override
  State<ImporterDocumentScreen> createState() => _ImporterDocumentScreenState();
}

class _ImporterDocumentScreenState extends State<ImporterDocumentScreen> {
  bool _isLoading = false;
  String _categorieSelected = 'Matériel informatique';
  final _descriptionController = TextEditingController();
  
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _choisirFichier() async {
    try {
      debugPrint('[DEBUG] Ouverture du sélecteur de fichiers...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'zip', 'jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });

        debugPrint('[DEBUG] Fichier sélectionné avec succès :');
        debugPrint('  - Nom : ${_selectedFile!.name}');
        debugPrint('  - Taille : ${_selectedFile!.size} octets');
        debugPrint('  - Chemin (Path) : ${_selectedFile!.path}');
        debugPrint('  - Bytes dispos ? : ${_selectedFile!.bytes != null}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fichier sélectionné : ${_selectedFile!.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        debugPrint('[DEBUG] Sélection de fichier annulée par l\'utilisateur.');
      }
    } catch (e) {
      debugPrint('[ERREUR] Exception lors de la sélection du fichier : $e');
      _showErrorDialog("Erreur lors de la sélection du fichier : $e");
    }
  }

  Future<void> _envoyerDemandeDocument() async {
    if (_selectedFile == null) {
      debugPrint('[AVERTISSEMENT] Tentative d\'envoi sans fichier sélectionné.');
      _showErrorDialog("Veuillez d'abord choisir un fichier valide avant d'envoyer.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('[DEBUG] Récupération du token d\'authentification...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      debugPrint('[DEBUG] Token récupéré : ${token.isNotEmpty ? "${token.substring(0, 15)}..." : "VIDE"}');

      if (token.isEmpty) {
        setState(() { _isLoading = false; });
        debugPrint('[ERREUR] Session expirée : Aucun token trouvé.');
        _showErrorDialog("Session expirée. Veuillez vous reconnecter.");
        return;
      }

      const String apiUrl = 'https://kh-support-backend-production.up.railway.app/api/devis';
      debugPrint('[DEBUG] Préparation de la requête Multipart POST vers : $apiUrl');

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      debugPrint('[DEBUG] Headers de la requête : ${request.headers}');

      request.fields['type'] = _categorieSelected;
      request.fields['sujet'] = 'Document joint : ${_selectedFile!.name}';
      
      if (_descriptionController.text.trim().isNotEmpty) {
        request.fields['description'] = _descriptionController.text.trim();
      }
      debugPrint('[DEBUG] Champs (Fields) envoyés : ${request.fields}');

      if (_selectedFile!.bytes != null) {
        debugPrint('[DEBUG] Ajout du fichier via les bytes (Web / Mémoire).');
        request.files.add(
          http.MultipartFile.fromBytes(
            'fichier', 
            _selectedFile!.bytes!,
            filename: _selectedFile!.name,
          ),
        );
      } else if (_selectedFile!.path != null) {
        debugPrint('[DEBUG] Ajout du fichier via le chemin local : ${_selectedFile!.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'fichier',
            _selectedFile!.path!,
            filename: _selectedFile!.name,
          ),
        );
      } else {
        debugPrint('[ERREUR] Impossible de joindre le fichier : ni path ni bytes disponibles.');
      }

      debugPrint('[DEBUG] Envoi de la requête au serveur en cours...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      setState(() {
        _isLoading = false;
      });

      debugPrint('[DEBUG] Réponse reçue du serveur :');
      debugPrint('  - Code Statut : ${response.statusCode}');
      debugPrint('  - Corps de la réponse (Body) :\n${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('[SUCCÈS] Document et demande transmis avec succès.');
        _showSuccessDialog();
      } else {
        debugPrint('[ERREUR] Le serveur a rejeté la requête avec le code ${response.statusCode}');
        try {
          var errorData = jsonDecode(response.body);
          String message = errorData['message'] ?? response.body;
          if (errorData['errors'] != null) {
            var errors = errorData['errors'] as Map;
            message += "\n" + errors.values.map((e) => e.join(', ')).join("\n");
          }
          _showErrorDialog('Erreur ${response.statusCode} :\n$message');
        } catch (_) {
          _showErrorDialog('Erreur du serveur (${response.statusCode}) : ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('[ERREUR CRITIQUE] Exception attrapée lors de l\'envoi : $e');
      _showErrorDialog('Impossible de joindre le serveur : $e');
    }
  }

  void _showSuccessDialog() {
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
              'Votre document et votre demande ont été transmis avec succès à l\'administrateur.',
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
        backgroundColor: Theme.of(context).cardColor, // ✅ Fond de dialog adaptatif
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text('Erreur', style: TextStyle(color: textColor)),
          ],
        ),
        content: SingleChildScrollView(child: Text(message, style: TextStyle(color: textColor))),
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
    final overlayColor = Colors.black.withOpacity(isDark ? 0.6 : 0.3);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        title: Text(
          'Joindre un document',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // ✅ Icône adaptative
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zone de dépôt de fichier
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor, // ✅ Fond adaptatif
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.02), // ✅ Ombre adaptative
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 50, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFile == null ? 'Déposez votre fichier ici' : 'Fichier sélectionné :',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor), // ✅ Texte adaptatif
                      ),
                      const SizedBox(height: 4),
                      
                      if (_selectedFile != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15), // ✅ Mieux visible en mode sombre que Colors.blue
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.insert_drive_file, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _selectedFile!.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text('ou', style: TextStyle(fontSize: 12, color: textSecondary)), // ✅ Texte adaptatif
                      ],

                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _choisirFichier,
                        icon: const Icon(Icons.folder_open, size: 18),
                        label: Text(
                          _selectedFile == null ? 'Choisir un fichier' : 'Changer de fichier', 
                          style: const TextStyle(fontWeight: FontWeight.w600)
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Formats acceptés : PDF, DOC, DOCX, XLS, XLSX, ZIP, JPG, PNG\nTaille maximale : 5 Mo',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: textSecondary, height: 1.4), // ✅ Texte adaptatif
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Catégorie *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)), // ✅ Texte adaptatif
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
                              onChanged: (val) {
                                setState(() {
                                  _categorieSelected = val!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down, color: textColor), // ✅ Icône adaptative
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Description (facultative)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)), // ✅ Texte adaptatif
                        const SizedBox(height: 6),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          style: TextStyle(color: textColor), // ✅ Texte saisi adaptatif
                          decoration: InputDecoration(
                            hintText: 'Ajouter une précision sur le document...',
                            hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)), // ✅ Hint adaptatif
                            filled: true,
                            fillColor: cardColor, // ✅ Fond du champ adaptatif
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: (_isLoading || _selectedFile == null) ? null : _envoyerDemandeDocument,
                    child: const Text('Envoyer votre demande', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
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
}