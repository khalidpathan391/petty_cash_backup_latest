import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardModel.dart';
import 'package:petty_cash/view/HomeScreen.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Home_Pages/Filter.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Home_Pages/multi_filter.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Home_Pages/settings.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/IDCard/DDT/driving_license.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/digital_documents.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_details.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/user_profile.dart';

import 'package:petty_cash/view/login/ActivateQRCode.dart';
import 'package:petty_cash/view/login/ChooseLoginTypePage.dart';
import 'package:petty_cash/view/login/CompanyIdActivationPage.dart';
import 'package:petty_cash/view/login/LoginScreen.dart';
import 'package:petty_cash/view/login/ScanQRCodeORGenerate.dart';
import 'package:petty_cash/view/login/ScanQRCodePage.dart';
import 'package:petty_cash/view/login/SystemURLPage.dart';
import 'package:petty_cash/view/login/ValidateIDKeyPage.dart';
import 'package:petty_cash/view/po_transaction/transaction_page/po_page_listing.dart';

import 'package:petty_cash/view/po_transaction/transaction_page/po_transaction.dart';
import 'package:petty_cash/view/purchase_order_dashboard/po_dashboard.dart';

import 'package:petty_cash/view/startup_module/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      SplashScreen.id: (context) => SplashScreen(),
      HomeScreen.id: (context) => const HomeScreen(),
      LoginScreen.id: (context) => const LoginScreen(),
      ValidateIDKeyPage.id: (context) => const ValidateIDKeyPage(),
      ScanQRCodePage.id: (context) => const ScanQRCodePage(),
      ChooseLoginTypePage.id: (context) => const ChooseLoginTypePage(),
      ScanQRCodeORGenerate.id: (context) => const ScanQRCodeORGenerate(),
      ActivateQRCode.id: (context) => const ActivateQRCode(),
      CompanyIdActivationPage.id: (context) => CompanyIdActivationPage(),
      DrivingLicense.id: (context) => DrivingLicense(
            onDoubleTap: () {},
          ),
      DigitalDocuments.id: (context) => const DigitalDocuments(),
      SystemUrl.Id: (context) => const SystemUrl(),
      "my_account_details": (context) => const MyAccountDetails(),
      "user_profile": (context) => const UserProfile(),
      'po_transaction': (context) => PoTransaction(NotificationLst()),
      'po_dashboard': (context) => const DashboardScreen(),
      'po_listing': (context) => const PoListingPage(),
      'home_filter': (context) => const HomeFilter(),
      'setting_home': (context) => const SettingHome(),
      'multi_filter_home': (context) => const MultiFilter(),
    };
  }
}
