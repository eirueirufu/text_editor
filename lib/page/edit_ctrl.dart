import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/service/crdt.dart';
import 'package:text_editor/service/db.dart';
import 'package:y_crdt/wit_world.dart';

class EditController extends GetxController {
  final dbService = Get.find<DbService>();
  final crdtService = Get.find<CrdtService>();

  final int id;
  late Book book;
  late QuillController quillCtrl;
  late Document doc;

  late YDoc crdtDoc;
  late YText crdtText;

  EditController({required this.id});

  @override
  void onInit() async {
    super.onInit();
    fetchText();

    doc = Document();

    crdtDoc = crdtService.world.yDocMethods.yDocNew();
    final docFinalizer = Finalizer<int>(
      (p0) =>
          crdtService.world.yDocMethods.yDocDispose(ref: YDoc.fromJson([p0])),
    );
    docFinalizer.attach(crdtDoc, crdtDoc.ref);
    crdtText = crdtService.world.yDocMethods
        .yDocText(ref: crdtDoc, name: id.toString());

    if (book.ops.isNotEmpty) {
      final delta = Delta.fromJson(book.ops);
      doc = Document.fromDelta(delta);
    }

    crdtService.operationsApplyToText(crdtText, doc.toDelta().operations);

    quillCtrl = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillCtrl.changes.listen((event) {
      if (event.source == ChangeSource.remote) {
        return;
      }
      final ops = event.change.operations;
      crdtService.operationsApplyToText(crdtText, ops);

      print(crdtService.crdtTextToOperations(crdtText));
    });
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
