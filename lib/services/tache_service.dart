// login
import 'dart:convert';

import 'package:domestik/services/user_service.dart';
import 'package:flutter/cupertino.dart';

import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import 'foyer_service.dart';

Future<ApiResponse> todoTache (date) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    // ApiResponse foyer = await getFoyerId();
    ApiResponse data = await getUserDetail();
    final userDetail = jsonEncode(data.data);
    int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
    print(foyer_id);
    final uri = '$urlAllUserTache/${foyer_id}/todoTache';
    final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {'date': date}
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
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


//Add tache
Future<ApiResponse> addTache(String name, String color) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  try {
    ApiResponse data = await getUserDetail();
    final userDetail = jsonEncode(data.data);
    int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
    final uri = '${tache}/${foyer_id}/tache';
    final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name': name,
          'color': color
        });
    print(response.statusCode);

    switch(response.statusCode) {
      case 200:
        apiResponse.message = jsonDecode(response.body)['message'];
        print(apiResponse.message);
        break;
      case 422:
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
  }
  catch (e) {
    apiResponse.error = e.toString();
  }
  print(apiResponse.error);

  return apiResponse;
}

//Obtenir tous les utilisateurs qui sont dans le foyer
Future<ApiResponse> getTache() async {
  ApiResponse apiResponse = ApiResponse();
  ApiResponse data = await getUserDetail();
  final userDetail = jsonEncode(data.data);
  int foyer_id = jsonDecode(userDetail)["user"]["foyer_id"];
  try {
    String token = await getToken();
    final String url = '${allMembre}/${foyer_id}/tache';
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