import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_drawer.dart';
import '../services/services_screen.dart';
import '../formations/formations_screen.dart';
import '../actualites/actualites_screen.dart';
import '../programmes/programmes_screen.dart';
import '../boutique/boutique_screen.dart';
import '../assistance/assistance_screen.dart';
import '../apropos/apropos_screen.dart';
import '../parametres/parametres_screen.dart';
import '../devis/mes_demandes_screen.dart';
import '../devis/marche_achat_screen.dart';
// ✅ AJOUTE L'IMPORT DE TON ÉCRAN PROFIL ICI (ajuste le chemin si nécessaire)
import '../profile/profile_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _popularServices = [];
  List<dynamic> _popularFormations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      setState(() => _isLoading = true);

      final servicesResponse = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/services'),
        headers: {'Accept': 'application/json'},
      );

      final formationsResponse = await http.get(
        Uri.parse('https://kh-support-backend-production.up.railway.app/api/formations'),
        headers: {'Accept': 'application/json'},
      );

      if (servicesResponse.statusCode == 200 && formationsResponse.statusCode == 200) {
        final servicesData = json.decode(servicesResponse.body);
        final formationsData = json.decode(formationsResponse.body);

        setState(() {
          _popularServices = servicesData is List 
              ? servicesData.take(3).toList() 
              : (servicesData['data'] ?? []).take(3).toList();
          
          _popularFormations = formationsData is List 
              ? formationsData.take(3).toList() 
              : (formationsData['data'] ?? []).take(3).toList();
          
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des couleurs du thème (s'adapte automatiquement au mode sombre)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54;
    final cardColor = Theme.of(context).cardColor;
    final shimmerColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: CustomDrawer(
        onMenuItemTap: (item) => _handleDrawerMenuItem(item, context),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ HEADER AVEC MENU, PROFIL ET PARAMÈTRES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu, color: textColor, size: 28),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Row(
                        children: [
                          // Icône Profil
                          IconButton(
                            icon: Icon(Icons.person_outline, color: textColor, size: 28),
                            onPressed: () {
                              // Assure-toi que ProfileScreen est bien importé en haut du fichier
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                            },
                          ),
                          // Icône Paramètres
                          IconButton(
                            icon: Icon(Icons.settings_outlined, color: textColor, size: 28),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Banner avec image
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E40AF).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Des solutions adaptées',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Informatique, réseaux, formations et bien plus encore.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1E40AF),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Découvrir', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/banner_laptop.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Services populaires
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nos services populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                        child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: Color(0xFF1E40AF), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _isLoading ? _buildShimmer(120, shimmerColor) : _buildServices(textColor, cardColor),
                const SizedBox(height: 28),

                // Formations populaires
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Formations populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
                        child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: Color(0xFF1E40AF), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _isLoading ? _buildShimmer(240, shimmerColor) : _buildFormations(textColor, textSecondary, cardColor),
                const SizedBox(height: 28),

                // Besoin d'aide
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E40AF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.headset_mic, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Besoin d\'aide ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 4),
                            Text('Discutez avec notre équipe d\'assistance en ligne.', style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18, color: isDark ? Colors.white : const Color(0xFF1E40AF)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Qualité & Fiabilité
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Qualité & Fiabilité', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 4),
                            Text('Des solutions professionnelles garanties par notre expertise.', style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18, color: isDark ? Colors.white : const Color(0xFF22C55E)),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double height, Color? shimmerColor) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: index == 0 ? 120 : 180,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildServices(Color textColor, Color cardColor) {
    if (_popularServices.isEmpty) {
      return SizedBox(height: 120, child: Center(child: Text('Aucun service', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _popularServices.length,
        itemBuilder: (context, index) {
          final service = _popularServices[index];
          final nom = service['nom'] ?? 'Service';
          final categorie = (service['categorie'] ?? '').toLowerCase();
          
          IconData icon = Icons.computer;
          Color color = const Color(0xFF3B82F6);
          
          if (categorie.contains('maintenance')) {
            icon = Icons.build;
            color = const Color(0xFF3B82F6);
          } else if (categorie.contains('reseau') || categorie.contains('wifi')) {
            icon = Icons.wifi;
            color = const Color(0xFF22C55E);
          } else if (categorie.contains('formation')) {
            icon = Icons.school;
            color = const Color(0xFF8B5CF6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nom.length > 18 ? '${nom.substring(0, 18)}...' : nom,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.arrow_forward, size: 14, color: textColor.withOpacity(0.6)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormations(Color textColor, Color textSecondary, Color cardColor) {
    if (_popularFormations.isEmpty) {
      return SizedBox(height: 240, child: Center(child: Text('Aucune formation', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _popularFormations.length,
        itemBuilder: (context, index) {
          final formation = _popularFormations[index];
          final nom = formation['nom'] ?? 'Formation';
          final prix = formation['prix'] ?? formation['prix_base'] ?? 0;
          final duree = formation['duree'] ?? 'Non spécifié';
          final niveau = formation['niveau'] ?? 'Débutant';
          final rating = formation['rating'] ?? 4.5;
          final reviews = formation['reviews'] ?? 10;
          final categorie = (formation['categorie'] ?? '').toLowerCase();
          
          IconData icon = Icons.computer;
          Color color = const Color(0xFF3B82F6);
          
          if (categorie.contains('web') || categorie.contains('dev')) {
            icon = Icons.code;
            color = const Color(0xFFF97316);
          } else if (categorie.contains('ia') || categorie.contains('intelligence')) {
            icon = Icons.psychology;
            color = const Color(0xFF22C55E);
          } else if (categorie.contains('informatique')) {
            icon = Icons.computer;
            color = const Color(0xFF3B82F6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
            child: Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text('$duree • $niveau', style: TextStyle(fontSize: 11, color: textSecondary)),
                  const Spacer(),
                  Text(
                    '${prix.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFBBF24)),
                      Text(' $rating ($reviews)', style: TextStyle(fontSize: 11, color: textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleDrawerMenuItem(String item, BuildContext context) {
    Navigator.pop(context);
    switch (item) {
      case 'marche_achat':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MarcheAchatScreen()));
        break;
      case 'programmes':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProgrammesScreen()));
        break;
      case 'boutique':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BoutiqueScreen()));
        break;
      case 'assistance':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AssistanceScreen()));
        break;
      case 'apropos':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AProposScreen()));
        break;
      case 'parametres':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresScreen()));
        break;
      case 'deconnexion':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Oui', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}