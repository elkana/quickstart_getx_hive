import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<HistoryController>(() => HistoryController());
}

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => 'Hello History'.text.make();
}
