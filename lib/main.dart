import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'configs/locales.dart';
import 'controllers/auth_controller.dart';
import 'controllers/pref_controller.dart';
import 'pages/home/home_view.dart';
import 'pages/login/login_view.dart';
import 'pages/login/reset_pwd/resetpwd_view.dart';
import 'pages/login/signup/signup_view.dart';
import 'routes/app_routes.dart';
import 'utils/hive_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/api.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
          home: const SplashView(),
          initialBinding: BindingsBuilder(() {
            Get.put(Api());
            Get.put(AuthController());
          }),
          onInit: () async {
            await HiveUtil.registerAdaptersFirstTime();
            await Get.put(PrefController()).initStorage();
          },
          theme: ThemeData.dark(),
          locale: const Locale('en', 'US'),
          translationsKeys: AppTranslation.translations,
          getPages: [
            GetPage(name: Routes.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
            GetPage(name: Routes.SIGNUP, page: () => const SignUpView(), binding: SignUpBinding()),
            GetPage(name: Routes.RESET_PASSWORD, page: () => const ResetPwdView(), binding: ResetPwdBinding()),
            GetPage(name: Routes.HOME, page: () => const HomeView(), binding: HomeBinding()),
          ]);
}

/// we need to triger user.value = null by using a button or with delay
/// when using a button, call this:
/// ```
/// onPressed: () => Authcontroller.instance.user.value = null;
/// ```
class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  Future<void> initializeSettings() async {
    //TODO Simulate other services for 1 seconds
    await 1.delay();
    AuthController.instance.user.value = null;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: CircularProgressIndicator());
      });
}
