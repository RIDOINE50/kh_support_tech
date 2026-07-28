import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserCommandesScreen extends StatefulWidget {
  const UserCommandesScreen({super.key});

  @override
  State<UserCommandesScreen> createState() => _UserCommandesScreenState();
}

class _UserCommandesScreenState extends State<UserCommandesScreen> {
  List<dynamic> commandes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserCommandes();
  }

  Future<void> fetchUserCommandes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/commandes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> mesCommandes = [];
        
        // On extrait la liste de manière très robuste
        if (decodedData is List) {
          mesCommandes = decodedData;
        } else if (decodedData is Map) {
          mesCommandes = decodedData['data'] ?? decodedData['commandes'] ?? [];
        }

        setState(() {
          commandes = mesCommandes;
          isLoading = false;
          errorMessage = ''; 
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Token invalide ou expiré. Veuillez vous reconnecter.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print("❌ ERREUR FATALE FLUTTER: $e");
      setState(() {
        errorMessage = 'Erreur de traitement: $e';
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
          'Mes commandes',
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        if (errorMessage.contains('Session expirée') || errorMessage.contains('Token invalide'))
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Se reconnecter'),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : commandes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucune commande pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos futurs achats apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: commandes.length,
                      itemBuilder: (context, index) {
                        final cmd = commandes[index];
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
                                  Text(
                                    'Commande #${cmd['id'] ?? (index + 1)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: textColor, // ✅ Texte adaptatif
                                    ),
                                  ),
                                  Text(
                                    '${cmd['montant_total'] ?? cmd['total'] ?? 0} FCFA',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Articles : ${cmd['description_articles'] ?? cmd['articles'] ?? 'Non spécifié'}',
                                style: TextStyle(
                                  color: textSecondary, // ✅ Texte adaptatif
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mode : ${cmd['mode_livraison'] ?? 'Standard'}',
                                    style: TextStyle(
                                      color: textSecondary, // ✅ Texte adaptatif
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    cmd['created_at'] != null 
                                        ? cmd['created_at'].toString().substring(0, 10) 
                                        : 'Date inconnue',
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