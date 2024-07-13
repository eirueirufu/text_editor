import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/page/book_list_ctrl.dart';
import 'package:text_editor/page/edit.dart';
import 'package:intl/intl.dart';

class BookList extends GetView<BookListController> {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文本列表'),
        actions: [
          addBookButton(context),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (BuildContext context, int index) {
            final book = controller.list[index];
            return ListTile(
              title: Text(book.name),
              subtitle: Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(book.updatedAt),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: listTileMoreAction(context, book),
              onTap: () => Get.toNamed(Edit.routeName, arguments: [book.id]),
            );
          },
        ),
      ),
    );
  }

  IconButton listTileMoreAction(BuildContext context, Book book) {
    return IconButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("重命名"),
              onTap: () async {
                Get.back();
                var name = "";
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    scrollable: true,
                    title: const Text("重命名"),
                    content: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "名称",
                      ),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text("取消"),
                      ),
                      FilledButton(
                        onPressed: () {
                          controller.renameBook(book.id, name);
                          Get.back();
                        },
                        child: const Text("确认"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("删除"),
              onTap: () async {
                controller.deleteBook(book.id);
                Get.back();
              },
            ),
          ],
        ),
      ),
      icon: const Icon(Icons.more_vert),
    );
  }

  IconButton addBookButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        var name = "";
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            title: const Text("新增文本"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "名称",
              ),
              onChanged: (value) {
                name = value;
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("取消"),
              ),
              FilledButton(
                onPressed: () {
                  controller.addBook(name);
                  Get.back();
                },
                child: const Text("确认"),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
