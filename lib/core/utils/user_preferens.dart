import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set useruid(String? data) => _prefs.setString('useruid', data ?? '');
  String? get useruid => _prefs.getString('useruid');
  set useremail(String? data) => _prefs.setString('useremail', data ?? '');
  String? get useremail => _prefs.getString('useremail');
  set username(String? data) => _prefs.setString('username', data ?? '');
  String? get username => _prefs.getString('username');
  set userid(String? data) => _prefs.setString('userid', data ?? '');
  String? get userid => _prefs.getString('userid');
  set userdateOfBirth(String? data) =>
      _prefs.setString('userdateOfBirth', data ?? '');
  String? get userdateOfBirth => _prefs.getString('userdateOfBirth');

  void saveUserData(UserModel? user) {
    useruid = user?.uid;
    useremail = user?.email;
    username = user?.name;
    userid = user?.id;
    userdateOfBirth = user?.dateOfBirth.toString();
  }

  void deleteUserData() {
    _prefs.remove('useruid');
    _prefs.remove('useremail');
    _prefs.remove('username');
    _prefs.remove('userid');
    _prefs.remove('userdateOfBirth');
  }
}
