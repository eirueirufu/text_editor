import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/book_list_ctrl.dart';
import 'package:text_editor/page/edit.dart';

class BookList extends GetView<BookListController> {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("标题$index"),
        subtitle: Text(
          DateTime.now().toString(),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
        onTap: () => Get.toNamed(Edit.routeName),
      );
    });
  }
}
