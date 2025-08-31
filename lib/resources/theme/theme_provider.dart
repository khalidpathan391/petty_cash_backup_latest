// ignore_for_file: unnecessary_import, unused_local_variable, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(Color color) {
    Color forSecondary = color.withOpacity(0.3);
    _currentTheme = ThemeData(
      primarySwatch: MaterialColor(color.value, _primary),
      primaryColor: color,
      primaryColorDark: Colors.grey,
      hintColor: color,
      iconTheme: IconThemeData(color: color),
      textTheme: _currentTheme.textTheme.apply(
        fontFamily: 'Regular', // Change the font family
      ),
      primaryTextTheme: const TextTheme(
        bodyText1:
            TextStyle(fontSize: 20), // Changed from bodyLarge to bodyText1
        bodyText2:
            TextStyle(fontSize: 16), // Changed from bodyMedium to bodyText2
        subtitle1:
            TextStyle(fontSize: 14), // Changed from bodySmall to subtitle1
        headline6:
            TextStyle(fontSize: 20), // Changed from labelLarge to headline6
        headline5:
            TextStyle(fontSize: 16), // Changed from labelMedium to headline5
        headline4:
            TextStyle(fontSize: 12), // Changed from labelSmall to headline4
      ).apply(
        fontFamily: 'Regular', // Change the font family
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: color, // Background color
          //primary: Colors.white, // Text color
          textStyle: const TextStyle(fontFamily: 'Regular'), // Text style
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: color,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: 'Bold'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Regular'),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
    // Change status bar color
    AppUtils.changeStatusBarColor(color);
    _saveThemeColor(color);
    notifyListeners();
  }

  // Method to save selected color in SharedPreferences
  Future<void> _saveThemeColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_color', color.value);
  }
}

Map<int, Color> _primary = {
  50: const Color.fromRGBO(22, 134, 206, 0.1),
  100: const Color.fromRGBO(22, 134, 206, 0.2),
  200: const Color.fromRGBO(22, 134, 206, 0.3),
  300: const Color.fromRGBO(22, 134, 206, 0.4),
  400: const Color.fromRGBO(22, 134, 206, 0.5),
  500: const Color.fromRGBO(22, 134, 206, 0.6),
  600: const Color.fromRGBO(22, 134, 206, 0.7),
  700: const Color.fromRGBO(22, 134, 206, 0.8),
  800: const Color.fromRGBO(22, 134, 206, 0.9),
  900: const Color.fromRGBO(22, 134, 206, 1.0),
};

final lightTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF000000, _primary),
  hintColor: Colors.blueAccent,
);
