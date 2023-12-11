import 'dart:convert';

import 'package:appointmentapp/api-sql/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUser {

  static Future<void> saveUser(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
    print('User saved: $userJsonData');
  }


  //get-read User-info
  static Future<User?> readUser() async
  {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }
}