import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserDevisScreen extends StatefulWidget {
  const UserDevisScreen({super.key});

  @override
  State<UserDevisScreen> createState() => _UserDevisScreenState();
}

class _UserDevisScreenState extends State<UserDevisScreen> {
  List<dynamic> devisList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserDevis();
  }

  // Fonction pour récupérer uniquement les devis de l'utilisateur connecté
  Future<void> fetchUserDevis() async {
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

      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/devis'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        List<dynamic> mesDevis = [];
        if (data is List) {
          mesDevis = data;
        } else if (data is Map) {
          mesDevis = data['data'] ?? data['devis'] ?? [];
        }

        setState(() {
          devisList = mesDevis;
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
          errorMessage = 'Impossible de charger vos devis (Erreur ${response.statusCode})';
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
    final attachmentIconColor = isDark ? Colors.grey[400]! : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor, // ✅ Fond adaptatif
      appBar: AppBar(
        backgroundColor: bgColor, // ✅ AppBar adaptative
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // ✅ Icône retour adaptative
        title: Text(
          'Mes devis',
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
              : devisList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucun devis pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos demandes de devis apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: devisList.length,
                      itemBuilder: (context, index) {
                        final devis = devisList[index];
                        
                        final numero = devis['numero_devis'] ?? 'Devis #${devis['id']}';
                        final sujet = devis['sujet'] ?? devis['description'] ?? 'Demande de devis';
                        final statut = (devis['statut'] ?? 'en_attente').toString().toLowerCase();
                        final dateDemande = devis['created_at'] != null 
                            ? devis['created_at'].toString().substring(0, 10) 
                            : 'Date inconnue';
                        final aUnFichier = devis['fichier'] != null && devis['fichier'].toString().isNotEmpty;

                        // Couleur dynamique selon le statut
                        Color statutColor = Colors.orange; // Par défaut (en_attente)
                        if (statut.contains('accepté') || statut.contains('validé') || statut.contains('payé')) {
                          statutColor = Colors.green;
                        } else if (statut.contains('refusé') || statut.contains('annulé') || statut.contains('rejeté')) {
                          statutColor = Colors.red;
                        }

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
                                      numero,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: textColor, // ✅ Texte adaptatif
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (aUnFichier)
                                    Icon(Icons.attach_file, size: 18, color: attachmentIconColor), // ✅ Icône adaptative
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                sujet,
                                style: TextStyle(
                                  color: textSecondary, // ✅ Texte adaptatif
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statutColor.withOpacity(0.15), // Légèrement plus visible en mode sombre
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: statutColor.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      devis['statut'] ?? 'En attente',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: statutColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    dateDemande,
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