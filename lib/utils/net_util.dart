import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

// for web, use web_util
class NetUtil {
  static Future<bool> isConnected() async {
    // always tru for web
    if (kIsWeb) return true;

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        return true;
      }

      // 13 jan 21 ternyata lookup ke google bisa lama. never happenned before.
      // sementara disable dulu fitur ini
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   return true;
      // }
    } on SocketException catch (_) {}
    return false;
  }

  static Future<bool> isNotConnected() async => !(await isConnected());
}
