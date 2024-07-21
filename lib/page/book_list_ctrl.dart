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
      name: name,
      updatedAt: now,
      ops: [],
    );
    dbService.bookBox.put(book.name, book);
    fetchList();
  }

  void deleteBook(String name) {
    dbService.bookBox.delete(name);
    fetchList();
  }

  void renameBook(String name, newName) {
    final book = dbService.bookBox.get(name);
    if (book == null) {
      return;
    }
    dbService.bookBox.delete(book.name);
    book.name = newName;
    book.updatedAt = DateTime.now();
    dbService.bookBox.put(book.name, book);
    fetchList();
  }

  bool checkExisted(String name) {
    final book = dbService.bookBox.get(name);
    return book != null;
  }
}
