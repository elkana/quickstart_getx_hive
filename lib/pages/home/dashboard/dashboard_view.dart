import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../controllers/pref_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<DashboardController>(() => DashboardController());
}

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => 'Hello ${PrefController.instance.getLoggedUser()!.userId!}'.text.make();
}
