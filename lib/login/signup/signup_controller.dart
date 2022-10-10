import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/screen_util.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late TextEditingController ctrlFullname, ctrlUserId, ctrlNewPwd, ctrlConfirmPwd;
  var obscurePwdNew = true.obs;
  var obscurePwdConfirm = true.obs;
  var rememberPwd = false.obs;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ctrlUserId = TextEditingController();
    ctrlNewPwd = TextEditingController();
    ctrlConfirmPwd = TextEditingController();
    ctrlFullname = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    ctrlFullname.dispose();
    ctrlConfirmPwd.dispose();
    ctrlNewPwd.dispose();
    ctrlUserId.dispose();
  }

  String? validateFullname(String value) {
    if (GetUtils.isLengthLessThan(value, 4)) return 'Length must be of 4 chars';
    return null;
  }

  String? validateUserId(String value) {
    if (GetUtils.isLengthLessThan(value, 4)) return 'Length must be of 4 chars';
    if (!GetUtils.isEmail(value)) return 'Invalid email';
    return null;
  }

  String? validatePassword(String value) {
    if (GetUtils.isLengthLessThan(value, 6)) {
      return 'Password must be of 6 chars';
    }
    return null;
  }

  Future<void> doSignUp() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    if (ctrlNewPwd.text != ctrlConfirmPwd.text) {
      ScreenUtil.showError('Konfirmasi Password tidak sama.');
      return;
    }

    loading(true);

    try {
      await 3.delay();
      // UserCredential user = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: ctrlUserId.text.trim(), password: ctrlNewPwd.text);
      // if (user.user == null) return;
    } catch (e, s) {
      ScreenUtil.showError(e, stacktrace: s);
    } finally {
      loading(false);
    }
  }
}
