import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserInterventionsScreen extends StatefulWidget {
  const UserInterventionsScreen({super.key});

  @override
  State<UserInterventionsScreen> createState() => _UserInterventionsScreenState();
}

class _UserInterventionsScreenState extends State<UserInterventionsScreen> {
  List<dynamic> interventions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserInterventions();
  }

  Future<void> fetchUserInterventions() async {
    try {
      setState(() => isLoading = true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          isLoading = false;
        });
        return;
      }

      // Appel à la route /mes-demandes-services sur Railway
      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/mes-demandes-services'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      print("📡 Status Code Interventions: ${response.statusCode}");
      print("📦 RÉPONSE BRUTE INTERVENTIONS: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> mesInterventions = [];
        
        // Extraction robuste des données
        if (decodedData is List) {
          mesInterventions = decodedData;
        } else if (decodedData is Map) {
          mesInterventions = decodedData['data'] ?? decodedData['interventions'] ?? [];
        }

        print("📋 NOMBRE D'INTERVENTIONS TROUVÉES : ${mesInterventions.length}");

        setState(() {
          interventions = mesInterventions;
          isLoading = false;
          errorMessage = '';
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Token invalide. Veuillez vous reconnecter.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ ERREUR FLUTTER INTERVENTIONS: $e");
      setState(() {
        errorMessage = 'Erreur de connexion: $e';
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
          'Mes interventions',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), // ✅ Texte adaptatif
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
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
              : interventions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.handyman_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucune intervention pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos futures demandes apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: interventions.length,
                      itemBuilder: (context, index) {
                        final inter = interventions[index];
                        
                        // On récupère les infos imbriquées (grâce au ->with('service') de Laravel)
                        final serviceData = inter['service'] ?? {};
                        final nomService = serviceData['nom'] ?? 'Service inconnu';
                        final statut = inter['statut'] ?? 'En attente';
                        final dateDemande = inter['created_at'] != null 
                            ? inter['created_at'].toString().substring(0, 10) 
                            : 'Date inconnue';
                        final adresse = inter['adresse_intervention'] ?? 'Adresse non précisée';

                        // Couleur du statut pour une meilleure lisibilité
                        Color statutColor = Colors.orange;
                        if (statut.toLowerCase().contains('terminé') || statut.toLowerCase().contains('payé') || statut.toLowerCase().contains('validé')) {
                          statutColor = Colors.green;
                        } else if (statut.toLowerCase().contains('annulé') || statut.toLowerCase().contains('rejeté') || statut.toLowerCase().contains('refusé')) {
                          statutColor = Colors.red;
                        }

                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 12),
                          color: cardColor, // ✅ Fond de carte adaptatif
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: borderColor), // ✅ Bordure adaptative
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15), // Légèrement plus visible en mode sombre
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.handyman, color: AppColors.primary, size: 28),
                            ),
                            title: Text(
                              nomService,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: textColor, // ✅ Texte adaptatif
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Text(
                                  'Statut : $statut',
                                  style: TextStyle(
                                    color: statutColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '📍 $adresse',
                                  style: TextStyle(color: textSecondary, fontSize: 12), // ✅ Texte adaptatif
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Demandé le : $dateDemande',
                                  style: TextStyle(color: textSecondary, fontSize: 12), // ✅ Texte adaptatif
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right, color: textSecondary), // ✅ Flèche adaptative
                          ),
                        );
                      },
                    ),
    );
  }
}