import 'package:get/get.dart';
import 'package:text_editor/page/book_list_ctrl.dart';
import 'package:text_editor/page/edit.dart';
import 'package:text_editor/page/edit_ctrl.dart';
import 'package:text_editor/page/home.dart';
import 'package:text_editor/page/home_ctrl.dart';
import 'package:text_editor/page/setting_ctrl.dart';

class Pages {
  static final routes = [
    GetPage(
      name: Home.routeName,
      page: () => Home(),
      bindings: [
        BindingsBuilder.put(() => HomeController()),
        BindingsBuilder.put(() => BookListController()),
        BindingsBuilder.put(() => SettingController()),
      ],
    ),
    GetPage(
      name: Edit.routeName,
      page: () => const Edit(),
      bindings: [
        BindingsBuilder.put(
          () => EditController(
            name: Get.arguments[0],
          ),
        ),
      ],
    ),
  ];
}
