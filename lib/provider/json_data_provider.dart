import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonDataProvider extends ChangeNotifier {
  List<String> _addedScreen = [];
  List<String> get addedScreen => _addedScreen;
  Map<String, dynamic> totalData = {};

  Future<void> loadJsonData(String jsonPath, BuildContext context) async {
    try {
      //store in local
      if (_addedScreen.isEmpty) {
        _addedScreen.add(jsonPath);
      } else if (!_addedScreen.contains(jsonPath)) {
        _addedScreen.add(jsonPath);
      }
      // var jsonData = await DynamicApiService().loadScreens(jsonPath, context);
      // Map<String, dynamic> decodedData = jsonData.isNotEmpty
      //     ? jsonDecode(jsonData[0]["config"])
      //     : jsonDecode("{}");
      String jsonData = await rootBundle.loadString(jsonPath);
      Map<String, dynamic> decodedData = json.decode(jsonData);

      totalData = decodedData;
      notifyListeners();
    } catch (e) {
      print("Error loading json: $e");
    }
  }
loadJson(String jsonPath, BuildContext context) async {
    try {
      String jsonData = await rootBundle.loadString(jsonPath);
      Map<String, dynamic> decodedData = json.decode(jsonData);
      notifyListeners();
      return decodedData;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading json: $e");
      }
    }
  }
  void clearData() {
    totalData.clear();
    notifyListeners();
  }
}
