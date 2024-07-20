import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/service/crdt.dart';
import 'package:text_editor/service/db.dart';
import 'package:text_editor/service/sp.dart';
import 'package:y_crdt/wit_world.dart';

class EditController extends GetxController {
  final dbService = Get.find<DbService>();
  final crdtService = Get.find<CrdtService>();
  final spService = Get.find<SpService>();

  final int id;
  late Book book;
  late QuillController quillCtrl;
  late Document doc;

  late YDoc crdtDoc;
  late YText crdtText;

  late RealtimeChannel chan;

  EditController({required this.id});

  @override
  void onInit() async {
    super.onInit();
    chan = spService.supabase.channel(
      "test",
      opts: const RealtimeChannelConfig(
        self: true,
      ),
    );

    fetchText();

    doc = Document();

    crdtDoc = crdtService.world.yDocMethods.yDocNew();
    final docFinalizer = Finalizer<int>(
      (p0) =>
          crdtService.world.yDocMethods.yDocDispose(ref: YDoc.fromJson([p0])),
    );
    docFinalizer.attach(crdtDoc, crdtDoc.ref);
    crdtText =
        crdtService.world.yDocMethods.yDocText(ref: crdtDoc, name: "book_1");

    if (book.ops.isNotEmpty) {
      final delta = Delta.fromJson(book.ops);
      doc = Document.fromDelta(delta);
    }

    crdtService.operationsApplyToText(crdtText, doc.toDelta().operations);

    quillCtrl = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillCtrl.changes.listen(listenFn);

    chan
        .onBroadcast(
            event: "book_1",
            callback: (payload) {
              final origin = crdtService.world.yDocMethods
                  .encodeStateAsUpdate(ref: crdtDoc)
                  .ok!;
              final state = (payload)["state"];
              if (state == null) {
                return;
              }
              final update = Uint8List.fromList(
                  (state as List<dynamic>).map((e) => e as int).toList());

              crdtService.world.yDocMethods
                  .applyUpdate(ref: crdtDoc, diff: update, origin: origin);

              final ops = crdtService.crdtTextToOperations(crdtText);

              quillCtrl.setContents(Delta.fromOperations(ops));
              quillCtrl.changes.listen(listenFn);
            })
        .subscribe();
  }

  void listenFn(DocChange event) {
    if (event.source == ChangeSource.remote) {
      return;
    }
    final ops = event.change.operations;
    crdtService.operationsApplyToText(crdtText, ops);

    final state =
        crdtService.world.yDocMethods.encodeStateAsUpdate(ref: crdtDoc).ok;

    chan.sendBroadcastMessage(
        event: "book_1", payload: Map()..["state"] = state);
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
