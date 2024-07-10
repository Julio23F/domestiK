import 'dart:convert';

import 'package:domestik/services/user_service.dart';

import '../constant.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import '../models/historique.dart';

//Add in Historique
Future<ApiResponse> addHistoriqueService(List tacheIds) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    ApiResponse data = await getUserDetailSercice();
    final userDetail = jsonEncode(data.data);
    int user_id = jsonDecode(userDetail)["user"]["id"];

    final response = await http.post(
      Uri.parse('${historique}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': user_id,
        'taches': tacheIds,
      }),
    );


    switch(response.statusCode) {
      case 200:
        apiResponse.message = jsonDecode(response.body)['message'];
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
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> historiqueToConfirm() async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(
      Uri.parse('${historique}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body) as List)
            .map((p) => Historique.fromJson(p))
            .toList();
        // var data = apiResponse.data as List<Historique>;
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
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}


Future<ApiResponse> confirmService(int historique_id) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('${confirmer}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'historique_id': historique_id,
      }),
    );

    print(response.statusCode);
    switch(response.statusCode) {
      case 200:
        apiResponse.message = jsonDecode(response.body)['message'];
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
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}
