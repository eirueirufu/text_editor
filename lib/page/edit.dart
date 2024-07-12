import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:text_editor/page/edit_ctrl.dart';

class Edit extends GetView<EditController> {
  const Edit({super.key});

  static const routeName = "/edit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.name),
      ),
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: controller.quillCtrl,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('zh'),
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: controller.quillCtrl,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('zh'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
