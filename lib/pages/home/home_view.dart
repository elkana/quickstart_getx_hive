import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/common.dart';
import 'dashboard/dashboard_controller.dart';
import 'dashboard/dashboard_view.dart';
import 'history/history_controller.dart';
import 'history/history_view.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(builder: (controller) {
        return WillPopScope(
            onWillPop: controller.willPopScope,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Project Baru'),
                actions: [IconButton(onPressed: controller.logout, icon: const Icon(Icons.power_settings_new_rounded))],
              ),
              body: IndexedStack(index: controller.tabIndex, children: const [
                DashboardView(),
                PaddingAll(child: HistoryView()),
              ]),
              bottomNavigationBar: BottomAppBar(
                  child: BottomNavigationBar(
                      currentIndex: controller.tabIndex,
                      onTap: controller.changeTabIndex,
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History')
                      ]),
                  shape: const CircularNotchedRectangle(),
                  clipBehavior: Clip.antiAlias,
                  notchMargin: 4.0),
            ));
      });
}
