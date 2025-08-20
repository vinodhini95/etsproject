
import 'package:ets/provider/auth_provider.dart';
import 'package:ets/provider/camera_service.dart';
import 'package:ets/provider/dynamic_provider.dart';
import 'package:ets/provider/json_data_provider.dart';
import 'package:ets/provider/local_provider.dart';
import 'package:provider/provider.dart';

class InitiateFlutterPackage {
  getProviderChangeNotifier() {
    var listChangeNotifier = [
      ChangeNotifierProvider(create: (_) => JsonDataProvider()),
      ChangeNotifierProvider(create: (_) => LocalProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => DynamicProvider()),
      ChangeNotifierProvider.value(value: CameraService()),
    ];
    return listChangeNotifier;
  }
}
