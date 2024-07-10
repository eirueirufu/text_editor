import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/book_list_ctrl.dart';

class BookList extends GetView<BookListController> {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("$index"),
      );
    });
  }
}
