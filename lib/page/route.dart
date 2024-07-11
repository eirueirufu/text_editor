import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/book_list_ctrl.dart';
import 'package:text_editor/page/edit.dart';
import 'package:text_editor/page/edit_ctrl.dart';
import 'package:text_editor/page/home.dart';
import 'package:text_editor/page/home_ctrl.dart';

class Pages {
  static final routes = [
    GetPage(
      name: Home.routeName,
      page: () => Home(),
      bindings: [
        BindingsBuilder.put(() => HomeController()),
        BindingsBuilder.put(() => BookListController()),
      ],
    ),
    GetPage(
      name: Edit.routeName,
      page: () => Edit(),
      bindings: [
        BindingsBuilder.put(
          () => EditController(
            quillCtrl: QuillController.basic(),
          ),
        ),
      ],
    ),
  ];
}
