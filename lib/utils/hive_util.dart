import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickstart_getx_hive/models/user_model.dart';

class HiveUtil {
  static const typeIdUserModel = 0;

  static Future registerAdaptersFirstTime() async {
    if (!kIsWeb) {
      WidgetsFlutterBinding.ensureInitialized();
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }

    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox<UserModel>(UserModel.syncTableName);
  }
}
