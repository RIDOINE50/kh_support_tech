import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserCertificatsScreen extends StatefulWidget {
  const UserCertificatsScreen({super.key});

  @override
  State<UserCertificatsScreen> createState() => _UserCertificatsScreenState();
}

class _UserCertificatsScreenState extends State<UserCertificatsScreen> {
  List<dynamic> certificats = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserCertificats();
  }

  // Fonction pour récupérer uniquement les certificats de l'utilisateur connecté
  Future<void> fetchUserCertificats() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // ✅ Vérification des deux clés de token possibles
      String? token = prefs.getString('token') ?? prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          isLoading = false;
        });
        return;
      }

      // ✅ Requête vers l'API Laravel en ligne (Railway)
      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/certificats'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          certificats = data is List ? data : (data['data'] ?? []);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Token invalide. Veuillez vous reconnecter.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Impossible de charger vos certificats (Erreur ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion au serveur : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 1. DÉTECTION DU MODE SOMBRE ET COULEURS DYNAMIQUES
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : const Color(0xFFF3F4F6);
    final emptyIconColor = isDark ? Colors.grey[500]! : const Color(0xFF9CA3AF);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // ✅ Icône retour adaptative
        title: Text(
          'Mes certificats',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                )
              : certificats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucun certificat pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos attestations obtenues apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: certificats.length,
                      itemBuilder: (context, index) {
                        final cert = certificats[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor, // ✅ Fond de carte adaptatif
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor), // ✅ Bordure adaptative
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      cert['titre'] ?? cert['nom'] ?? 'Certificat #${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: textColor, // ✅ Texte adaptatif
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Formation : ${cert['formation_titre'] ?? cert['description'] ?? 'Non spécifié'}',
                                style: TextStyle(
                                  color: textSecondary, // ✅ Texte adaptatif
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Télécharger le PDF',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    cert['created_at'] != null 
                                        ? 'Obtenu le : ${cert['created_at'].toString().substring(0, 10)}' 
                                        : '',
                                    style: TextStyle(
                                      color: textSecondary, // ✅ Texte adaptatif
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}