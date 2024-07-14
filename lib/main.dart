import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/page/route.dart';
import 'package:text_editor/service/db.dart';
import 'package:text_editor/service/sp.dart';
import 'package:text_editor/util/deep_link.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDeepLink();
  await dotenv.load(fileName: ".env");
  await initDb();
  await initSp();
  runApp(const MyApp());
}

Future<void> initSp() async {
  await Get.putAsync(() => SpService().init());
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
