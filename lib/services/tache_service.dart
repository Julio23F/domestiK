// login
import 'dart:convert';

import 'package:domestik/services/user_service.dart';

import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import 'foyer_service.dart';

Future<ApiResponse> todoTache (date) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    ApiResponse foyer = await getFoyerId();
    final uri = '$urlAllUserTache/${foyer.data}/todoTache';
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
Future<ApiResponse> addTache(String name) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  try {

    int foyer_id = 8;
    final uri = '${tache}/${foyer_id}/tache';
    final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name': name,
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
