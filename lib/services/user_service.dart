import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';

// login
Future<ApiResponse> login (String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      // Si un champ n'est pas rempli
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      // Si l'utilisateur n'a pas de compte
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = e.toString();
  }

  return apiResponse;
}


// Register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password
        });

    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print(apiResponse.error);
        break;
    }
  }
  catch (e) {
    apiResponse.error = e.toString();
  }
  return apiResponse;
}


// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){

      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }

  }
  catch(e) {
    apiResponse.error = serverError;
    debugPrint(e.toString());

  }
  return apiResponse;
}

//Obtenir tous les utilisateurs qui ne sont pas encore dans un foyer
Future<ApiResponse> getAllUser() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse(allUser),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){

      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }

  }
  catch(e) {
    apiResponse.error = serverError;
    debugPrint(e.toString());

  }
  return apiResponse;
}


//Ajouter des utilisateurs dans un foyer
Future<void> addUser(List<int> userIds) async {
  String token = await getToken();
  ApiResponse data = await getUserDetail();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];

  final String url = '${addUsers}/$foyer_id/addUser';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userIds),
  );

  if (response.statusCode == 200) {
    print('Utilisateurs ajoutés avec succès');
  } else {
    print('Erreur: ${response.statusCode}');
    print('Message: ${response.body}');
  }
}

//Obtenir tous les utilisateurs qui sont dans le foyer
Future<ApiResponse> getMembre() async {
  ApiResponse apiResponse = ApiResponse();
  ApiResponse data = await getUserDetail();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
  try {
    String token = await getToken();
    final String url = '${allMembre}/${foyer_id}/allMembre';
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print(response.statusCode);
    switch(response.statusCode){

      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }

  }
  catch(e) {
    apiResponse.error = serverError;
    debugPrint(e.toString());

  }
  return apiResponse;
}


Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');

}

