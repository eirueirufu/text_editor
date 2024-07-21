import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_editor/service/sp.dart';

class SettingController extends GetxController {
  final spService = Get.find<SpService>();

  var user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();

    user.value = spService.supabase.auth.currentUser;
  }

  void setUser(User? user) {
    this.user.value = user;
  }

  Future<void> signOut() async {
    await spService.signOut();
    setUser(null);
  }
}
