import 'package:appointmentapp/api-sql/user.dart';
import 'package:appointmentapp/api-sql/userPref.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController {
  Rx<User> _currentUser = User(0, '', '', '', '', '', '','').obs;

  User get user => _currentUser.value;

  Future<void> getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUser.readUser();
    if (getUserInfoFromLocalStorage != null) {
      _currentUser.value = getUserInfoFromLocalStorage;
    }
  }
}
