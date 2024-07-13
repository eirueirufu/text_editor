import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/service/db.dart';

class EditController extends GetxController {
  final dbService = Get.find<DbService>();

  final int id;
  late Book book;
  late QuillController quillCtrl;
  late Document doc;

  EditController({required this.id});

  @override
  void onInit() {
    super.onInit();
    fetchText();

    doc = Document();
    if (book.ops.isNotEmpty) {
      final delta = Delta.fromJson(book.ops);
      doc = Document.fromDelta(delta);
    }

    // doc.changes.listen((change) {
    //   final ops = change.change.toJson();
    //   book.ops.addAll(ops);
    // });
    quillCtrl = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void onClose() {
    super.onClose();
    final ops = doc.toDelta().toJson();
    book.ops = ops;
    book.updatedAt = DateTime.now();
    dbService.bookBox.put(book.id, book);
  }

  void fetchText() {
    book = dbService.bookBox.get(id)!;
  }
}
