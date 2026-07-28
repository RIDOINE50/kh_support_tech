import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserFacturesScreen extends StatefulWidget {
  const UserFacturesScreen({super.key});

  @override
  State<UserFacturesScreen> createState() => _UserFacturesScreenState();
}

class _UserFacturesScreenState extends State<UserFacturesScreen> {
  List<dynamic> factures = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserFactures();
  }

  // Fonction pour récupérer uniquement les factures de l'utilisateur connecté
  Future<void> fetchUserFactures() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // ✅ Vérification des deux clés de token possibles pour plus de robustesse
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
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/factures'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          factures = data is List ? data : (data['data'] ?? []);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Token invalide. Veuillez vous reconnecter.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Impossible de charger vos factures (Erreur ${response.statusCode})';
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
          'Mes factures',
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
              : factures.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucune facture pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos factures validées apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: factures.length,
                      itemBuilder: (context, index) {
                        final fac = factures[index];
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
                                    'Facture #${fac['numero'] ?? fac['id'] ?? (index + 1)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: textColor, // ✅ Texte adaptatif
                                    ),
                                  ),
                                  Text(
                                    '${fac['montant'] ?? 0} FCFA',
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
                                'Statut : ${fac['statut'] ?? 'Payée'}',
                                style: TextStyle(
                                  color: textSecondary, // ✅ Texte adaptatif
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Télécharger / Voir PDF',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    fac['created_at'] != null 
                                        ? fac['created_at'].toString().substring(0, 10) 
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