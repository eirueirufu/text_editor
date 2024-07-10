import 'package:get/get.dart';
import 'package:text_editor/page/book_list_ctrl.dart';
import 'package:text_editor/page/home.dart';
import 'package:text_editor/page/home_ctrl.dart';

class Pages {
  static final routes = [
    GetPage(
      name: "/home",
      page: () => Home(),
      bindings: [
        BindingsBuilder.put(() => HomeController()),
        BindingsBuilder.put(() => BookListController()),
      ],
    ),
  ];
}
