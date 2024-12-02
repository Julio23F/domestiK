import 'dart:convert';
import 'dart:io';

import 'package:domestik/services/user_service.dart';
import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

// Fonction pour créer un client HTTP avec vérification SSL désactivée
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
}

// Créer un foyer
Future<ApiResponse> createFoyer(String name) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Effectuer la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(createFoyerURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    // Affichage pour le débogage
    print("name: $name");
    print("Response status code: ${response.statusCode}");

    // Gestion de la réponse avec switch
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["message"];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

// Obtenir les données du foyer
Future<ApiResponse> getFoyerData() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Effectuer la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Gestion de la réponse avec switch
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["user"]["foyer"];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

// Obtenir l'ID du foyer
Future<ApiResponse> getFoyerId() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Effectuer la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Gestion de la réponse avec switch
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["user"]["foyer"]["id"];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
