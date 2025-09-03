import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:petty_cash/AppProviders.dart';
import 'package:petty_cash/data/sources/my_http_overrides.dart';
import 'package:petty_cash/fcm/firebase_api.dart';
import 'package:petty_cash/firebase_options.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';

import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseApi().initNotifications();

  await EasyLocalization.ensureInitialized();
  AppUtils.getDeviceDetails();

  HttpOverrides.global = MyHttpOverrides();

  runApp(EasyLocalization(
    supportedLocales: AppUtils.getLangList(),
    path: 'assets/lang',
    fallbackLocale: const Locale('en', 'US'),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.initialize(context, 414, 736);
    Global.setLanguage(context);
    AppUtils.changeStatusBarColor(context.resources.color.themeColor);
    return AppProviders.getMultiProvider(context);
  }
}
