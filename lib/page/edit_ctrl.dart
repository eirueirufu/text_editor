import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class EditController extends GetxController {
  final String name;
  final QuillController quillCtrl;

  EditController({required this.name, required this.quillCtrl});
}
