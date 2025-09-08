// ignore_for_file: unnecessary_cast

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/Authentication/AuthenticationModel.dart';
import 'package:petty_cash/data/models/HomePage/MenuResponse.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:petty_cash/data/models/custom/custom_loader_model.dart';
import 'package:petty_cash/data/sources/local/shared_preference.dart';
import 'package:petty_cash/resources/api_url.dart';

class Global {
  static String? mobileId = 'xyz';
  static const String appName = 'CREBRI_ERP';
  static String? firebaseToken = '';
  static EmpData? empData;

  // Platform.isIOS ? Global.device_type_ios : Global.device_type_android,
  static const String deviceTypeAndroid = 'AN';
  static const String deviceTypeIos = 'IOS';
  static String deviceId = '';
  static String deviceModel = '';
  static String deviceVersion = '';
  static String tempAuthId = '';
  static String tempAuthKey = '';
  static bool isArabic = false;
  static String? defaultTransLan = 'English';
  static String? transLanVal = 'en';
  static String? selectedLangCode = 'en';
  static String moduleCode = '';
  static Menu? menuData;
  static String subTxnType = '';
  static String transactionHeaderId = '';
  static int attachmentsLength = 0;
  // static List<HeaderAttchLst> headerAttachmentList = [];
  static SearchListType commonSearchType = SearchListType.defaultType;
  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  // static late final AppDatabase localDatabase;
  // static late final EamAssetsTableQueryDao eamAssetsDao;
  // static late final FileDownloaderDataDao fileDownloaderDao;
  // static late final ModuleTxnTypeTableQueryDao moduleDao;

  // static List<VideoModel> allVideoData = [];
  static Duration? videoTime;
  static bool isVideoTrue = false;

  static double latitude = 0.0;
  static double longitude = 0.0;

  static List<CustomLoaderModel> customLoaderList = [
    CustomLoaderModel(index: 0),
    CustomLoaderModel(index: 1, isSelected: true),
    CustomLoaderModel(index: 2),
  ];
  static int customLoaderIndex = 1; //by default

  static Map<String, String> languageMap = {
    'English': 'en',
    'Urdu': 'ur',
    'Hindi': 'hi',
    'Bengali': 'bn',
    'Telugu': 'te',
    'Tamil': 'ta',
    'Malayalam': 'ml',
    'Kannada': 'kn',
    'Arabic': 'ar',
    'Korean': 'ko',
    'Tagalog': 'tl',
  };

  static void initializeAppSetup() async {
    Global.packageInfo = await PackageInfo.fromPlatform();
    ApiUrl.baseUrl = await DataPreferences.getData('base_url');
    empData = await DataPreferences.loadEmpData() as EmpData?;
    mobileId = await DataPreferences.getData('identifier');
    moduleCode = '';

    //initialize the database
    // localDatabase = await $FloorAppDatabase.databaseBuilder('local_erp_db.db').build();
    // //initialize the dao
    // eamAssetsDao = localDatabase.assetsDao;
    // fileDownloaderDao = localDatabase.fileDataDao;
    // moduleDao = localDatabase.moduleDataDao;

    firebaseToken = await DataPreferences.getData('firebaseToken');
    selectedLangCode = await DataPreferences.getData('langCode');
    /*have to null if other user enter some value in id key and does not login and closes the app
     then the old user opens app and tries to login
     then this has to be cleared so no error and all condition in login page is satisfied*/
    tempAuthKey = '';
    tempAuthId = '';
    defaultTransLan = await DataPreferences.getData('default_lan');
    transLanVal = await DataPreferences.getData('default_lan_val');
    if (defaultTransLan == null || defaultTransLan.toString().isEmpty) {
      defaultTransLan = 'English';
      transLanVal = 'en';
    }
    subTxnType = '';
    transactionHeaderId = '';

    //Custom Loader Functions
    // var val = await DataPreferences.getData('custom_loader_selected');
    // if (val != null && val.toString().isNotEmpty) {
    //   customLoaderIndex = int.parse(val);
    // }
    // if (customLoaderIndex != 1) {
    //   for (int i = 0; i < customLoaderList.length; i++) {
    //     if (customLoaderIndex == i) {
    //       customLoaderList[i].isSelected = true;
    //     } else {
    //       customLoaderList[i].isSelected = false;
    //     }
    //   }
    // }
  }

  static void setLanguage(BuildContext context) {
    if (EasyLocalization.of(context)!.locale.languageCode == 'ar') {
      isArabic = true;
    } else {
      isArabic = false;
    }
  }

  static void changeTransLan(String language, String code) async {
    DataPreferences.saveData('default_lan', language);
    DataPreferences.saveData('default_lan_val', code);
    defaultTransLan = await DataPreferences.getData('default_lan');
    transLanVal = await DataPreferences.getData('default_lan_val');
  }
}

enum SearchListType {
  defaultType,
  visaRequestApplyFor,
  visaRequestEmpData,
  fiEmpData,
}
