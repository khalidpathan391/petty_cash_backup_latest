// // ignore_for_file: library_private_types_in_public_api, unused_import

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:petty_cash/view/auth_module/auth_screens/login_screen.dart';

// import 'package:petty_cash/view/wrapper_widget/base_class.dart';

// class SplashScreen extends StatefulWidget {
//   static const String id = "splash_screen";

//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     });
//   }

//   // void _goToNextPage() async {
//   //   _controller.dispose();

//   //   void navigateToPage(String routeName, {Object? arguments}) {
//   //     Navigator.pushNamedAndRemoveUntil(
//   //       context,
//   //       routeName,
//   //       (route) => false,
//   //       arguments: arguments,
//   //     );
//   //   }

//   //   if (Global.userData != null) {
//   //     final activity = Global.userData?.activity ?? 0;
//   //     if (activity == 4) {
//   //       navigateToPage('base_class', arguments: Global.userData);
//   //     } else {
//   //       navigateToPage('detail_setup');
//   //     }
//   //   } else {
//   //     final isLandingPageViewed =
//   //         await DataPreferences.getData('isLandingPageViewed');
//   //     if (isLandingPageViewed == '1') {
//   //       navigateToPage('login_screen');
//   //     } else {
//   //       navigateToPage('landing_page');
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     double dW = MediaQuery.of(context).size.width;
//     double dH = MediaQuery.of(context).size.height;
//     double tS = dW * 0.045;

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.flash_on,
//               size: dW * 0.2,
//               color: Colors.white,
//             ),
//             SizedBox(height: dH * 0.03),
//             Text(
//               "Welcome to MyApp",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: tS,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/theme/theme_provider.dart';
import 'package:petty_cash/view/HomeScreen.dart';

import 'package:petty_cash/view/login/ChooseLoginTypePage.dart';
import 'package:petty_cash/view/login/LoginScreen.dart';
import 'package:petty_cash/view/widget/SplashPageAnimation.dart';

import 'package:petty_cash/view_model/CommonProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late CommonVM commonProvider;
  late ThemeProvider themeProvider;

  Color? savedColor;
  bool isCallAnim1 = false;
  bool isCallAnimOneDone = false;
  bool isCallAnimTwoDone = false;
  bool isCallAnim2 = false;

  @override
  void initState() {
    super.initState();
    commonProvider = Provider.of<CommonVM>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _splashDone();
  }

  void _splashDone() async {
    savedColor = await _loadThemeColor();
    themeProvider.toggleTheme(savedColor ?? Colors.blueGrey);
    Global.initializeAppSetup();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isCallAnim1 = true;
      });
      _callNext();
    });
  }

  Future<void> _callNext() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isCallAnimOneDone = true;
      isCallAnimTwoDone = true;
      isCallAnim2 = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      isCallAnim2 = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    _goToNextPage();
  }

  Future<Color?> _loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('theme_color');
    return colorValue != null ? Color(colorValue) : null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            if (isCallAnimOneDone && isCallAnimTwoDone) _buildLogo(),
            _buildBottomImage(),
            if (!isCallAnimOneDone) _buildAnimationOne(),
            if (isCallAnimTwoDone) _buildAnimationTwo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'assets/images/bg.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Petty',
            style: TextStyle(
                fontSize: 50, fontFamily: 'Bold', color: Colors.black),
          ),
          const SizedBox(height: 5), // Added space for better UI
          Container(
            margin: const EdgeInsets.only(left: 100.0),
            child: const Text(
              'Cash',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Bold',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomImage() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Image.asset(
        'assets/images/comp_user.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildAnimationOne() {
    return Center(
        child: SplashPageAnimation(context).callAnimationOne(isCallAnim1));
  }

  Widget _buildAnimationTwo() {
    return SplashPageAnimation(context).callAnimationTwo(!isCallAnim2);
  }

  void _goToNextPage() {
    String nextPage = ApiUrl.baseUrl?.isEmpty ?? true
        ? ChooseLoginTypePage.id
        : (Global.empData?.isLoggedIn == true ? HomeScreen.id : LoginScreen.id);

    Navigator.pushNamedAndRemoveUntil(context, nextPage, (route) => false);
  }
}
