
import 'package:ets/provider/json_data_provider.dart';
import 'package:provider/provider.dart';

class InitiateFlutterPackage {
  getProviderChangeNotifier() {
    var listChangeNotifier = [
      ChangeNotifierProvider(create: (_) => JsonDataProvider()),
    ];
    return listChangeNotifier;
  }
}
