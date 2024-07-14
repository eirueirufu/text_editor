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
      body: Column(
        children: [
          Obx(
            () => controller.user.value == null
                ? ListTile(
                    leading: const Icon(
                      Icons.question_mark,
                    ),
                    title: Text(
                      "未登录",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SupaSocialsAuth(
                              socialProviders: const [
                                OAuthProvider.github,
                              ],
                              colored: true,
                              onSuccess: (Session response) {
                                controller.setUser(response.user);
                                Get.back();
                              },
                              onError: (error) {
                                Get.snackbar("登录失败", error.toString());
                                Get.back();
                              },
                              redirectUrl:
                                  "eirueirufutexteditor://login-callback/",
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListTile(
                    leading:
                        controller.user.value!.userMetadata?["avatar_url"] ==
                                null
                            ? const Icon(
                                Icons.account_circle,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(controller
                                    .user.value!.userMetadata?["avatar_url"]),
                              ),
                    title: Text(
                      controller.user.value!.userMetadata?["user_name"] ?? "未知",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.output),
                              title: const Text("退出登录"),
                              onTap: () async {
                                await controller.signOut();
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
