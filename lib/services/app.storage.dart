import 'package:shared_preferences/shared_preferences.dart';
import '../models/app.settings.dart';

class Appstorage {
  static const String _loggeedIntKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passWordKey = 'passWord';
  static const String _darkModelKey = 'darkMode';
  static const String _confirmDeleteKey = 'confirmDelete';

  static const String defaultUserName = 'aluno';
  static const String defaultPassword = '2516';

   Future<void> ensureDefaulUser() async {
    final prefs = await SharedPreferences.getInstance();

    if(!prefs.containsKey(_usernameKey)){
      await prefs.setString(_usernameKey, defaultUserName);
    }

     if(!prefs.containsKey(_passWordKey)){
      await prefs.setString(_passWordKey, defaultPassword);

    }
   }

   Future<bool> loadIsLogged() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggeedIntKey) ?? false;
   }

   Future<bool> setLogged(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_loggeedIntKey, value);
   }

   Future<bool> validateLogin(String username, String password) async{
     await ensureDefaulUser();
     final prefs = await SharedPreferences.getInstance();

     final savedUsername = prefs.getString(_usernameKey) ?? defaultUserName;
     final savedPassword = prefs.getString(_passWordKey) ?? defaultPassword;

     return username == savedUsername && password == savedPassword;
   }
    Future<String> loadPassword() async {
      await ensureDefaulUser();
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_passWordKey) ?? defaultPassword;
    }

    Future<void> savedPassword(String passWord) async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_passWordKey, passWord);
    }

    Future<AppSettings> loadSettings() async{
      final prefs= await SharedPreferences.getInstance();

      return AppSettings(
      darkMode: prefs.getBool(_darkModelKey) ?? false,
      confirmDelete: prefs.getBool(_confirmDeleteKey) ?? true,
      );
    }

    Future<void> saveDarkMode(bool, value) async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModelKey, value);
    }

    Future<void> saveConfirmDelete(bool, value) async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_confirmDeleteKey, value);
    }
}





