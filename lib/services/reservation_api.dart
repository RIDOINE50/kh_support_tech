import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ReservationApi {
 static const String baseUrl = 'https://kh-support-backend-production.up.railway.app/api';

  // ⭐ NOUVELLE FONCTION : Initialiser le paiement
  static Future<Map<String, dynamic>> initierPaiement(int formationId) async {
    try {
      final token = await StorageService().getToken();

      print('📤 Appel à Laravel pour initier le paiement...');

      final response = await http.post(
        Uri.parse('$baseUrl/initier-paiement'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'formation_id': formationId}),
      );

      final data = jsonDecode(response.body);
      print('📥 Réponse Laravel: ${response.statusCode}');
      print(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'reservation_id': data['reservation_id'],
          'montant': data['montant'],
          'description': data['description'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Erreur'};
      }
    } catch (e) {
      print('❌ Erreur initierPaiement: $e');
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }

  // ⭐ NOUVELLE FONCTION : Vérifier le statut d'une réservation
  static Future<Map<String, dynamic>> verifierReservation(int reservationId) async {
    try {
      final token = await StorageService().getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/reservations/$reservationId/statut'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'reservation': data['reservation']};
      } else {
        return {'success': false, 'message': 'Erreur'};
      }
    } catch (e) {
      print('❌ Erreur verifierReservation: $e');
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }
}