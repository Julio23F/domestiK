// login
import 'dart:convert';

import 'package:domestik/services/user_service.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> createFoyer (String name) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
        Uri.parse(createFoyerURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {'name': name}
    );
    print(response.statusCode);
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)["message"];
        print(apiResponse.data);
        break;
    // Si un champ n'est pas rempli
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