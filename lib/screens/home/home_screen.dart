import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Nécessaire pour rediriger vers WhatsApp
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
import '../profile/profile_screen.dart'; 

// 🌓 Variable globale pour forcer le rafraîchissement instantané du thème
final ValueNotifier<ThemeMode> globalThemeNotifier = ValueNotifier(ThemeMode.light);

class HomeScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme; 
  const HomeScreen({super.key, this.onToggleTheme});

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

  // Fonction pour ouvrir WhatsApp
  Future<void> _launchWhatsApp() async {
    const phoneNumber = '+2290161127145';
    final message = Uri.encodeComponent('Bonjour, j\'ai besoin d\'assistance depuis l\'application.');
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber?text=$message');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Impossible d\'ouvrir WhatsApp');
      }
    } catch (e) {
      debugPrint('Erreur WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: globalThemeNotifier,
      builder: (context, currentThemeMode, child) {
        final isDark = currentThemeMode == ThemeMode.dark;
        
        final textColor = isDark ? Colors.white : Colors.black87;
        final textSecondary = isDark ? Colors.white70 : Colors.black54;
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
        final shimmerColor = isDark ? Colors.grey[800] : Colors.grey[200];

        return Scaffold(
          backgroundColor: scaffoldBg,
          drawer: CustomDrawer(
            onMenuItemTap: (item) => _handleDrawerMenuItem(item, context),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: const Color(0xFF6366F1),
              onRefresh: _loadHomeData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER (Éclairage / Lune du haut 3ème supprimé)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: Icon(Icons.menu_rounded, color: textColor, size: 28),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.person_outline_rounded, color: textColor, size: 28),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                                },
                              ),
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

                    // 🌟 Banner Joyeux
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      height: 190,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.4),
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
                                  'Des solutions éclatantes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Informatique, réseaux, formations et bien plus.',
                                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF6366F1),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Découvrir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_rounded, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/banner_laptop.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Services populaires
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nos services populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                            child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading ? _buildShimmer(135, shimmerColor) : _buildServices(textColor, cardColor, isDark),
                    const SizedBox(height: 24),

                    // Formations populaires (Harmonisées au format exact des services : hauteur 135)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Formations populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
                            child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading ? _buildShimmer(135, shimmerColor) : _buildFormations(textColor, cardColor, isDark),
                    const SizedBox(height: 24),

                    // Besoin d'aide (Redirige vers WhatsApp)
                    GestureDetector(
                      onTap: _launchWhatsApp,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6366F1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Besoin d\'aide ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 2),
                                  Text('Discutez avec notre équipe sur WhatsApp.', style: TextStyle(fontSize: 12.5, color: textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white70 : const Color(0xFF6366F1)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Qualité & Fiabilité
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Qualité & Fiabilité', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(height: 2),
                                Text('Des solutions professionnelles garanties par notre expertise.', style: TextStyle(fontSize: 12.5, color: textSecondary)),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white70 : const Color(0xFF10B981)),
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
      },
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
          width: 135,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildServices(Color textColor, Color cardColor, bool isDark) {
    if (_popularServices.isEmpty) {
      return SizedBox(height: 135, child: Center(child: Text('Aucun service', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _popularServices.length,
        itemBuilder: (context, index) {
          final service = _popularServices[index];
          final nom = service['nom'] ?? 'Service';
          final categorie = (service['categorie'] ?? '').toLowerCase();
          
          IconData icon = Icons.computer_rounded;
          Color color = const Color(0xFF6366F1);
          
          if (categorie.contains('maintenance')) {
            icon = Icons.build_rounded;
            color = const Color(0xFF3B82F6);
          } else if (categorie.contains('reseau') || categorie.contains('wifi')) {
            icon = Icons.wifi_rounded;
            color = const Color(0xFF10B981);
          } else if (categorie.contains('formation')) {
            icon = Icons.school_rounded;
            color = const Color(0xFF8B5CF6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
            child: Container(
              width: 135,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nom.length > 20 ? '${nom.substring(0, 20)}...' : nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, height: 1.2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🎓 CARTE DE FORMATION HARMONISÉE EXACTEMENT COMME LES SERVICES (Hauteur 135)
  Widget _buildFormations(Color textColor, Color cardColor, bool isDark) {
    if (_popularFormations.isEmpty) {
      return SizedBox(height: 135, child: Center(child: Text('Aucune formation', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _popularFormations.length,
        itemBuilder: (context, index) {
          final formation = _popularFormations[index];
          final nom = formation['nom'] ?? 'Formation';
          final categorie = (formation['categorie'] ?? '').toLowerCase();
          
          IconData icon = Icons.computer_rounded;
          Color color = const Color(0xFF6366F1);
          
          if (categorie.contains('web') || categorie.contains('dev')) {
            icon = Icons.code_rounded;
            color = const Color(0xFFF97316);
          } else if (categorie.contains('ia') || categorie.contains('intelligence')) {
            icon = Icons.psychology_rounded;
            color = const Color(0xFF10B981);
          } else if (categorie.contains('informatique')) {
            icon = Icons.computer_rounded;
            color = const Color(0xFF3B82F6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
            child: Container(
              width: 135,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nom.length > 20 ? '${nom.substring(0, 20)}...' : nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, height: 1.2),
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