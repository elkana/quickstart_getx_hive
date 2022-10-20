import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/screen_util.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  var avatarUrl = 'https://i.pravatar.cc/300'.obs;
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  Future<void> logout() async {
    await AuthController.instance.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<bool> willPopScope() async {
    var ret = await ScreenUtil.exitApp();
    if (ret) {
      await logout();
      return true;
    }
    return false;
  }
}
