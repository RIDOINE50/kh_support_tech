import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    print("🚀 [SPLASH] Démarrage du délai de 5 secondes...");
    
    // 1. Attendre 5 secondes
    await Future.delayed(const Duration(seconds: 5));
    print("✅ [SPLASH] Délai terminé. Vérification de la connexion...");

    if (!mounted) return;

    try {
      // 2. Vérifier le stockage de manière sécurisée
      final isLoggedIn = await _storage.isLoggedIn();
      print("🔑 [SPLASH] isLoggedIn = $isLoggedIn");
      
      final isAdmin = await _storage.isAdmin();
      print("👑 [SPLASH] isAdmin = $isAdmin");

      if (!mounted) return;

      // 3. Redirection
      if (isLoggedIn) {
        if (isAdmin) {
          print("➡️ [SPLASH] Redirection vers Admin Dashboard");
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        } else {
          print("➡️ [SPLASH] Redirection vers Accueil (MainScreen)");
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        print("➡️ [SPLASH] Redirection vers Login");
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      // 4. SÉCURITÉ : Si une erreur se produit, on force la redirection vers le Login
      print("❌ [SPLASH] ERREUR CRITIQUE : $e");
      if (mounted) {
        print("⚠️ [SPLASH] Fallback : Redirection forcée vers Login");
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1565C0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ 1. AJOUT D'UN SPACER EN HAUT POUR POUSSER LE CONTENU VERS LE BAS
              const Spacer(), 
              
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'KH',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // ✅ 2. CHANGEMENT DU NOM EN "KH SERVICES"
              const Text(
                'KH SERVICES',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Votre Partenaire Tech',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLoadingDot(0),
                  const SizedBox(width: 8),
                  _buildLoadingDot(1),
                  const SizedBox(width: 8),
                  _buildLoadingDot(2),
                ],
              ),
              
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Chargement...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDot(int index) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}