import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  //  check connectivity
  Future<String> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return 'online';
    } else {
      return 'offline';
    }
  }
}
