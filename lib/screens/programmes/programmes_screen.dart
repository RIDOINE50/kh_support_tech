import 'package:flutter/material.dart';
import 'package:kh_support_tech/models/programme_model.dart';
import 'package:kh_support_tech/services/api_service.dart';
import 'programme_detail_screen.dart';

class ProgrammesScreen extends StatelessWidget {
  const ProgrammesScreen({Key? key}) : super(key: key);

  // 🛠️ Fonction utilitaire corrigée pour gérer les liens complets et les chemins relatifs
  String? _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      print('--- IMAGE : Aucun chemin d\'image trouvé (null ou vide) ---');
      return null;
    }
    
    print('--- IMAGE REÇUE DE L\'ADMIN : $imagePath ---');
    
    // Si l'URL est déjà complète (ex: https://picsum.photos/...), on la retourne directement
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Domaine de base de ton backend Railway
    const String baseUrl = 'https://kh-support-backend-production.up.railway.app';
    
    // Si c'est un chemin relatif venant de la base de données, on ajoute /storage/
    String finalUrl;
    if (imagePath.startsWith('/')) {
      finalUrl = '$baseUrl/storage$imagePath';
    } else {
      finalUrl = '$baseUrl/storage/$imagePath';
    }
    
    print('--- URL FINALE GÉNÉRÉE : $finalUrl ---');
    return finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final descColor = isDark ? Colors.white70 : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualités & Programmes'),
      ),
      body: FutureBuilder<List<Programme>>(
        future: ApiService().fetchProgrammes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: TextStyle(color: textColor),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucune actualité pour le moment.',
                style: TextStyle(color: textColor),
              ),
            );
          }

          List<Programme> programmes = snapshot.data!;

          return ListView.builder(
            itemCount: programmes.length,
            itemBuilder: (context, index) {
              final prog = programmes[index];
              final imageUrl = _getImageUrl(prog.image);

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgrammeDetailScreen(programme: prog),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Affichage de l'image envoyée par l'admin
                      if (imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 180,
                                color: isDark ? Colors.grey[850] : Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('--- ERREUR CHARGEMENT IMAGE : $error ---');
                              return Container(
                                height: 120,
                                color: isDark ? Colors.grey[850] : Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image, color: Colors.grey, size: 32),
                                      SizedBox(height: 4),
                                      Text(
                                        'Impossible de charger l\'image',
                                        style: TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prog.titre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prog.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: descColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}