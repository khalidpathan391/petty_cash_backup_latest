// // ignore_for_file: unused_import, unused_local_variable

// import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_config/flutter_config.dart';
// import 'package:petty_cash/app_routes.dart';

// import 'package:petty_cash/data/sources/my_http_overrides.dart';
// import 'package:petty_cash/fcm/firebase_api.dart';
// import 'package:petty_cash/firebase_options.dart';
// import 'package:petty_cash/initialize_providers.dart';
// import 'package:petty_cash/resources/color/app_colors.dart';
// import 'package:petty_cash/resources/theme/theme_provider.dart';
// import 'package:petty_cash/utils/app_utils.dart';
// import 'package:petty_cash/view/startup_module/splash_screen.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (!kIsWeb) {
//     await FlutterConfig.loadEnvVariables();
//   }

//   await AppUtils.requestPermissionAndGetLocation();

//   await EasyLocalization.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   HttpOverrides.global = MyHttpOverrides();

//   FirebaseApi().initNotifications();

//   runApp(EasyLocalization(
//     supportedLocales: AppUtils.getLangList(),
//     path: 'assets/lang',
//     fallbackLocale: const Locale('en', 'US'),
//     child: const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Global.setLanguage(context);

//     return MultiProvider(
//       providers: AppProviders.allProviders,
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           //setThemeColor(context); // Pass context here
//           return MaterialApp(
//             theme: ThemeData(
//               primaryColor: AppColors.primaryColor,
//               // scaffoldBackgroundColor: AppColors.backgroundColor,
//               // colorScheme: ColorScheme.fromSwatch().copyWith(
//               //   primary: AppColors.primaryColor,
//               //   // secondary: AppColors.secondaryColorNew,
//               // ),
//             ),
//             title: 'appName'.tr(),
//             debugShowCheckedModeBanner: false,
//             initialRoute: SplashScreen.id,
//             // theme: themeProvider.currentTheme,
//             routes: AppRoutes.getRoutes(context),
//             localizationsDelegates: context.localizationDelegates,
//             supportedLocales: EasyLocalization.of(context)!.supportedLocales,
//             locale: EasyLocalization.of(context)!.locale,
//           );
//         },
//       ),
//     );
//   }
// }