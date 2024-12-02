import 'dart:convert';
import 'dart:io';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

// Create HTTP client with SSL verification disabled
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// Get Todo Tasks
Future<ApiResponse> todoTache(String date) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);

    // Récupération de l'ID du foyer
    int foyerId = jsonDecode(userDetail)["user"]["foyer_id"];

    final uri = '$urlAllUserTache/$foyerId/todoTache';

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'date': date}),
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else if (response.statusCode == 422 || response.statusCode == 401) {
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

// Add Task
Future<ApiResponse> addTacheService(String name, String color) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int foyerId = jsonDecode(userDetail)["user"]["foyer_id"];
    final uri = '$tache/$foyerId/tache';

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'color': color,
      }),
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
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

// Get all Tasks in the household
Future<ApiResponse> getTache() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer les détails de l'utilisateur
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int foyerId = jsonDecode(userDetail)["user"]["foyer_id"];

    // Récupérer le token d'authentification
    String token = await getToken();
    final String url = '$allMembre/$foyerId/tache';

    // Envoyer la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      apiResponse.error = unauthorized;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Delete Task
Future<ApiResponse> deleteTacheService(int tacheId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Récupérer le token d'authentification
    String token = await getToken();

    // Envoyer la requête DELETE avec la bibliothèque http
    final response = await http.delete(
      Uri.parse(delete_tache),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"tacheId": tacheId.toString()}),
    );

    // Gestion de la réponse
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      apiResponse.error = unauthorized;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}