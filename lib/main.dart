import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'text_editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      getPages: Pages.routes,
      initialRoute: "/home",
    );
  }
}
