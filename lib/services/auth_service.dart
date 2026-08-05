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

  // ✅ 1. CONNEXION INTELLIGENTE AVEC DOUBLE TENTATIVE (RETRY)
  Future<Map<String, dynamic>> login(String email, String password) async {
    bool isConnected = await _hasInternetConnection();

    if (isConnected) {
      print("🌐 Connexion internet détectée. Appel à l'API...");

      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          print("📤 Tentative de connexion n°$attempt...");
          final response = await _api.login(email, password);

          if (response['success'] == true && response['token'] != null) {
            await _storage.saveToken(response['token']);

            try {
              await _db.saveUserLocally(response);
            } catch (e) {
              print("⚠️ Sauvegarde locale ignorée : $e");
            }

            return {
              'success': true, 
              'message': response['message'] ?? 'Connecté en ligne avec succès !',
              'token': response['token'],
              'user': response['user'],
            };
          }
          return response;

        } catch (e) {
          String errorStr = e.toString();
          print("⚠️ Erreur tentative $attempt : $errorStr");

          if ((errorStr.contains('Failed host lookup') || errorStr.contains('SocketException')) && attempt == 1) {
            print("🔄 Le Wi-Fi a du mal à résoudre l'adresse. Nouvelle tentative dans 0.5 seconde...");
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
          break;
        }
      }

      return {
        'success': false,
        'error': 'Délai dépassé ou problème de connexion. Essayez en 4G ou vérifiez votre Wi-Fi.'
      };

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
            'user': localUser,
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

  // ✅ 2. ENREGISTREMENT UTILISATEUR (REGISTER) AVEC DOUBLE TENTATIVE ET TIMEOUT SÉCURISÉ
  Future<Map<String, dynamic>> registerComplete(Map<String, dynamic> formData) async {
    final dataToSend = {
      'name': '${formData['prenom'] ?? ''} ${formData['nom'] ?? ''}'.trim(),
      'email': formData['email'],
      ...formData,
    };

    print("📤 Envoi de la création de compte utilisateur à Laravel (/register)...");

    for (int attempt = 1; attempt <= 2; attempt++) {
      try {
        // ⏱️ On force un timeout de 15 secondes pour éviter le blocage infini dans le vide
        final result = await _api.registerUser(dataToSend).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Timeout : Le serveur Laravel met trop de temps à répondre.');
          },
        );

        if (result['success'] == true && result['token'] != null) {
          await _storage.saveToken(result['token']);
          try {
            await _db.saveUserLocally(result);
          } catch (e) {
            print("⚠️ Sauvegarde locale ignorée : $e");
          }
        }
        return result;

      } catch (e) {
        String errorStr = e.toString();
        print("⚠️ Erreur inscription tentative $attempt : $errorStr");

        if ((errorStr.contains('Failed host lookup') || errorStr.contains('SocketException')) && attempt == 1) {
          print("🔄 Tentative d'inscription n°2 suite à un hoquet réseau...");
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }
        break;
      }
    }

    return {
      'success': false,
      'error': 'Erreur de connexion au serveur lors de l\'inscription. Vérifiez votre réseau.'
    };
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