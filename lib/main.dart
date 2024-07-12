import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/page/route.dart';
import 'package:text_editor/service/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDb();
  runApp(const MyApp());
}

Future<void> initDb() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());

  await Get.putAsync(() => DbService().init());
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
