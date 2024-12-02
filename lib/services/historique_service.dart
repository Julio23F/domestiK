import 'dart:convert';
import 'dart:io';

import 'package:domestik/services/user_service.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/historique.dart';
import 'package:http/http.dart' as http;

// Créer un client HTTP avec vérification SSL désactivée
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// Ajouter dans Historique
Future<ApiResponse> addHistoriqueService(List tacheIds) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Récupérer les détails de l'utilisateur
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int userId = jsonDecode(userDetail)["user"]["id"];

    // Construire la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(historique),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'taches': tacheIds,
      }),
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.message = jsonDecode(response.body)['message'];
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    } else if (response.statusCode == 403) {
      apiResponse.error = jsonDecode(response.body)['message'];
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

// Récupérer les historiques à confirmer
Future<ApiResponse> historiqueToConfirmService() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Effectuer la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(historique),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.data = (jsonDecode(response.body) as List)
          .map((p) => Historique.fromJson(p))
          .toList();
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    } else if (response.statusCode == 403) {
      apiResponse.error = jsonDecode(response.body)['message'];
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

// Confirmer un historique
Future<ApiResponse> confirmService(int historiqueId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Effectuer la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(confirmer),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'historique_id': historiqueId,
      }),
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.message = jsonDecode(response.body)['message'];
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    } else if (response.statusCode == 403) {
      apiResponse.error = jsonDecode(response.body)['message'];
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}