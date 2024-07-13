import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpService extends GetxService {
  late SupabaseClient supabase;

  User? user;

  Future<SpService> init() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
    supabase = Supabase.instance.client;

    supabase.auth.onAuthStateChange.listen(
      (data) {
        final event = data.event;
        if (event == AuthChangeEvent.signedIn) {
          user = data.session?.user;
        }
      },
    );
    return this;
  }

  Future<bool> signInWithGithub() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.github,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
