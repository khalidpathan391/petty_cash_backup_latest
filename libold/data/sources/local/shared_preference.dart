import 'dart:convert';

import 'package:petty_cash/data/models/Authentication/AuthenticationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPreferences {
  static SharedPreferences? sharedPreferences;

  static void saveDataBoolVal(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    prefs.commit();
  }

  static Future<bool?> getBoolData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? token = false;
    if (prefs.containsKey(key)) {
      token = prefs.getBool(key);
    }
    return token;
  }

  static void saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    prefs.commit();
  }

  static void removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<String?> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = "";
    if (prefs.containsKey(key)) {
      token = prefs.getString(key);
    }
    return token;
  }

  static Future<void> saveEmpData(EmpData empData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert User object to a JSON string
    String userJson = jsonEncode(empData.toJson());
    // Save the JSON string to SharedPreferences
    await prefs.setString('empData', userJson);
  }

  static Future<EmpData?> loadEmpData() async {
    EmpData? empData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('empData');
    if (userData != null) {
      empData = EmpData.fromJson(jsonDecode(userData));
    }
    return empData;
  }
}
