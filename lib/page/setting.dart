import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:text_editor/page/setting_ctrl.dart';

class Setting extends GetView<SettingController> {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SupaSocialsAuth(
        socialProviders: const [
          OAuthProvider.github,
        ],
        colored: true,
        onSuccess: (Session response) {
          print(response);
        },
        onError: (error) {
          print(error);
        },
        redirectUrl: "eirueirufu.editor://login-callback",
      ),
    );
  }
}
