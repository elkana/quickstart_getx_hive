import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickstart_getx_hive/models/user_model.dart';
import 'package:quickstart_getx_hive/utils/commons.dart';

import '../utils/net_util.dart';
import '../utils/screen_util.dart';

class Api extends GetConnect {
  static Api instance = Get.find();
  static const timeoutSeconds = 10;

  static var apiKey = 'DUMMYKEY123';
  static var serverUrl = 'https://192.168.111.111:8090';
  static var uriLogin = '/v1/login';

  @override
  bool get allowAutoSignedCert => true;

  @override
  void onInit() {
    super.onInit();

    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers.addAll({'ApiKey': apiKey});
      return request;
    });
  }

  /// use Dio to upload/download pictures
  dioLib.Dio _initDio() {
    var dio = dioLib.Dio()
      ..options.connectTimeout = 5000 //5s
      ..options.receiveTimeout = 3000
      ..options.headers['ApiKey'] = apiKey;

    if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          /* see https://pub.dev/packages/dio  format of certificate must be PEM or PKCS12.
        if (cert.pem == PEM) {
          // Verify the certificate
          return true;
        }
        return false;
        */
          return true;
        };
        return null;
      };
    } else {
      // (dio.httpClientAdapter as BrowserHttpClientAdapter).onHttpClientCreate =
      //     (client) {
      //   client.badCertificateCallback =
      //       (X509Certificate cert, String host, int port) {
      //     /* see https://pub.dev/packages/dio  format of certificate must be PEM or PKCS12.
      //   if (cert.pem == PEM) {
      //     // Verify the certificate
      //     return true;
      //   }
      //   return false;
      //   */
      //     return true;
      //   };
      // };
    }
    return dio;
  }

  Future<Response> postUri(String uri, dynamic body,
      {Map<String, dynamic>? query}) async {
    var resp = await super
        .post('$serverUrl$uri', body, query: query)
        .timeout(const Duration(seconds: timeoutSeconds))
        .onError((error, stackTrace) {
      if (error is TimeoutException) {
        ScreenUtil.showToast('Timeout ! Check your connection', error: true);
        throw TimeoutException('Check your connection');
      } else {
        throw error!;
      }
    });
    log('postUri.resp => $resp for $serverUrl$uri');
    return resp;
  }

  Future<Response> getUri(String uri, {Map<String, dynamic>? query}) async {
    log('Api.getUri => $serverUrl$uri');
    var resp = await super
        .get('$serverUrl$uri', query: query)
        .timeout(const Duration(seconds: timeoutSeconds))
        .onError((error, stackTrace) {
      if (error is TimeoutException) {
        ScreenUtil.showToast('Timeout ! Check your connection', error: true);
        throw TimeoutException('Check your connection');
      } else {
        ScreenUtil.showToast('GetUri failed ${error.toString()}', error: true);
        throw error!;
      }
    });

    return resp;
  }

  /// //////////////// DIO ////////////////////////
  ///
  dynamic downloadPhoto(String uri, String fileName,
      {bool useCache = false}) async {
    var dir = await getTemporaryDirectory();
    if (!kIsWeb && (useCache || await NetUtil.isNotConnected())) {
      File file = File('${dir.path}/$fileName');
      bool _exist = file.existsSync();
      return file;
    }

    var dio = _initDio();

    log('downloadPhoto.Api => $serverUrl$uri');

    Uri? _uri = Uri.tryParse('$serverUrl$uri');

    var resp = await dio.getUri<List<int>>(_uri!,
        options: dioLib.Options(responseType: dioLib.ResponseType.bytes));

    if (kIsWeb) {
      //
    } else {
      File file = File('${dir.path}/$fileName');
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(resp.data!);
      await raf.close();
      return file;
    }
  }

  Future<String?> _uploadPhoto(String subUri, dioLib.FormData formData) async {
    var dio = _initDio();
    Uri? uri = Uri.tryParse('$serverUrl$subUri');
    // UPLOADING /storage/.../scaled_[uuid].jpg
    // log('UPLOADING ${filePhoto.path} to $uri');

    var res = await dio
        .postUri<String>(uri!,
            options: dioLib.Options(
                method: 'POST', responseType: dioLib.ResponseType.json),
            data: formData)
        .then((response) {
      // response = profile.jpg
      log('uploading response $response'); //foto_ldv_depan_rmh_0016074932_0006017179-001.jpg
      return response;
    }).catchError((error) {
      log('Failed Upload $error $uri');
    });

    return res.toString() == "null" ? null : res.toString();
  }

  Future<List<T>?> postList<T>(
      String uri,
      List<T> list,
      Map<String, dynamic> Function(T) obj2Json,
      T Function(dynamic) json2Obj) async {
    var resp = await postUri(uri, list.map((e) => obj2Json(e)).toList());
    if (resp.hasError) {
      return Future.error('(${resp.statusCode ?? '_'}) ${resp.statusText!}');
    }
    if (resp.body == null) return null;
    return (resp.body as Iterable).map<T>((e) => json2Obj(e)).toList();
  }

  Future<List<T>?> getList<T>(String uri, T Function(dynamic) json2Obj,
      {Map<String, dynamic>? query}) async {
    var resp = await getUri(uri, query: query);
    if (resp.hasError) {
      return Future.error('(${resp.statusCode ?? '_'}) ${resp.statusText!}');
    }
    if (resp.body == null) return null;
    return (resp.body as Iterable).map<T>((e) => json2Obj(e)).toList();
  }

  Future<T?> getData<T>(String uri, T Function(dynamic)? json2Obj,
      {Map<String, dynamic>? query}) async {
    var resp = await getUri(uri, query: query);
    if (resp.hasError) {
      return Future.error('(${resp.statusCode ?? '-'}) ${resp.statusText!}');
    }
    if (resp.body == null) return null;
    return json2Obj == null ? resp.body : json2Obj(resp.body);
  }

  Future<UserModel?> login(String userId, String userPwd) async {
    var resp = await post(
      '$serverUrl$uriLogin?devicesn=EMULATOR30X1X2X2',
      // '$url/collector/v1/login?devicesn=EMULATOR30X1X2X2',
      <String, dynamic>{
        'username': userId,
        'password': userPwd,
      },
    )
        .timeout(const Duration(seconds: timeoutSeconds))
        .onError((error, stackTrace) {
      throw error!;
    });

    if (resp.hasError) {
      debugPrint('Error when login => $serverUrl$uriLogin');
      return Future.error('(${resp.statusCode ?? '_'}) ${resp.statusText!}');
    } else {
      // TODO you must test if json able to decode here
      return UserModel.fromJson(resp.body);
    }
  }

  Future<UserModel?> signUp(
      String fullName, String userId, String password) async {
    var resp = await post(
      '$serverUrl$uriLogin?devicesn=EMULATOR30X1X2X2',
      // '$url/collector/v1/login?devicesn=EMULATOR30X1X2X2',
      <String, dynamic>{
        'username': userId,
        'password': password,
      },
    )
        .timeout(const Duration(seconds: timeoutSeconds))
        .onError((error, stackTrace) {
      throw error!;
    });

    if (resp.hasError) {
      debugPrint('Error when login => $serverUrl$uriLogin');
      return Future.error('(${resp.statusCode ?? '_'}) ${resp.statusText!}');
    } else {
      // TODO you must test if json able to decode here
      return UserModel.fromJson(resp.body);
    }
  }
}
