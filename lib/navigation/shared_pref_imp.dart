import 'package:tree_navigation/navigation/shared_preferences_int.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImplementation implements SharedPreferencesInterface {
  SharedPreferencesImplementation(this.sp);

  final SharedPreferences sp;

  @override
  Future<List<String>?> getList({required String key}) async {
    List<String>? fetchedList = sp.getStringList(key);
    return fetchedList;
  }

  @override
  Future<String?> getVariable({required String key}) async {
    String? fetchedVariable = sp.getString(key);
    return fetchedVariable;
  }

  @override
  Future<void> setList({required String key, required List<String> value}) async {
    sp.setStringList(key, value);
  }

  @override
  Future<void> setVariable({required String key, required String value}) async {
    sp.setString(key, value);
  }
}
