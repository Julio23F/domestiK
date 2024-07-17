import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';

// Fonction pour créer un client HTTP avec vérification SSL désactivée
HttpClient createHttpClient() {
  return HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

// login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(loginURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.write(jsonEncode({'email': email, 'password': password}));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(responseBody));
        break;
      case 422:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(responseBody)['errors'];
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

// Register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(registerURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    }));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(responseBody));
        break;
      case 422:
        final errors = jsonDecode(responseBody)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print(apiResponse.error);
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }
  print('apiResponse.error');
  print(apiResponse.error);
  return apiResponse;
}

// User
Future<ApiResponse> getUserDetailSercice() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(userURL));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');

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

// Obtenir le mode choisi par l'utilisateur
Future<bool> getUserMode() async {
  ApiResponse response = await getUserDetailSercice();
  final data = jsonEncode(response.data);
  final mode = jsonDecode(data)["user"]["mode"];
  print('mode avant');
  print(mode);
  return (mode == 1) ? true : false;
}

// Obtenir tous les utilisateurs qui ne sont pas encore dans un foyer
Future<ApiResponse> getAllUser() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.getUrl(Uri.parse(allUser));
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');

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

// Ajouter des utilisateurs dans un foyer
Future<void> addUser(List<int> userIds) async {
  String token = await getToken();
  ApiResponse data = await getUserDetailSercice();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];

  final String url = '${addUsers}/$foyer_id/addUser';

  final client = createHttpClient();
  final request = await client.postUrl(Uri.parse(url));
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');
  request.write(jsonEncode(userIds));

  final response = await request.close();

  if (response.statusCode == 200) {
    print('Utilisateurs ajoutés avec succès');
  } else {
    print('Erreur: ${response.statusCode}');
    print('Message: ${await response.transform(utf8.decoder).join()}');
  }
}

// Activer ou désactiver un utilisateur
Future<ApiResponse> activeOrDisableService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(activeOrUnable));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode({"userId": userId.toString()}));

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

// Changer l'admin du foyer
Future<ApiResponse> changeAdminService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(change_admin));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode({"userId": userId.toString()}));

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

// Mettre à jour le mode (dark or light) choisi par l'utilisateur dans la base de données
Future<ApiResponse> updateUserPreference(bool mode) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(preference));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode({"mode": mode.toString()}));

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

// Mettre à jour le profil
Future<ApiResponse> updateUserService(String path) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.postUrl(Uri.parse(constUpdateUser));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode({"profil": path.toString()}));

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

// Retirer un utilisateur d'un foyer
Future<ApiResponse> removeUserService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final client = createHttpClient();
    final request = await client.deleteUrl(Uri.parse(remove_user));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode({"userId": userId.toString()}));

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

// Obtenir tous les utilisateurs qui sont dans le foyer
Future<ApiResponse> getMembre() async {
  ApiResponse apiResponse = ApiResponse();
  ApiResponse data = await getUserDetailSercice();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
  try {
    String token = await getToken();
    final client = createHttpClient();
    final String url = '${allMembre}/${foyer_id}/allMembre';
    final request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json'); // Ajout de l'en-tête

    request.headers.set('Authorization', 'Bearer $token');

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

// Obtenir le token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Obtenir l'ID de l'utilisateur
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
