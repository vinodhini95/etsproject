import 'dart:convert';

import 'package:ets/service/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  Future<dynamic> postMethod(String url, dynamic data) async {
    print('$BASE_URL${url}');
    String token = await getToken();

    String OrgId = await getOrgId();
    print(token);
    var headers = {
      "Content-Type": "application/json",
      "Orgid": OrgId,
      'Authorization': 'Bearer ' + token
    };

    try {
      var response = await http.post(
        Uri.parse("$BASE_URL$url"),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response message: ${response}');

      Map<String, dynamic> result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          "status": response.statusCode,
          "data": result["data"] ?? [],
        };
      } else if (response.statusCode == 400) {
        return {
          "status": 400,
          "data": {
            "message": result['message'],
          }
        };
      } else if (response.statusCode == 500) {
        var text = (response.body.toString());
        print(text);
        return {
          "status": response.statusCode,
          "data": {
            "message": result['message'],
          }
        };
      } else {
        var result = jsonDecode(response.body);
        return result;
      }
    } catch (error) {
      print('Error occurred: $error["message"]');
      return {
        "status": "error",
        "network": true,
        "message": "An error occurred",
        "details": error.toString(),
      };
    }
  }
  //fetch dropdown data
  fetchDropdownData(String endPoint, Map<String, dynamic> payload) async {
    try {
      var response = await postMethod(endPoint, payload);

      List<dynamic> responseToken = response["data"][0]['response'];

      return responseToken;
    } catch (e) {}
  }

    Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  Future<String> getOrgId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('org_id') ?? "";
  }
}