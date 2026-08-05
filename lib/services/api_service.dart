import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kh_support_tech/models/programme_model.dart';
import '../models/formation_model.dart';
import '../models/inscription_model.dart';

class ApiService {
  // L'URL de base de ton API Laravel sur Railway
  static const String baseUrl = 'https://kh-support-backend-production.up.railway.app/api';

  // Helper pour générer les en-têtes HTTP
  Map<String, String> _getHeaders({String? token}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // 🔑 1. Connexion (Login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      print("📤 Envoi à Laravel -> Email: $email");

      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse de Laravel (Code: ${response.statusCode}) -> ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'token': data['token'] ?? data['access_token'],
          'user': data['user'] ?? data,
          ...data,
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Identifiants incorrects',
        };
      }
    } catch (e) {
      print("❌ Erreur de connexion: $e");
      return {'success': false, 'error': 'Délai dépassé ou pas de connexion au serveur'};
    }
  }

  // 📝 2. Création de compte utilisateur (Register public)
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
  print("🔍 ApiService : Préparation de la requête post vers /register...");
  
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'), // Assure-toi que $baseUrl contient bien ton URL (ex: http://10.0.2.2:8000/api)
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 15));

    print("🔍 ApiService : Réponse brute reçue de Laravel ! Code: ${response.statusCode}");
    print("📦 Corps de la réponse : ${response.body}");

    // On décode la réponse de Laravel
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': responseData['message'] ?? 'Compte créé avec succès !',
        'token': responseData['token'],
        'user': responseData['user'],
      };
    } else {
      return {
        'success': false,
        'error': responseData['message'] ?? responseData['error'] ?? 'Erreur lors de l\'inscription',
      };
    }

  } catch (e) {
    print("❌ ApiService ERREUR FATALE : $e");
    return {
      'success': false,
      'error': 'Impossible de joindre le serveur. Erreur : $e',
    };
  }
}

  // 🎓 3. Inscription à une Formation (Route protégée /inscriptions)
  Future<Map<String, dynamic>> creerInscription(Map<String, dynamic> inscriptionData, String token) async {
    final url = Uri.parse('$baseUrl/inscriptions');

    try {
      print("📤 Envoi inscription formation à Laravel...");

      final response = await http.post(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode(inscriptionData),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse inscription (Code: ${response.statusCode}) -> ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Inscription enregistrée !',
          'data': data,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': '401', 
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Erreur d\'inscription (${response.statusCode})',
        };
      }
    } catch (e) {
      print("❌ Erreur création inscription: $e");
      return {'success': false, 'error': 'Impossible de joindre le serveur'};
    }
  }

  // 🎓 4. Récupérer la liste des formations
  Future<List<FormationModel>> getFormations() async {
    final url = Uri.parse('$baseUrl/formations');

    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = data['data'] ?? data;
        return list.map((e) => FormationModel.fromJson(e)).toList();
      } else {
        throw Exception("Erreur lors du chargement des formations");
      }
    } catch (e) {
      print("❌ Erreur getFormations: $e");
      throw Exception("Impossible de contacter le serveur");
    }
  }

  // 📌 5. Récupérer les inscriptions de l'utilisateur connecté
  Future<List<InscriptionModel>> getMesInscriptions(String token) async {
    final url = Uri.parse('$baseUrl/mes-inscriptions');

    try {
      final response = await http.get(
        url,
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = data['data'] ?? data;
        return list.map((e) => InscriptionModel.fromJson(e)).toList();
      } else {
        throw Exception("Erreur lors du chargement de vos inscriptions");
      }
    } catch (e) {
      print("❌ Erreur getMesInscriptions: $e");
      throw Exception("Impossible de contacter le serveur");
    }
  }

  // 💳 6. Confirmer le paiement KKiaPay au backend Laravel
  Future<bool> confirmerPaiement({
    required String token,
    required String transactionId,
    required int formationId,
    required double amount,
  }) async {
    final url = Uri.parse('$baseUrl/kkiapay/callback');

    try {
      print("📤 Envoi confirmation paiement KKiaPay -> Transaction: $transactionId");

      final response = await http.post(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'transaction_id': transactionId,
          'formation_id': formationId,
          'amount': amount,
        }),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse callback KKiaPay (Code: ${response.statusCode}) -> ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Erreur confirmerPaiement: $e");
      return false;
    }
  }

  // 🛠️ 7. Envoyer une demande de service
  Future<Map<String, dynamic>> demanderService({
    required Map<String, dynamic> serviceData,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/services/demander');

    try {
      print("📤 Envoi de la demande de service à Laravel...");

      final response = await http.post(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode(serviceData),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse service (Code: ${response.statusCode}) -> ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Votre demande a été envoyée avec succès !',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Erreur lors de la demande (${response.statusCode})',
        };
      }
    } catch (e) {
      print("❌ Erreur demanderService: $e");
      return {'success': false, 'error': 'Impossible de contacter le serveur'};
    }
  }

  // 🛠️ 8. Récupérer toutes les demandes de services (ADMIN)
  Future<Map<String, dynamic>> getDemandesAdmin(String token) async {
    final url = Uri.parse('$baseUrl/admin/demandes-services');

    try {
      print("📤 Récupération de toutes les demandes de services (Admin)...");

      final response = await http.get(
        url,
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse admin demandes (Code: ${response.statusCode})");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Erreur d\'accès au serveur (${response.statusCode})',
        };
      }
    } catch (e) {
      print("❌ Erreur getDemandesAdmin: $e");
      return {'success': false, 'error': 'Impossible de contacter le serveur'};
    }
  }

  // 📦 9. Récupérer toutes les commandes (ADMIN)
  Future<Map<String, dynamic>> getCommandesAdmin(String token) async {
    final url = Uri.parse('$baseUrl/admin/commandes');

    try {
      print("📤 Récupération de toutes les commandes (Admin)...");

      final response = await http.get(
        url,
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse admin commandes (Code: ${response.statusCode})");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Erreur d\'accès au serveur (${response.statusCode})',
        };
      }
    } catch (e) {
      print("❌ Erreur getCommandesAdmin: $e");
      return {'success': false, 'error': 'Impossible de contacter le serveur'};
    }
  }

  // 📦 10. Mettre à jour le statut d'une commande (ADMIN)
  Future<Map<String, dynamic>> updateStatutCommandeAdmin({
    required int commandeId,
    required String statut,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/admin/commandes/$commandeId/statut');

    try {
      print("📤 Mise à jour du statut de la commande #$commandeId vers '$statut'...");

      final response = await http.put(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode({'statut': statut}),
      ).timeout(const Duration(seconds: 60)); // ✅ CHANGÉ À 60 SECONDES

      print("📥 Réponse mise à jour statut (Code: ${response.statusCode})");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Statut mis à jour avec succès',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      print("❌ Erreur updateStatutCommandeAdmin: $e");
      return {'success': false, 'error': 'Impossible de contacter le serveur'};
    }
  }

  // 📦 11. Créer une commande (Route protégée /commandes)
  Future<Map<String, dynamic>> creerCommande(Map<String, dynamic> commandeData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/commandes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(commandeData),
      ).timeout(const Duration(seconds: 60)); // ✅ AJOUTÉ TIMEOUT 60 SECONDES

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['message'] ?? 'Erreur lors de la création'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

 // 📑 12. Envoyer une demande de devis (avec option de fichier joint en Multipart)
  Future<Map<String, dynamic>> demanderDevis({
    required Map<String, dynamic> devisFields,
    dynamic file, 
    required String token,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/devis'));
      
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      devisFields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      if (file != null) {
        try {
          if (file.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
              'fichier', 
              file.bytes!,
              filename: file.name,
            ));
          } else if (file.path != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'fichier', 
              file.path!,
              filename: file.name,
            ));
          }
        } catch (fileError) {
          print("⚠️ Erreur lors de l'attachement du fichier : $fileError");
        }
      }

      var streamedResponse = await request.send().timeout(const Duration(seconds: 60)); // ✅ AJOUTÉ TIMEOUT 60 SECONDES
      var response = await http.Response.fromStream(streamedResponse);
      
      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = {'message': response.body};
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': responseData['data'] ?? responseData};
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? responseData['error'] ?? 'Erreur lors de l\'envoi du devis (${response.statusCode})'
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
 
  // 📚 13. Récupérer les programmes
  Future<List<Programme>> fetchProgrammes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('$baseUrl/programmes');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 60)); // ✅ AJOUTÉ TIMEOUT 60 SECONDES

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = (data is Map) ? (data['data'] ?? []) : data;
        return list.map((dynamic item) => Programme.fromJson(item)).toList();
      } else {
        throw Exception('Erreur de chargement : ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Erreur fetchProgrammes: $e");
      throw Exception('Impossible de charger les programmes');
    }
  }
}