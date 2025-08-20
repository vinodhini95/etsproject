

import 'package:ets/provider/local_provider.dart';
import 'package:ets/service/api_service.dart';
import 'package:ets/service/config/config.dart';
import 'package:flutter/material.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final LocalProvider _localProvider = LocalProvider();



// LOGIN API
  authlogin(Map<String, dynamic> loginReq, BuildContext context) async {
    try {
      var url = '$AUTH/$DIVICE/$LOGIN';
      var response = await _apiService.authpostMethod(
        url,
        loginReq,
      );

      try {
        Map<String, dynamic> responseToken = response["data"]['LoginResponse'];

        // Obtain shared preferences.
        _localProvider.saveLocalStorage('token', responseToken['token']);
        _localProvider.saveLocalStorage('org_id', responseToken['org']['_id']);
        _localProvider.saveLocalStorage('name', responseToken['name']);
        // final decodedToken = JwtDecoder.decode(responseToken['token']);

        // var endPoint = "entities/user/" + decodedToken["id"]; //token id
        // var res = await _apiService.getbyId(endPoint, responseToken['token']);

        // _localProvider.saveLocalStorageAsObject('user_data', res);
        // var facEndPoint = "entities/factory/" + res["factory_id"];
        // var facData =
        //     await _apiService.getbyId(facEndPoint, responseToken['token']);

        // _localProvider.saveLocalStorage(
        //     'factory_name', facData["factory_name"]);
        // var unitEndPoint = "entities/unit/" + res["unit_id"];
        // var uniData =
        //     await _apiService.getbyId(unitEndPoint, responseToken['token']);

        // _localProvider.saveLocalStorage('unit_name', uniData["unit_name"]);
      } catch (e) {}
      return response;
    } catch (e) {}
  }
  
}
