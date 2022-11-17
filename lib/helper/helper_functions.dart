import 'package:chat_app_groupie/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //save data to shared preferences
  static Future<bool> saveUserLoggedInStatus({
    required bool isUserLoggedIn,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserFullNameSharedRef({
    required String fullName,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userNameKey, fullName);
  }

  static Future<bool> saveUserEmailSharedRef({
    required String email,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmailKey, email);
  }

  // getting data from shared preferences
  static Future<bool?> getUserLoggedinStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<UserModel> getUser() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    UserModel userModel = UserModel();
    userModel.email = sf.getString(userEmailKey)!;
    userModel.fullName = sf.getString(userNameKey)!;
    return userModel;
  }
}

String getIdFromString(String res) {
  return res.substring(0, res.indexOf("_"));
}

String getNameFromString(String res) {
  return res.substring(res.indexOf("_") + 1);
}
