// ignore_for_file: file_names

import 'dart:io';

import 'package:ets/model/employe_model.dart';
import 'package:ets/objectbox.g.dart' show openStore;
import 'package:ets/provider/auth_provider.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class LocalDB {
  /// The Store of this app.
  late final Store store;
  // ignore: prefer_typing_uninitialized_variables
  late final employeeBox;

  LocalDB._create(this.store) {
    employeeBox = store.box<EmployeeDetails>();
  }

  static get box => null;

  static Future<LocalDB> create() async {
    try {
      final store = await openStore();
      return LocalDB._create(store);
    } catch (e) {
      await _deleteCacheDir();
    }
    final store = await openStore();
    // AuthProvider().logout();
    return LocalDB._create(store);
  }

  static Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    Directory docDir = await getApplicationDocumentsDirectory();
    if (docDir.existsSync()) {
      docDir.deleteSync(recursive: true);
    }
  }

}
