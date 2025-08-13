import 'package:ets/model/employe_model.dart';
import 'package:ets/service/dynamic_service.dart';
import 'package:flutter/material.dart';

class DynamicProvider extends ChangeNotifier{
  DynamicApiService _dynamicApiService = DynamicApiService();
 
 List<EmployeeDetails> _listEmployeDetails = [];
 List<EmployeeDetails> get listEmployeDetails => _listEmployeDetails;


 getEmployeeList(String endPoint) async{
     var response = await _dynamicApiService.getEmployeList(endPoint);
 }
  

}