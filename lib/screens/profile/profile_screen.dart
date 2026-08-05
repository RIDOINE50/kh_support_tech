import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import 'user_commandes_screen.dart';
import 'user_interventions_screen.dart';
import 'user_formations_screen.dart';
import 'user_devis_screen.dart';
import 'user_certificats_screen.dart';
import '../auth/login_screen.dart';
import '../main/main_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Chargement...';
  String userEmail = '...';
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserHeaderInfo();
  }

  // ✅ LA SOLUTION MAGIQUE : Se déclenche à CHAQUE fois que l'écran devient visible
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserHeaderInfo();
  }

  Future<void> _loadUserHeaderInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Force la relecture des données sur le disque
    await prefs.reload(); 
    
    // On cherche le nom avec plusieurs clés possibles pour être sûr de le trouver
    String name = prefs.getString('name') ?? 
                  prefs.getString('user_name') ?? 
                  prefs.getString('full_name') ?? 
                  'Mon Profil';
                  
    String email = prefs.getString('email') ?? 
                   prefs.getString('user_email') ?? 
                   'utilisateur@email.com';

    // Mise à jour de l'état uniquement si le widget est toujours monté
    if (mounted) {
      setState(() {
        userName = name;
        userEmail = email;
        _isDataLoaded = true;
      });
    }
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    final borderColor = isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: _goToHome,
        ),
        title: Text(
          'Mon Profil',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ CARTE PROFIL DYNAMIQUE
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Affiche un petit indicateur de chargement si les données ne sont pas encore là
                      _isDataLoaded 
                        ? Text(
                            userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          )
                        : const SizedBox(
                            height: 20,
                            width: 100,
                            child: LinearProgressIndicator(backgroundColor: Colors.grey, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                          ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
   
          const SizedBox(height: 24),
          Text(
            'Mon Activité',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),

          // LISTE DES ACTIVITÉS
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _AccountMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Mes commandes',
                  textColor: textColor,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserCommandesScreen())),
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _AccountMenuItem(
                  icon: Icons.handyman_outlined,
                  title: 'Mes interventions',
                  textColor: textColor,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInterventionsScreen())),
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _AccountMenuItem(
                  icon: Icons.school_outlined,
                  title: 'Mes formations',
                  textColor: textColor,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserFormationsScreen())),
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _AccountMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Mes devis',
                  textColor: textColor,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserDevisScreen())),
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _AccountMenuItem(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Mes certificats',
                  textColor: textColor,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserCertificatsScreen())),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Déconnexion
          OutlinedButton.icon(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Se déconnecter', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
        }
}

class _AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color textColor;
  final Color textSecondary;
  final Color borderColor;
  final VoidCallback onTap;

  const _AccountMenuItem({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.textSecondary,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textSecondary),
      onTap: onTap,
    );
  }
}