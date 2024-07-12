import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:text_editor/model/book.dart';

class DbService extends GetxService {
  late Box<Book> bookBox;

  Future<DbService> init() async {
    bookBox = await Hive.openBox("book");
    return this;
  }
}
