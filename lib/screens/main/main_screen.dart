import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../services/services_screen.dart';
import '../formations/formations_screen.dart';
import '../profile/profile_screen.dart';
import '../boutique/boutique_screen.dart'; // 👈 Remplacé par la boutique
import '../../core/widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // ✅ Les 5 écrans correspondent exactement aux 5 onglets de la barre du bas
  final List<Widget> _screens = [
    const HomeScreen(),          // Index 0 : Accueil
    const ServicesScreen(),      // Index 1 : Services
    const FormationsScreen(),    // Index 2 : Formations
    const BoutiqueScreen(),      // Index 3 : Boutique (Remplace Marché et achats)
    const ProfileScreen(),       // Index 4 : Compte
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}