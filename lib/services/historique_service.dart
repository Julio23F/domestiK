import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:domestik/services/user_service.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/historique.dart';

// Créer un client HTTP avec vérification SSL désactivée
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// Ajouter dans Historique
Future<ApiResponse> addHistoriqueService(List tacheIds) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int userId = jsonDecode(userDetail)["user"]["id"];

    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(historique));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({
      'user_id': userId,
      'taches': tacheIds,
    }));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.message = jsonDecode(responseBody)['message'];
        break;
      case 422:
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

// Récupérer les historiques à confirmer
Future<ApiResponse> historiqueToConfirmService() async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(historique));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(responseBody) as List)
            .map((p) => Historique.fromJson(p))
            .toList();
        break;
      case 422:
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

// Confirmer un historique
Future<ApiResponse> confirmService(int historiqueId) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(confirmer));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode({
      'historique_id': historiqueId,
    }));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.message = jsonDecode(responseBody)['message'];
        break;
      case 422:
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
