import 'package:flutter/services.dart';

class DynamicApiService {

  loadJson(String screensName, String path) {
    var response = rootBundle.loadString('${screensName}${path}');
    return response;
  }
}
