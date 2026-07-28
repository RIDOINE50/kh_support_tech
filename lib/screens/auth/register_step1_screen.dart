import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'register_step2_screen.dart';
class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  String? _selectedProfile;

  final List<Map<String, dynamic>> _profiles = [
    {'id': 'particulier', 'label': 'Particulier', 'icon': Icons.person},
    {'id': 'eleve', 'label': 'Élève', 'icon': Icons.school},
    {'id': 'etudiant', 'label': 'Étudiant', 'icon': Icons.school},
    {'id': 'enseignant', 'label': 'Enseignant', 'icon': Icons.person},
    {'id': 'entreprise', 'label': 'Entreprise', 'icon': Icons.business},
    {'id': 'ong', 'label': 'ONG', 'icon': Icons.groups},
    {'id': 'administration', 'label': 'Administration publique', 'icon': Icons.account_balance},
    {'id': 'collectivite', 'label': 'Collectivité territoriale', 'icon': Icons.location_city},
    {'id': 'association', 'label': 'Association', 'icon': Icons.groups},
    {'id': 'professionnel', 'label': 'Professionnel', 'icon': Icons.work},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER AVEC PROGRESSION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Étape 1 sur 6',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const Text(
                    '1/6',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2B5B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // BARRE DE PROGRESSION (6 points)
              Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index == 0 ? const Color(0xFF0F2B5B) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // TITRE
              const Text(
                'Choisissez votre profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),

              // SOUS-TITRE
              const Text(
                'Sélectionnez le profil qui vous correspond.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),

              // GRILLE DES PROFILS (2 colonnes)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _profiles.length,
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    final isSelected = _selectedProfile == profile['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedProfile = profile['id'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0F2B5B) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0F2B5B) : const Color(0xFFE5E7EB),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0F2B5B).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              profile['icon'] as IconData,
                              color: isSelected ? Colors.white : const Color(0xFF0F2B5B),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile['label'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF111827),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // BOUTON SUIVANT
                        // BOUTON SUIVANT
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedProfile != null
                      ? () {
                          // ✅ NAVIGATION VERS L'ÉTAPE 2 EN PASSANT LE PROFIL CHOISI
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterStep2Screen(
  formData: {'profile': _selectedProfile!},
),
                            ),
                          );
                        }
                      : null, // Le bouton reste grisé si rien n'est sélectionné
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2B5B),
                    disabledBackgroundColor: const Color(0xFF9CA3AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Suivant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}