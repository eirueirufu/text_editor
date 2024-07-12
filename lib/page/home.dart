import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/home_ctrl.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  static const routeName = "/home";

  final destinations = <NavigationDestination>[
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: "主页",
      selectedIcon: Icon(Icons.home),
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      label: "设置",
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.index.value,
            children: controller.pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          destinations: destinations,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: controller.index.value,
          onDestinationSelected: controller.setIndex,
        ),
      ),
    );
  }
}
