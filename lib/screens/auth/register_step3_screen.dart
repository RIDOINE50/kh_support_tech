import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// ✅ 1. SEUL IMPORT NÉCESSAIRE : Le fichier unique de l'Étape 4
import 'register_step4_screen.dart';

class RegisterStep3Screen extends StatefulWidget {
  // ✅ 2. ON REÇOIT LE "SAC À DOS" (Map) DEPUIS L'ÉTAPE 2
  final Map<String, dynamic> formData;

  const RegisterStep3Screen({
    super.key, 
    required this.formData,
  });

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  String _selectedPays = 'Bénin';
  String _selectedDepartement = 'Atlantique';
  String _selectedCommune = 'Abomey-Calavi';
  
  // ✅ Quartier vidé par défaut
  final _quartierController = TextEditingController();
  final _adresseController = TextEditingController(text: 'Rue 12.143, Maison Zongo');

  final List<String> _paysList = ['Bénin', 'Togo', 'Nigeria', 'Ghana', 'Côte d\'Ivoire'];
  
  // ✅ Ajout d'Atakora dans la liste des départements
  final List<String> _departementList = ['Atlantique', 'Atakora', 'Littoral', 'Ouémé', 'Mono', 'Zou', 'Borgou'];
  
  // ✅ Ajout de Natitingou dans la liste des communes
  final List<String> _communeList = ['Abomey-Calavi', 'Natitingou', 'Cotonou', 'Porto-Novo', 'Parakou', 'Bohicon'];

  @override
  void dispose() {
    _quartierController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2B5B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('3/6', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2B5B))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < 3 ? const Color(0xFF0F2B5B) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              const Text('Localisation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const SizedBox(height: 8),
              
              Text(
                'Profil : ${widget.formData['profile'].toString().toUpperCase()}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F2B5B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const Text('Où vous trouvez-vous ?', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownField('Pays', _selectedPays, _paysList, (value) => setState(() => _selectedPays = value!)),
                      const SizedBox(height: 16),
                      _buildDropdownField('Département', _selectedDepartement, _departementList, (value) => setState(() => _selectedDepartement = value!)),
                      const SizedBox(height: 16),
                      _buildDropdownField('Commune', _selectedCommune, _communeList, (value) => setState(() => _selectedCommune = value!)),
                      const SizedBox(height: 16),
                      _buildTextField('Quartier', controller: _quartierController, hintText: 'Entrez votre quartier'),
                      const SizedBox(height: 16),
                      _buildTextField('Adresse exacte', controller: _adresseController, hintText: 'Ex: Rue, Maison...'),
                      const SizedBox(height: 20),
                      _buildMapPreview(),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF374151), 
                                side: const BorderSide(color: Color(0xFFE5E7EB)), 
                                backgroundColor: Colors.white, 
                                padding: const EdgeInsets.symmetric(vertical: 16), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                              ),
                              child: const Text('Précédent', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                // ✅ 1. ON MET À JOUR LE SAC À DOS AVEC LES DONNÉES DE LOCALISATION
                                Map<String, dynamic> updatedData = Map.from(widget.formData);
                                updatedData['pays'] = _selectedPays;
                                updatedData['departement'] = _selectedDepartement;
                                updatedData['commune'] = _selectedCommune;
                                updatedData['quartier'] = _quartierController.text;
                                updatedData['adresse'] = _adresseController.text;

                                // ✅ 2. REDIRECTION UNIQUE ET PROPRE VERS L'ÉTAPE 4 DYNAMIQUE
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterStep4Screen(formData: updatedData),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F2B5B),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Suivant', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {required TextEditingController controller, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true, 
            fillColor: Colors.white, 
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F2B5B), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 140,
      decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD1D5DB))),
      child: Stack(
        children: [
          CustomPaint(size: const Size(double.infinity, 140), painter: _MapPainter()),
          const Center(child: Icon(Icons.location_pin, color: Color(0xFF0F2B5B), size: 40)),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD1D5DB)..strokeWidth = 2..style = PaintingStyle.stroke;
    for (int i = 0; i < 5; i++) canvas.drawLine(Offset(0, size.height * (0.2 + i * 0.15)), Offset(size.width, size.height * (0.2 + i * 0.15)), paint);
    for (int i = 0; i < 6; i++) canvas.drawLine(Offset(size.width * (0.1 + i * 0.18), 0), Offset(size.width * (0.1 + i * 0.18), size.height), paint);
    final mainRoadPaint = Paint()..color = const Color(0xFF9CA3AF)..strokeWidth = 3..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.3), mainRoadPaint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}