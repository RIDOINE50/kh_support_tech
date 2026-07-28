import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../main/main_screen.dart';    // ✅ Pour aller au Dashboard
import 'login_screen.dart';      // ✅ Pour retourner à la connexion
class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // SECTION ILLUSTRATION (Check vert + Confettis)
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Confettis simulés
                    ..._buildConfetti(),
                    
                    // Grand cercle vert avec le check
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E), // Vert succès
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // TITRE
              const Text(
                'Félicitations !',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2B5B), // Bleu foncé
                ),
              ),
              const SizedBox(height: 16),

              // SOUS-TITRES
              const Text(
                'Votre compte a été créé avec succès.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vous pouvez maintenant profiter de tous\nnos services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // BOUTON COMMENCER
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                     // Redirige vers le Dashboard et efface tout l'historique d'inscription
  // pour que l'utilisateur ne puisse pas revenir en arrière avec le bouton "Retour"
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MainScreen()),
    (route) => false,
  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2B5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // LIEN RETOUR À LA CONNEXION
              TextButton(
                onPressed: () {
                 // Retourne à la connexion et efface l'historique
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
                },
                child: const Text(
                  'Retour à la connexion',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F2B5B),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour générer les petits confettis autour du check
  List<Widget> _buildConfetti() {
    final colors = [
      const Color(0xFF0F2B5B), // Bleu
      const Color(0xFF22C55E), // Vert
      const Color(0xFFF59E0B), // Orange
      const Color(0xFFEF4444), // Rouge
      const Color(0xFF3B82F6), // Bleu clair
    ];

    return List.generate(12, (index) {
      final random = Random();
      final angle = (index * 30) * (pi / 180);
      final radius = 70.0 + random.nextDouble() * 20;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      
      return Positioned(
        left: 90 + x, // 90 est la moitié de la largeur du Stack (180/2) moins la moitié du cercle (110/2)
        top: 90 + y,
        child: Container(
          width: random.nextBool() ? 8 : 4,
          height: random.nextBool() ? 4 : 8,
          decoration: BoxDecoration(
            color: colors[index % colors.length],
            borderRadius: BorderRadius.circular(2),
          ),
          transform: Matrix4.rotationZ(random.nextDouble() * pi),
        ),
      );
    });
  }
}