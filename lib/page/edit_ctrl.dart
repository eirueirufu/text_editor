import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:quiver/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_editor/model/book.dart';
import 'package:text_editor/service/crdt.dart';
import 'package:text_editor/service/db.dart';
import 'package:text_editor/service/sp.dart';
import 'package:y_crdt/wit_world.dart';
import 'package:easy_debounce/easy_debounce.dart';

class EditController extends GetxController {
  final dbService = Get.find<DbService>();
  final crdtService = Get.find<CrdtService>();
  final spService = Get.find<SpService>();

  final String name;
  final saving = false.obs;
  late Book book;
  late QuillController quillCtrl;
  late Document doc;

  late YDoc crdtDoc;
  late YText crdtText;

  RealtimeChannel? chan;
  int nodeKey = DateTime.now().millisecondsSinceEpoch;

  EditController({required this.name});

  @override
  void onClose() {
    super.onClose();
    EasyDebounce.cancel("save");
    crdtService.world.yDocMethods.yDocDestroy(ref: crdtDoc);
  }

  @override
  void onInit() {
    super.onInit();
    final user = spService.supabase.auth.currentUser;
    if (user != null) {
      chan = spService.supabase.channel(
        user.id,
        opts: const RealtimeChannelConfig(self: true, private: true),
      );
    }

    fetchText();

    doc = Document();

    crdtDoc = crdtService.world.yDocMethods.yDocNew(
      options: const YDocOptions(skipGc: true),
    );
    crdtText =
        crdtService.world.yDocMethods.yDocText(ref: crdtDoc, name: "quill");

    if (book.state.isNotEmpty) {
      final origin =
          crdtService.world.yDocMethods.encodeStateAsUpdate(ref: crdtDoc).ok!;
      final update = Uint8List.fromList(book.state);
      crdtService.world.yDocMethods
          .applyUpdate(ref: crdtDoc, diff: update, origin: origin);

      final ops = crdtService.crdtTextToOperations(crdtText);

      final delta = Delta.fromOperations(ops);
      doc = Document.fromDelta(delta);
    } else {
      crdtService.operationsApplyToText(
        crdtDoc,
        crdtText,
        doc.toDelta().operations,
      );
    }

    quillCtrl = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillCtrl.changes.listen(listenFn);

    chan
        ?.onBroadcast(
            event: name,
            callback: (payload) {
              final origin = crdtService.world.yDocMethods
                  .encodeStateAsUpdate(ref: crdtDoc)
                  .ok!;
              final remoteNode = payload["node"];
              if (remoteNode == null) {
                return;
              }
              if (nodeKey == remoteNode as int) {
                return;
              }
              final state = (payload)["state"];
              if (state == null) {
                return;
              }
              final update = Uint8List.fromList(
                  (state as List<dynamic>).map((e) => e as int).toList());

              if (listsEqual(origin, update)) {
                return;
              }
              crdtService.world.yDocMethods
                  .applyUpdate(ref: crdtDoc, diff: update, origin: origin);

              final ops = crdtService.crdtTextToOperations(crdtText);

              quillCtrl.setContents(
                Delta.fromOperations(ops),
              );
              listenFn(null);
              quillCtrl.changes.listen(listenFn);
            })
        .subscribe();
  }

  void listenFn(DocChange? event) {
    if (event != null) {
      final ops = event.change.operations;
      crdtService.operationsApplyToText(
        crdtDoc,
        crdtText,
        ops,
      );
    }

    saving.value = true;
    EasyDebounce.debounce(
      'save',
      const Duration(milliseconds: 1000),
      () async {
        final state =
            crdtService.world.yDocMethods.encodeStateAsUpdate(ref: crdtDoc).ok!;
        book.state = state;
        book.updatedAt = DateTime.now();
        await dbService.bookBox.put(book.name, book);

        final payload = <String, dynamic>{};
        payload["state"] = state;
        payload["node"] = nodeKey;
        chan?.sendBroadcastMessage(event: name, payload: payload);

        saving.value = false;
      },
    );
  }

  void fetchText() {
    book = dbService.bookBox.get(name)!;
  }
}
