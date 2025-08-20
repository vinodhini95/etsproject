
import 'package:ets/model/device_info_model.dart';
import 'package:ets/service/auth_service.dart';
import 'package:ets/service/device_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  dynamic _getleavelist;
  dynamic get getleavelist => _getleavelist;

  dynamic _getleavedatas;
  dynamic get getleavedatas => _getleavedatas;

  final AuthService _authService = AuthService();
  Postauthlogin( String empId,
       String mobileNo,
       bool deactiveDevice , BuildContext context) async {
        DeviceInfo deviceInfo = await DeviceService().deviceDetails();
    try {
      var loginReg = {
      "type": "mobile",
      "device_info": deviceInfo.toJson(),
      "name": deviceInfo.brand,
      "ime": deviceInfo.id,
      "emp_id": empId,
      "mobile": mobileNo,
      "is_deactive_device": deactiveDevice
    };
      var response = await _authService.authlogin(loginReg, context);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}
