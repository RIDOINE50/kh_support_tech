import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'database_helper.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final DatabaseHelper _db = DatabaseHelper();
  final StorageService _storage = StorageService();

  // 🛠️ Vérification compatibilité v5/v6 de connectivity_plus
  Future<bool> _hasInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result is List) {
      return !(result as List).contains(ConnectivityResult.none);
    }
    return result != ConnectivityResult.none;
  }

  // ✅ 1. CONNEXION INTELLIGENTE
  Future<Map<String, dynamic>> login(String email, String password) async {
    bool isConnected = await _hasInternetConnection();

    if (isConnected) {
      print("🌐 Connexion internet détectée. Appel à l'API...");

      final response = await _api.login(email, password);

      if (response['success'] == true && response['token'] != null) {
        await _storage.saveToken(response['token']);

        try {
          await _db.saveUserLocally(response);
        } catch (e) {
          print("⚠️ Sauvegarde locale ignorée : $e");
        }

        // ✅ CORRECTION ICI : On renvoie aussi l'objet 'user' au LoginScreen
        return {
          'success': true, 
          'message': response['message'] ?? 'Connecté en ligne avec succès !',
          'token': response['token'],
          'user': response['user'], // <--- C'ÉTAIT ÇA LE PROBLÈME !
        };
      }

      return response;

    } else {
      print("✈️ Mode hors-ligne. Recherche en local...");

      try {
        final localUser = await _db.getLocalUser(email);

        if (localUser != null) {
          final offlineToken = 'offline_token_${localUser['email']}';
          await _storage.saveToken(offlineToken);
          
          return {
            'success': true, 
            'message': 'Connecté hors ligne !',
            'token': offlineToken,
            'user': localUser, // On renvoie aussi les infos locales si hors ligne
          };
        }
      } catch (e) {
        print("⚠️ Erreur de lecture locale : $e");
      }

      return {
        'success': false,
        'error': 'Pas de connexion internet et ce compte n\'est pas enregistré sur cet appareil.'
      };
    }
  }

  // ✅ 2. ENREGISTREMENT UTILISATEUR (REGISTER)
  Future<Map<String, dynamic>> registerComplete(Map<String, dynamic> formData) async {
    final dataToSend = {
      'name': '${formData['prenom'] ?? ''} ${formData['nom'] ?? ''}'.trim(),
      'email': formData['email'],
      ...formData,
    };

    print("📤 Envoi de la création de compte utilisateur à Laravel (/register)...");

    final result = await _api.registerUser(dataToSend);

    if (result['success'] == true && result['token'] != null) {
      await _storage.saveToken(result['token']);

      try {
        await _db.saveUserLocally(result);
      } catch (e) {
        print("⚠️ Sauvegarde locale ignorée : $e");
      }
    }

    return result;
  }

  // ✅ RECUPERER LE TOKEN COURANT
  Future<String?> getAuthToken() async {
    return await _storage.getToken();
  }

  // ✅ DÉCONNEXION
  Future<void> logout() async {
    await _storage.clearAll();
    try {
      await _db.clearLocalData();
    } catch (e) {
      print("⚠️ Erreur lors de la suppression locale : $e");
    }
  }

  // 🛠️ Traitement sécurisé de la demande de service
  Future<Map<String, dynamic>> soumettreDemandeService(Map<String, dynamic> formData) async {
    String? token = await _storage.getToken();

    if (token == null || token.isEmpty || token.startsWith('offline_token_')) {
      return {
        'success': false,
        'error': 'Vous devez être connecté pour demander un service.'
      };
    }

    return await _api.demanderService(
      serviceData: formData,
      token: token,
    );
  }

  // ✅ 3. Inscription sécurisée à une formation
  Future<Map<String, dynamic>> inscrireAFormation(Map<String, dynamic> inscriptionData) async {
    String? token = await _storage.getToken();

    if (token == null || token.isEmpty || token.startsWith('offline_token_')) {
      return {
        'success': false,
        'error': 'Vous devez être connecté pour vous inscrire à une formation.'
      };
    }

    return await _api.creerInscription(inscriptionData, token);
  }

  // 🛠️ Récupérer toutes les demandes de services pour l'administrateur
  Future<Map<String, dynamic>> recupererDemandesAdmin() async {
    String? token = await _storage.getToken();

    if (token == null || token.isEmpty || token.startsWith('offline_token_')) {
      return {
        'success': false,
        'error': 'Accès refusé. Vous devez être connecté en tant qu\'administrateur.'
      };
    }

    return await _api.getDemandesAdmin(token);
  }
}