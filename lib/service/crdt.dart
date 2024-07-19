import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:y_crdt/wit_world.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

class CrdtService extends GetxService {
  late YCrdtWorld world;

  Future<CrdtService> init() async {
    world = await createYCrdt(
      wasiConfig: const WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
      imports: YCrdtWorldImports(
        eventCallback: ({required event, required functionId}) {},
        eventDeepCallback: ({required event, required functionId}) {},
        undoEventCallback: ({required event, required functionId}) {},
      ),
    );
    return this;
  }

  operationsApplyToText(YText crdtText, List<Operation> operations) {
    var index = 0;
    for (final op in operations) {
      JsonValueItem? attr;
      if (op.attributes != null) {
        List<(String, JsonValue)> mp = [];
        op.attributes!.forEach((key, value) {
          if (value is bool) {
            mp.add((key, JsonValue.boolean(value)));
          } else if (value is double) {
            mp.add((key, JsonValue.number(value)));
          } else if (value is BigInt) {
            mp.add((key, JsonValue.bigInt(value)));
          } else if (value is String) {
            mp.add((key, JsonValue.str(value)));
          } else if (value is int) {
            mp.add((key, JsonValue.number(value.toDouble())));
          } else if (value == null) {
            mp.add((key, JsonValue.null_()));
          } else {
            throw "未知类型 ${op.runtimeType} ${value.runtimeType} ${op.toJson()}";
          }
        });
        List<List<(String, JsonValue)>> mapReferences = [mp];

        attr = JsonValueItem(
          item: const JsonValue.map(JsonMapRef(index_: 0)),
          arrayReferences: [],
          mapReferences: mapReferences,
        );
      }
      switch (op.key) {
        case Operation.retainKey:
          if (attr != null) {
            world.yDocMethods.yTextFormat(
                ref: crdtText,
                index_: index,
                length: op.value as int,
                attributes: attr);
          }
          index = op.value as int;
          break;
        case Operation.insertKey:
          world.yDocMethods.yTextInsert(
            ref: crdtText,
            index_: index,
            chunk: op.data as String,
            attributes: attr,
          );

          break;
        case Operation.deleteKey:
          world.yDocMethods.yTextDelete(
              ref: crdtText, index_: index, length: op.value as int);
          break;
      }
    }
  }

  List<Operation> crdtTextToOperations(YText crdtText) {
    final delta = world.yDocMethods.yTextToDelta(ref: crdtText);
    final List<Operation> ops = delta.map((e) {
      switch (e.runtimeType) {
        case YTextDeltaRetain:
          final v = e as YTextDeltaRetain;
          final entries = v.attributes?.mapReferences[0].map((e) {
            final val = e.$2;
            if (val is JsonValueBoolean) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueBigInt) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueNumber) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueStr) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueNull) {
              return MapEntry(e.$1, null);
            }
            return MapEntry(e.$1, e.$2);
          });
          Map<String, dynamic>? attr;
          if (entries != null) {
            attr = Map.fromEntries(entries);
          }
          return Operation.retain(v.retain, attr);
        case YTextDeltaInsert:
          final v = e as YTextDeltaInsert;
          final entries = v.attributes?.mapReferences[0].map((e) {
            final val = e.$2;
            if (val is JsonValueBoolean) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueBigInt) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueNumber) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueStr) {
              return MapEntry(e.$1, val.value);
            }
            if (val is JsonValueUndefined) {
              return MapEntry(e.$1, null);
            }
            return MapEntry(e.$1, e.$2);
          });
          Map<String, dynamic>? attr;
          if (entries != null) {
            attr = Map.fromEntries(entries);
          }
          return Operation.insert(v.insert, attr);
        case YTextDeltaDelete:
          final v = e as YTextDeltaDelete;
          return Operation.delete(v.delete);
        default:
          return Operation.delete(0);
      }
    }).toList();

    return ops;
  }
}
