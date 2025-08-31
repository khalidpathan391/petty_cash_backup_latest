import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petty_cash/app_routes.dart';
import 'package:petty_cash/resources/theme/theme_provider.dart';
import 'package:petty_cash/view/startup_module/splash_screen.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:petty_cash/view_model/CommonProvider.dart';
import 'package:petty_cash/view_model/HomePage/HomeMainVM.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:petty_cash/view_model/HomePage/ProfileAndSettings/profile_settings_vm.dart';
import 'package:petty_cash/view_model/company/CompanyVM.dart';
import 'package:petty_cash/view_model/purchase_order/purchase_order_vm.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProviders {
  static void setThemeColor(BuildContext context) async {
    Color? savedColor = await _loadThemeColor();
    Provider.of<ThemeProvider>(context, listen: false)
        .toggleTheme(savedColor ?? Colors.blueGrey);
  }

  static Future<Color?> _loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('theme_color');
    return colorValue != null ? Color(colorValue) : null;
  }

  static MultiProvider getMultiProvider(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthVM()),
        ChangeNotifierProvider(create: (_) => CommonVM()),
        ChangeNotifierProvider(create: (_) => HomeVM()),
        ChangeNotifierProvider(create: (_) => HomeMainVM()),
        ChangeNotifierProvider(create: (_) => ProfileSettingsVM()),
        ChangeNotifierProvider(create: (_) => CompanyVM()),
        ChangeNotifierProvider(create: (_) => CompanyVM()),
        ChangeNotifierProvider(create: (_) => PoApplicationVm()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          //setThemeColor(context); // Pass context here
          return MaterialApp(
            title: 'appName'.tr(),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.id,
            theme: themeProvider.currentTheme,
            routes: AppRoutes.getRoutes(context),
            localizationsDelegates: [
              EasyLocalization.of(context)!.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: EasyLocalization.of(context)!.supportedLocales,
            locale: EasyLocalization.of(context)!.locale,
          );
        },
      ),
    );
  }
}
