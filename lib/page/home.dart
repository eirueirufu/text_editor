import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/home_ctrl.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  final destinations = <NavigationDestination>[
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: "主页",
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings),
      label: "设置",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('text_editor'),
      ),
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
