import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pref_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<DashboardController>(() => DashboardController());
}

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Text('Hello ${PrefController.instance.getLoggedUser()!.userId!}');
}
