import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart'; 

class FormationApi {
  // ✅ Ton adresse IP est correcte
 static const String baseUrl = 'https://kh-support-backend-production.up.railway.app/api';

  // ==========================================
  // 1. RÉCUPÉRER LA LISTE DES FORMATIONS
  // ==========================================
  static Future<List<dynamic>> getFormations() async {
    try {
      final token = await StorageService().getToken();

      final response = await http.get(
        // ⚠️ CORRECTION : On utilise le PLURIEL "formations" pour matcher Laravel
        Uri.parse('$baseUrl/formations'), 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Retourne la liste des formations
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ ERREUR API (getFormations): $e'); // ⭐ Très utile pour le débogage
      throw Exception('Erreur réseau: $e');
    }
  }

  // ==========================================
  // 2. S'INSCRIRE À UNE FORMATION
  // ==========================================
  static Future<Map<String, dynamic>> sInscrire(int formationId) async {
    try {
      final token = await StorageService().getToken();

      final response = await http.post(
        // ✅ Ici c'est déjà au pluriel, c'est parfait
        Uri.parse('$baseUrl/formations/$formationId/inscrire'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Inscription réussie'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Erreur lors de l\'inscription'};
      }
    } catch (e) {
      print('❌ ERREUR API (sInscrire): $e'); // ⭐ Très utile pour le débogage
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }
}