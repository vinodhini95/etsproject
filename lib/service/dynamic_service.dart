import 'package:ets/service/api_service.dart';
import 'package:ets/service/config/config.dart';
import 'package:flutter/services.dart';

class DynamicApiService {
  ApiService _apiService = ApiService();

  loadJson(String screensName, String path) {
    var response = rootBundle.loadString('${screensName}${path}');
    return response;
  }

  // load employee list
  getEmployeList(String endPoint) async {
    var url = "$BASE_URL/$ENTITIES/$FILTER/$endPoint";
    var payload = {
      "filter": [
        {
          "clause": "AND",
          "conditions": [
            {
              "column": "supervisor_id",
              "operator": "EQUALS",
              "type": "string",
              "value": "EMP00002"
            }
          ]
        }
      ]
    };
    var response = await _apiService.postMethod(url, payload);

    return response;
  }
}
