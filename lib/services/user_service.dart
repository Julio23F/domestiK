import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['errors'];
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
    // Envoie de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    final responseBody = response.body;

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
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

// User
Future<ApiResponse> getUserDetailSercice() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    // Envoie de la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = response.body;

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
  }
  return apiResponse;
}
// Obtenir le mode choisi par l'utilisateur
Future<bool> getUserMode() async {
  ApiResponse response = await getUserDetailSercice();
  final data = jsonEncode(response.data);
  final mode = jsonDecode(data)["user"]["mode"];
  return (mode == 1) ? true : false;
}

// Obtenir tous les utilisateurs qui ne sont pas encore dans un foyer
Future<ApiResponse> getAllUser() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(allUser),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = response.body;

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
  }

  return apiResponse;
}

// Ajouter des utilisateurs dans un foyer
Future<void> addUser(List<int> userIds) async {
  String token = await getToken();
  ApiResponse data = await getUserDetailSercice();
  final userDetail = jsonEncode(data.data);
  int foyerId = jsonDecode(userDetail)["user"]["foyer_id"];

  // Construction de l'URL
  final String url = '$addUsers/$foyerId/addUser';

  // Envoi de la requête POST avec la bibliothèque http
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(userIds),
  );

  // Gestion de la réponse
  if (response.statusCode == 200) {
    print('Utilisateurs ajoutés avec succès');
  } else {
    print('Message: ${response.body}');
  }
}

//Créer un groupe
Future<ApiResponse> createGroupeService(String groupeName, List<int> userIds) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(groupe),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': groupeName,
        'usersId': userIds,
      }),
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
    print('Une erreur est survenue: $e');
    apiResponse.error = e.toString(); // Ajout de l'erreur dans la réponse
  }
  return apiResponse;
}

// Retirer un utilisateur du groupe
Future<ApiResponse> removeFromGroupeService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête DELETE avec la bibliothèque http
    final response = await http.delete(
      Uri.parse(remove),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"userId": userId}), // Envoi du userId dans le corps de la requête
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

Future<ApiResponse> deleteGroupeService(int groupeId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête DELETE avec la bibliothèque http
    final response = await http.delete(
      Uri.parse(deleteGroupe),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"groupeId": groupeId}), // Envoi du groupeId dans le corps de la requête
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

//Obtenir la liste des groupe
Future<ApiResponse> getListGroupeService() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    // Envoi de la requête GET avec la bibliothèque http
    final response = await http.get(
      Uri.parse(listGroupe),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
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

// Activer ou désactiver un utilisateur
Future<ApiResponse> activeOrDisableService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(activeOrUnable),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"userId": userId.toString()}),
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

// Changer l'admin du foyer
Future<ApiResponse> changeAdminService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(change_admin),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"userId": userId.toString()}),
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

// Mettre à jour le mode (dark or light) choisi par l'utilisateur dans la base de données
Future<ApiResponse> updateUserPreference(bool mode) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(preference),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"mode": mode.toString()}),
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

// Mettre à jour le profil
Future<ApiResponse> updateUserService(String path) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(constUpdateUser),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"profil": path}),
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

// Retirer un utilisateur d'un foyer
Future<ApiResponse> removeUserService(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    // Envoi de la requête DELETE avec la bibliothèque http
    final response = await http.delete(
      Uri.parse(remove_user),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"userId": userId.toString()}),
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

// Obtenir tous les utilisateurs qui sont dans le foyer
Future<ApiResponse> getMembre(groupeId) async {
  ApiResponse apiResponse = ApiResponse();

  // Récupération des détails de l'utilisateur
  ApiResponse data = await getUserDetailSercice();
  final userDetail = jsonEncode(data.data);
  int foyerId = jsonDecode(userDetail)["user"]["foyer_id"];

  try {
    String token = await getToken();
    final String url = '$allMembre/$foyerId/allMembre';

    // Envoi de la requête POST avec la bibliothèque http
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'groupeId': groupeId}),
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
