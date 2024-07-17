import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:domestik/services/user_service.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';

// Fonction pour créer un client HTTP avec vérification SSL désactivée
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// Créer un foyer
Future<ApiResponse> createFoyer(String name) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(createFoyerURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({'name': name}));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody)["message"];
        break;
      case 422:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(responseBody)['message'];
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
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(userURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');


    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody)["user"]["foyer"];
        break;
      case 422:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(responseBody)['message'];
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
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(userURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');


    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody)["user"]["foyer"]["id"];
        break;
      case 422:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(responseBody)['message'];
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
