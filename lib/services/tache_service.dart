import 'dart:convert';
import 'dart:io';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import 'foyer_service.dart';

// Create HTTP client with SSL verification disabled
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// Get Todo Tasks
Future<ApiResponse> todoTache(date) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];

    final uri = '$urlAllUserTache/$foyer_id/todoTache';
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(uri));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({'date': date}));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody);
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

// Add Task
Future<ApiResponse> addTacheService(String name, String color) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
    final uri = '${tache}/$foyer_id/tache';

    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(uri));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({
      'name': name,
      'color': color,
    }));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody);
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

// Get all Tasks in the household
Future<ApiResponse> getTache() async {
  ApiResponse apiResponse = ApiResponse();
  ApiResponse data = await getUserDetailSercice();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];

  try {
    String token = await getToken();
    final String url = '${allMembre}/$foyer_id/tache';

    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    debugPrint(e.toString());
  }

  return apiResponse;
}

// Delete Task
Future<ApiResponse> deleteTacheService(int tacheId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final client = createHttpClient();
    final request = await client.deleteUrl(Uri.parse(delete_tache));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({"tacheId": tacheId.toString()}));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    debugPrint(e.toString());
  }

  return apiResponse;
}
