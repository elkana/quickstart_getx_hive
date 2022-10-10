import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/locales.dart';
import '../routes/app_routes.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<LoginController>(() => LoginController());
}

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: SizedBox(
                  width: 300,
                  height: 400,
                  child: Form(
                      child: Column(children: [
                        const Text('Hello !', style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
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
                                labelText: 'Email',
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
                                  value: controller.rememberPwd.value,
                                  onChanged: (val) => controller.rememberPwd.toggle())),
                              label: Text(LocaleKeys.buttons_rememberme.tr, style: const TextStyle(fontSize: 11))),
                          const Spacer(),
                          TextButton(
                              onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                              child: const Text('Forgot Password', style: TextStyle(fontSize: 11)))
                        ]),
                        const SizedBox(height: 10.0),
                        //button login
                        Obx(() => controller.loading.isTrue
                            ? const CircularProgressIndicator()
                            : Padding(
                                child: Material(
                                    child: MaterialButton(
                                        child: const Text('Log in', style: TextStyle(color: Colors.white)),
                                        onPressed: controller.doLoginWithEmail,
                                        minWidth: double.infinity,
                                        height: 42.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                    elevation: 5.0,
                                    color: Colors.purple),
                                padding: const EdgeInsets.symmetric(vertical: 16.0))),
                        const Spacer(),
                        TextButton(
                            onPressed: () => Get.toNamed(Routes.SIGNUP),
                            child: const Text('New User ? Sign up here', style: TextStyle(fontSize: 11)))
                      ]),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: controller.formKey)))));
}
