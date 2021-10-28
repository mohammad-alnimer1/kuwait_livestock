import 'package:shared_preferences/shared_preferences.dart';

savepreflogin({
  String name,
  String login,
  String id,
  String phone,
}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("user_id",id);
  pref.setString("name", name);
  pref.setString("login", login);
  pref.setString("phone", phone);
  print (pref.getString('user_id'));
  print(pref.getString("name"));
  print(pref.getString("login"));
  print(pref.getString("phone"));
  print(pref.getString("state"));

}


class AppSharedPrefs {
  static  List<String> idList=[];

  static String spIsLoginKey = 'isLogin';
  static String spLangKey = 'Lang';
  static String spEmailKey = 'login';
  static String spPhoneKey = 'phone';
  static String spAddressKey = 'Address';
  static String spIdKey = 'userId';
  static String spNameKey = 'name';
  static String spImgKey = 'img';
  static String doneLangMain = 'mainLang';
  static String langType = 'lng';
  static String isEmpKey = 'isEmp';
  static String onBoard = 'onBoard';
  static String notificationOn = 'notificationOn';


  static String spListID = 'Listid';
  static Future<bool> saveListIDInSP(List<String>  ListId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(spListID, ListId);
  }

  static Future<bool> saveLangInSP(bool lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(spLangKey, lang);
  }

  static Future<bool> saveMainLangInSP(bool langMain) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(doneLangMain, langMain);
  }

  static Future<bool> saveIsLoginSP(bool isLogin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(spIsLoginKey, isLogin);
  }

  static Future<bool> saveEmailSP(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spEmailKey, email);
  }

  static Future<bool> savePhoneSP(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spPhoneKey, email);
  }

  static Future<bool> saveAddressSP(String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spAddressKey, address);
  }

  static Future<bool> saveIdSP(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spIdKey, id);
  }

  static Future<bool> saveNameSP(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spNameKey, name);
  }

  static Future<bool> saveImgSP(String img) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(spImgKey, img);
  }

  static Future<bool> saveLangType(String lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(langType, lang);
  }

  static Future<bool> saveEmpSP(bool isInst) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(isEmpKey, isInst);
  }

  static Future<bool> saveonBoard(bool onboard) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(onBoard, onboard);
  }

  static Future<bool> saveNotificationOn(bool notiOn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(notificationOn, notiOn);
  }
}
