import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../configs/locales.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<LoginController>(() => LoginController());
}

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: kReleaseMode
          ? null
          : AppBar(
              actions: [
                TextButton(onPressed: () => controller.test('elkana911', 'elkana911'), child: const Text('Test User 1'))
              ],
            ),
      body: Form(
              child: [
                'Hello !'.text.xl3.bold.make().marginOnly(bottom: 20),
                const SizedBox(height: 20),
                // email
                TextFormField(
                    controller: controller.ctrlUserId,
                    textAlign: TextAlign.center,
                    validator: (val) => controller.validateUserId(val!),
                    onSaved: (val) => controller.ctrlUserId.text = val!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    autofocus: false,
                    decoration: const InputDecoration(
                        labelText: 'ID',
                        suffixIcon: SizedBox(),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0))),
                //password
                Obx(() => TextFormField(
                    controller: controller.ctrlPwd,
                    textAlign: TextAlign.center,
                    validator: (val) => controller.validatePassword(val!),
                    onSaved: (val) => controller.ctrlPwd.text = val!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(controller.obscurePwd.isTrue
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () => controller.obscurePwd.toggle()),
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0)),
                    obscureText: controller.obscurePwd.value)),
                // toggle rememberme
                Row(children: [
                  TextButton.icon(
                      onPressed: controller.rememberPwd.toggle,
                      icon: Obx(() => Switch(
                          value: controller.rememberPwd.value, onChanged: (val) => controller.rememberPwd.toggle())),
                      label: Text(LocaleKeys.buttons_rememberme.tr, style: const TextStyle(fontSize: 11))),
                  const Spacer(),
                  TextButton(child: 'Forgot Password'.text.sm.make(), onPressed: () => Get.toNamed(Routes.resetPwd))
                ]),
                const SizedBox(height: 10.0),
                //button login
                Obx(() => controller.loading.isTrue
                    ? const CircularProgressIndicator()
                    : MyButton('Log in', onTap: controller.doLoginWithEmail).marginOnly(top: 10)),
                TextButton(
                    child: 'New User ? Sign up here'.text.sm.make(), onPressed: () => Get.toNamed(Routes.signup)),
                const Spacer(),
                'By signing in, you agree to our terms and conditions.'.text.sm.make()
              ].column(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.formKey)
          .box
          .width(300)
          .height(400)
          .make()
          .scrollVertical()
          .centered());
}
