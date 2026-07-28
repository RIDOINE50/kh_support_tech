import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class UserFormationsScreen extends StatefulWidget {
  const UserFormationsScreen({super.key});

  @override
  State<UserFormationsScreen> createState() => _UserFormationsScreenState();
}

class _UserFormationsScreenState extends State<UserFormationsScreen> {
  List<dynamic> formations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserFormations();
  }

  Future<void> fetchUserFormations() async {
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

      // Appel à la route /mes-inscriptions sur Railway
      final response = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/mes-inscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      print("📡 Status Code Formations: ${response.statusCode}");
      print("📦 RÉPONSE BRUTE FORMATIONS: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> mesFormations = [];
        
        // Extraction robuste des données (gère les tableaux ou les objets avec clé 'data')
        if (decodedData is List) {
          mesFormations = decodedData;
        } else if (decodedData is Map) {
          mesFormations = decodedData['data'] ?? decodedData['inscriptions'] ?? [];
        }

        print("📋 NOMBRE DE FORMATIONS TROUVÉES : ${mesFormations.length}");

        setState(() {
          formations = mesFormations;
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
      print("❌ ERREUR FLUTTER FORMATIONS: $e");
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
          'Mes formations',
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
              : formations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, size: 80, color: emptyIconColor), // ✅ Icône adaptative
                          const SizedBox(height: 16),
                          Text(
                            'Aucune formation pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // ✅ Texte adaptatif
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos futures inscriptions apparaîtront ici.',
                            style: TextStyle(color: textSecondary, fontSize: 14), // ✅ Texte adaptatif
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: formations.length,
                      itemBuilder: (context, index) {
                        final insc = formations[index];
                        
                        // On récupère les infos de la formation imbriquée (grâce au ->with('formation') de Laravel)
                        final formationData = insc['formation'] ?? {};
                        final titre = formationData['nom'] ?? 'Formation inconnue';
                        final statutParticipation = insc['statut_participation'] ?? 'Inscrit';
                        final dateInscription = insc['created_at'] != null 
                            ? insc['created_at'].toString().substring(0, 10) 
                            : 'Date inconnue';

                        // Couleur dynamique du statut (reste visible en mode sombre)
                        Color statutColor = statutParticipation.toLowerCase() == 'inscrit' ? Colors.orange : Colors.green;

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
                              child: const Icon(Icons.school, color: AppColors.primary, size: 28),
                            ),
                            title: Text(
                              titre,
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
                                  'Statut : $statutParticipation',
                                  style: TextStyle(
                                    color: statutColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Inscrit le : $dateInscription',
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