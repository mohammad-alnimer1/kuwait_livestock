import 'package:shared_preferences/shared_preferences.dart';

import 'AppSharedPrefs.dart';



class AppConstants {

  bool isLogin = false;

  getLoggedInState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

      isLogin = preferences.getBool('isLogin');

    return isLogin;
  }

  Future logOutApp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    getLoggedInState();
    // AppSharedPrefs.saveIsLoginSP(false);
  }
}
