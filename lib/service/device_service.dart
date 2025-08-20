import 'dart:io';

import 'package:ets/model/device_info_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ets/provider/local_provider.dart';
import 'package:ets/service/config/connectve_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceService {
  // Featch Device info
  Future<DeviceInfo> deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin =  DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo _androidDeviceInfo = await deviceInfoPlugin.androidInfo;

      return DeviceInfo(
          id: _androidDeviceInfo.id,
          model: _androidDeviceInfo.model,
          brand: _androidDeviceInfo.brand,
          device: _androidDeviceInfo.device,
          sdk: _androidDeviceInfo.version.sdkInt.toString());
    } else if (Platform.isIOS) {
      IosDeviceInfo _iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return DeviceInfo(
          id: _iosDeviceInfo.identifierForVendor,
          model: _iosDeviceInfo.model,
          brand: 'iphone',
          device: _iosDeviceInfo.utsname.machine,
          sdk: _iosDeviceInfo.utsname.sysname);
    }
    return DeviceInfo();
  }

  // check online
  checkOnline(BuildContext context) async {
    var connectivity = await ConnectivityService().checkConnectivity();
    if (connectivity == 'online') {
      // context.read<LocalProvider>().removeOfflineData();
    }
  }
}