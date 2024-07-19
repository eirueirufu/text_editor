import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/page/route.dart';
import 'package:text_editor/service/crdt.dart';
import 'package:text_editor/service/db.dart';
import 'package:text_editor/service/sp.dart';
import 'package:text_editor/util/deep_link.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await initDeepLink();
  await initService();

  runApp(const MyApp());
}

Future<void> initService() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());

  await Get.putAsync(() => DbService().init());
  await Get.putAsync(() => SpService().init());
  await Get.putAsync(() => CrdtService().init());
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
