import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/book_list.dart';
import 'package:text_editor/page/setting.dart';

class HomeController extends GetxController {
  final index = 0.obs;

  RxList<Widget> pages = RxList<Widget>(
    [
      const BookList(),
      Setting(),
    ],
  );

  void setIndex(int i) {
    index.value = i;
  }
}
