import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../core/constants/app_colors.dart';
import '../../services/service_api.dart';
import 'service_demande_screen.dart';
import 'package:kh_support_tech/models/service_model.dart';
import '../main/main_screen.dart'; 

// ⭐ ÉCRAN PRINCIPAL DES SERVICES
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServiceModel> _services = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerServices();
  }

  Future<void> _chargerServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final jsonData = await ServiceApi.getServices();
      setState(() {
        _services = jsonData.map((json) => ServiceModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de charger les services. Vérifiez votre connexion.';
        _isLoading = false;
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

  // ✅ FONCTION POUR OUVRIR WHATSAPP (Vers le 01 61 12 71 45)
  Future<void> _lancerContact(String serviceName) async {
    final String numeroWhatsApp = '2290161127145'; 
    final String message = Uri.encodeComponent('Bonjour, je suis intéressé par le service : "$serviceName". Pouvez-vous me donner plus de détails ?');
    final Uri url = Uri.parse('https://wa.me/$numeroWhatsApp?text=$message');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp. Vérifiez que l\'application est installée.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[400]! : Colors.black54);
    
    final errorBgColor = isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB);
    final errorIconColor = isDark ? Colors.grey[500]! : const Color(0xFF9CA3AF);
    final shadowColor = Colors.black.withOpacity(isDark ? 0.3 : 0.08);

    const double imageWidth = 112;
    const double imageHeight = 112; 

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 48, color: textSecondary),
                        const SizedBox(height: 16),
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _chargerServices,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Réessayer'),
                        )
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                              onPressed: _goToHome, 
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Nos Services',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),

                      Expanded(
                        child: _services.isEmpty
                            ? Center(child: Text('Aucun service disponible.', style: TextStyle(color: textSecondary)))
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: _services.length,
                                itemBuilder: (context, index) {
                                  final service = _services[index];
                                  return _buildServiceCard(
                                    service, cardColor, textColor, textSecondary, errorBgColor, errorIconColor, shadowColor, imageWidth, imageHeight,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  // ⭐ WIDGET DE CARTE SERVICE
  Widget _buildServiceCard(
    ServiceModel service, 
    Color cardColor, 
    Color textColor, 
    Color textSecondary,
    Color errorBgColor,
    Color errorIconColor,
    Color shadowColor,
    double imageWidth,
    double imageHeight,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDemandeScreen(service: service),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ IMAGE À GAUCHE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: service.image.isNotEmpty
                  ? Image.network(
                      service.image,
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: imageWidth,
                          height: imageHeight,
                          color: errorBgColor,
                          child: Icon(Icons.image, size: 40, color: errorIconColor),
                        );
                      },
                    )
                  : Container(
                      width: imageWidth,
                      height: imageHeight,
                      color: errorBgColor,
                      child: Icon(Icons.build, size: 40, color: errorIconColor),
                    ),
            ),
            const SizedBox(width: 14),
            
            // ✅ CONTENU À DROITE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service.categorie.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    service.nom,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    'Délai: ${service.delaiIntervention} • À partir de ${service.prixBase} FCFA',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDemandeScreen(service: service),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Demander',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      InkWell(
                        onTap: () => _lancerContact(service.nom),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, color: Colors.green, size: 18),
                              SizedBox(width: 4),
                              Text('Contact', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}