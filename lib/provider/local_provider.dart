import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProvider extends ChangeNotifier {

  int _selectedIndexPosition = 0;
  int get selectedIndexPosition => _selectedIndexPosition;

//selected Index position
selectedIndex(int selectedValue){
  _selectedIndexPosition = selectedValue;
  notifyListeners();
}

//save local storage values
saveLocalStorage(String key,String values) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key,values);
}
 saveLocalStorageAsObject(String key, dynamic values) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(values);
  await prefs.setString(key, jsonString);
}

getLocalStorageAsObject(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(key);
  if (jsonString != null) {
   var values = jsonDecode(jsonString);
    return values;
  }
  return null;
}

//get local values
getLocalStorage(String key) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.get(key) ?? "";   
}

deleteLocalStorage(String key) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.remove(key);   
}

deleteLocalStorageMasterData()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("BO");
  prefs.remove("CR");
  prefs.remove("SH");
  prefs.remove("COK");
  prefs.remove("MACP");
  prefs.remove("MANG"); 
}
}