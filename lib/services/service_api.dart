import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ServiceApi {
 static const String baseUrl = 'https://kh-support-backend-production.up.railway.app/api';

  // 1. Récupérer la liste des services
  static Future<List<dynamic>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur getServices: $e');
      throw Exception('Erreur réseau: $e');
    }
  }

  // 2. Soumettre une demande de service
  static Future<Map<String, dynamic>> demanderService({
    required int serviceId,
    required String descriptionProbleme,
    required String adresseIntervention,
    required String telephoneContact,
    String? dateSouhaitee,
  }) async {
    try {
      final token = await StorageService().getToken();

      final body = {
        'service_id': serviceId,
        'description_probleme': descriptionProbleme,
        'adresse_intervention': adresseIntervention,
        'telephone_contact': telephoneContact,
      };

      if (dateSouhaitee != null && dateSouhaitee.isNotEmpty) {
        body['date_souhaitee'] = dateSouhaitee;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/services/demander'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Erreur'};
      }
    } catch (e) {
      print('❌ Erreur demanderService: $e');
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }
    // 3. Récupérer mes demandes de services (Historique)
  static Future<List<dynamic>> getMesDemandes() async {
    try {
      final token = await StorageService().getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/mes-demandes-services'),
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true', // (Note: ce header est inutile sur Railway, mais ne fait pas de mal)
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur getMesDemandes: $e');
      throw Exception('Erreur réseau: $e');
    }
  }
}