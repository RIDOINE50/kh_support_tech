import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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

//  Notifieur global pour le thème
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

        List<dynamic> allServices = servicesData is List 
            ? servicesData 
            : (servicesData['data'] ?? []);
            
        List<dynamic> allFormations = formationsData is List 
            ? formationsData 
            : (formationsData['data'] ?? []);

        // ✅ LOGIQUE POUR FORCER LES 3 PREMIERS SERVICES SPÉCIFIQUES
        List<String> priorityServiceNames = [
          'installation antivirus',
          'activation windows et office',
          'diagnostic pc'
        ];

        List<dynamic> prioritizedServices = [];
        List<dynamic> otherServices = [];

        // 1. On cherche les services prioritaires dans l'ordre exact demandé
        for (String priority in priorityServiceNames) {
          var found = allServices.firstWhere(
            (s) => (s['nom'] ?? '').toString().toLowerCase().contains(priority),
            orElse: () => null, // Retourne null si pas trouvé
          );
          if (found != null) prioritizedServices.add(found);
        }

        // 2. On ajoute les autres services qui n'ont pas été pris
        for (var service in allServices) {
          String nom = (service['nom'] ?? '').toString().toLowerCase();
          bool isPriority = priorityServiceNames.any((p) => nom.contains(p));
          if (!isPriority) otherServices.add(service);
        }

        // 3. On combine (prioritaires d'abord) et on prend les 3 premiers
        List<dynamic> finalServices = [...prioritizedServices, ...otherServices];
        _popularServices = finalServices.take(3).toList();

        // Pour les formations, on garde simplement les 3 premières
        _popularFormations = allFormations.take(3).toList();
          
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ✅ FONCTION WHATSAPP ROBUSTE
  Future<void> _launchWhatsApp() async {
    const String numeroWhatsApp = '2290161127145';
    final String message = Uri.encodeComponent(
      'Bonjour KH SERVICES. 👋\n\nJ\'ai besoin d\'assistance depuis l\'application.'
    );
    final Uri url = Uri.parse('https://wa.me/$numeroWhatsApp?text=$message');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir WhatsApp. Vérifiez qu\'il est installé.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: globalThemeNotifier,
      builder: (context, currentThemeMode, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark || currentThemeMode == ThemeMode.dark;
        
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
              color: AppColors.primary,
              onRefresh: _loadHomeData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER AÉRÉ AVEC "KH SERVICES" EN GRAND
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.menu_rounded, color: textColor, size: 26),
                                onPressed: () => Scaffold.of(context).openDrawer(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                          
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'KH SERVICES',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Solutions Numériques',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textSecondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.settings_outlined, color: textColor, size: 26),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresScreen()));
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BANNER
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
                      height: 190,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F2B5B), Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F2B5B).withOpacity(0.3),
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Informatique, réseaux, formations et bien plus.',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0F2B5B),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Découvrir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_rounded, size: 18),
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
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.white24,
                                  child: const Icon(Icons.computer, color: Colors.white, size: 40),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // SERVICES POPULAIRES
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nos services populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
                            child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading ? _buildShimmer(160, shimmerColor) : _buildServices(textColor, cardColor, isDark),
                    const SizedBox(height: 28),

                    // FORMATIONS POPULAIRES
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Formations populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
                            child: const Text('Voir tout', style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading ? _buildShimmer(160, shimmerColor) : _buildFormations(textColor, cardColor, isDark),
                    const SizedBox(height: 28),

                    // BOUTON WHATSAPP "BESOIN D'AIDE ?"
                    GestureDetector(
                      onTap: _launchWhatsApp,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFF25D366),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.wechat, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Besoin d\'aide ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 4),
                                  Text('Discutez avec notre équipe sur WhatsApp.', style: TextStyle(fontSize: 13, color: textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: isDark ? Colors.white70 : AppColors.primary),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // CARTE "QUALITÉ & FIABILITÉ" CLIQUABLE
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => const AProposScreen())
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
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
                                  const SizedBox(height: 4),
                                  Text('Des solutions professionnelles garanties par notre expertise.', style: TextStyle(fontSize: 13, color: textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: isDark ? Colors.white70 : const Color(0xFF10B981)),
                          ],
                        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  // ✅ SERVICES AVEC VRAIES IMAGES ET TRI PRIORITAIRE
  Widget _buildServices(Color textColor, Color cardColor, bool isDark) {
    if (_popularServices.isEmpty) {
      return SizedBox(height: 160, child: Center(child: Text('Aucun service', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _popularServices.length,
        itemBuilder: (context, index) {
          final service = _popularServices[index];
          final nom = service['nom'] ?? 'Service';
          final imageUrl = service['image'] ?? service['imageUrl'] ?? '';
          final categorie = (service['categorie'] ?? '').toLowerCase();
          
          Color color = AppColors.primary;
          if (categorie.contains('maintenance')) {
            color = const Color(0xFF3B82F6);
          } else if (categorie.contains('reseau') || categorie.contains('wifi')) {
            color = const Color(0xFF10B981);
          } else if (categorie.contains('formation')) {
            color = const Color(0xFF8B5CF6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: color.withOpacity(0.1),
                                child: Icon(Icons.build, color: color, size: 30),
                              ),
                            )
                          : Container(
                              color: color.withOpacity(0.1),
                              child: Icon(Icons.build, color: color, size: 30),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        nom.length > 18 ? '${nom.substring(0, 18)}...' : nom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ FORMATIONS AVEC VRAIES IMAGES
  Widget _buildFormations(Color textColor, Color cardColor, bool isDark) {
    if (_popularFormations.isEmpty) {
      return SizedBox(height: 160, child: Center(child: Text('Aucune formation', style: TextStyle(color: textColor))));
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _popularFormations.length,
        itemBuilder: (context, index) {
          final formation = _popularFormations[index];
          final nom = formation['nom'] ?? 'Formation';
          final imageUrl = formation['image'] ?? formation['imageUrl'] ?? '';
          final categorie = (formation['categorie'] ?? '').toLowerCase();
          
          Color color = AppColors.primary;
          if (categorie.contains('web') || categorie.contains('dev')) {
            color = const Color(0xFFF97316);
          } else if (categorie.contains('ia') || categorie.contains('intelligence')) {
            color = const Color(0xFF10B981);
          } else if (categorie.contains('informatique')) {
            color = const Color(0xFF3B82F6);
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationsScreen())),
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: color.withOpacity(0.1),
                                child: Icon(Icons.school, color: color, size: 30),
                              ),
                            )
                          : Container(
                              color: color.withOpacity(0.1),
                              child: Icon(Icons.school, color: color, size: 30),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        nom.length > 18 ? '${nom.substring(0, 18)}...' : nom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // GESTION DU MENU LATÉRAL
  void _handleDrawerMenuItem(String item, BuildContext context) {
    Navigator.pop(context);
    switch (item) {
      case 'marche_achat':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MarcheAchatScreen()));
        break;
      case 'programmes':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgrammesScreen()));
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