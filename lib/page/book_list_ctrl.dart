import 'package:get/get.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/service/db.dart';

class BookListController extends GetxController {
  final dbService = Get.find<DbService>();

  var list = <Book>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchList();
  }

  void fetchList() {
    list.value = dbService.bookBox.values.toList()
      ..sort((a, b) =>
          b.updatedAt.microsecondsSinceEpoch -
          a.updatedAt.microsecondsSinceEpoch);
  }

  void addBook(String name) {
    final now = DateTime.now();
    final book = Book(
      id: now.millisecondsSinceEpoch ~/ 1000,
      name: name,
      updatedAt: now,
    );
    dbService.bookBox.put(book.id, book);
    fetchList();
  }

  void deleteBook(int id) {
    dbService.bookBox.delete(id);
    fetchList();
  }

  void renameBook(int id, String name) {
    final book = dbService.bookBox.get(id);
    if (book == null) {
      return;
    }
    book.name = name;
    dbService.bookBox.put(book.id, book);
    fetchList();
  }
}
