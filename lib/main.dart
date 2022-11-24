import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocity_x/velocity_x.dart';

import 'configs/locales.dart';
import 'controllers/auth_controller.dart';
import 'controllers/pref_controller.dart';
import 'pages/home/home_view.dart';
import 'pages/login/login_view.dart';
import 'pages/login/reset_pwd/resetpwd_view.dart';
import 'pages/login/signup/signup_view.dart';
import 'providers/api.dart';
import 'routes/app_routes.dart';
import 'utils/hive_util.dart';
import 'widgets/common.dart';

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
            Get.lazyPut<PrefController>(() => PrefController());
          }),
          onInit: () async {
            await HiveUtil.registerAdaptersFirstTime();
            await GetStorage.init();
          },
          theme: ThemeData.dark(),
          locale: const Locale('en', 'US'),
          translationsKeys: AppTranslation.translations,
          getPages: [
            GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
            GetPage(name: Routes.signup, page: () => const SignUpView(), binding: SignUpBinding()),
            GetPage(name: Routes.resetPwd, page: () => const ResetPwdView(), binding: ResetPwdBinding()),
            GetPage(name: Routes.home, page: () => const HomeView(), binding: HomeBinding()),
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
    // enable this to skip splash
    // AuthController.instance.user.value = null;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return [
          Image.asset('images/splash1.png', package: 'quickstart_getx_hive'),
          const Spacer(),
          MyButton('Lets Go', onTap: () => AuthController.instance.user.value = null)
        ].column().centered().p64().backgroundColor(const Color.fromRGBO(47, 132, 232, 1));
      });
}
