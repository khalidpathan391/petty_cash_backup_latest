import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardModel.dart';
import 'package:petty_cash/data/models/HomePage/MenuResponse.dart';
import 'package:petty_cash/data/models/app_version_model.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/theme/theme_provider.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/AppsPage.dart';
import 'package:petty_cash/view/bottom_navigation_pages/CompanyPage.dart';
import 'package:petty_cash/view/bottom_navigation_pages/HomePage.dart';
import 'package:petty_cash/view/bottom_navigation_pages/NotificationPage.dart';
import 'package:petty_cash/view/bottom_navigation_pages/ProfilePage.dart';
import 'package:petty_cash/view/widget/app_version.dart';
import 'package:provider/provider.dart';

class HomeMainVM extends ChangeNotifier {
  final _myRepo = GeneralRepository();
  final List<Widget> pageOptions = [];

  late TextEditingController searchController;

  HomeMainVM() {
    searchController = TextEditingController();
    searchController.text = '';
    pageOptions.addAll([
      const NotificationPage(),
      const ProfilePage(),
      HomePage(_callbackFunction),
      CompanyPage(),
      AppsPage(),
    ]);
  }

  int count = 0;

  void _callbackFunction() {
    count += 20;
    notifyListeners();
  }

  String tabVal = 'pending';
  String tabDataType = 'static';

  Map getData() {
    Map data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId,
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'time_zone': 'Asia/Riyadh',
      'timezone': 'Asia/Riyadh',
      'tab_data_type': tabDataType,
      'tab_val': tabVal,
      'sort_by_key': '',
      'sort_by_val': '',
      'filter_by_key': '',
      'filter_by_type': '',
      'filter_by_one': '',
      'filter_by_two': '',
      'search_val': '',
      'start': '0',
      'mobile_app_id': '2',
    };
    return data;
  }

  int selectedIndex = 2;

  void onItemTapped(int index, BuildContext context) {
    // if (index == 4) {
    //   // showAppListList();
    //   // homeVMGlobal.getModulesListData(context);
    //   getModulesListData(context);
    // } else {
    //   selectedIndex = index;
    // }
    // paginationIndex = 0;
    paginationIndex = 0;
    moduleList = [];
    selectedIndex = index;
    notifyListeners();
  }

  List<ModulesLst> moduleList = [];
  List<ModulesLst> filteredModuleList = [];
  bool isLoading = false;
  final int itemsPerPage = 20;

  // changed by khalid
  // final int itemsPerPage = 20;
  int pageCount = 0;
  int paginationIndex = 0;

  void setPaginationIndex(int index) {
    paginationIndex = index;
    notifyListeners();
  }

  PageController pageController = PageController();

  // Method to jump to a specific page
  void jumpToPage(int index) {
    pageController.jumpToPage(index);
    // notifyListeners();
  }

  Future<void> getModulesListData() async {
    // paginationIndex = 0;
    // moduleList = [];
    notifyListeners();
    isLoading = true;
    try {
      if (moduleList.isEmpty) {
        final value = await _myRepo.postApi(
            ApiUrl.baseUrl! + ApiUrl.dashBoard, getData());
        DashBoardModel dashBoardModel = DashBoardModel.fromJson(value);
        moduleList = dashBoardModel.modulesLst!;
        filteredModuleList = moduleList;
        pageCount = (moduleList.length / itemsPerPage).ceil();
        moduleList.isEmpty ? AppUtils.errorMessage = AppUtils.noDataFound : '';
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchModulesListData(String query) {
    if (query.isEmpty) {
      filteredModuleList = moduleList;
      notifyListeners();
      return;
    }
    query = query.toLowerCase();
    List<ModulesLst> result = [];
    for (int i = 0; i < moduleList.length; i++) {
      var module = moduleList[i];
      if (module.moduleCode.toString().toLowerCase().contains(query) ||
          module.moduleDesc.toString().toLowerCase().contains(query)) {
        result.add(module);
      }
    }
    filteredModuleList = result;
    notifyListeners();
  }

  /*void callTryAgain() {
    isLoading = true;
    notifyListeners();
    getModulesListData();
  }*/

  List<String> menuList = [
    "viewUpdateAtt".tr(),
    "doorAccess".tr(),
    "manpowerProgress".tr(),
    "clearance".tr(),
    "downloads".tr(),
    "assetsSearch".tr(),
    "settings".tr()
  ];

  // void onSideMenuItemClick(int index, BuildContext context) {
  //   if (index == 0) {
  //     // Provider.of<ThemeProvider>(context, listen: false)
  //     //     .toggleTheme(AppUtils.getRandomColor());
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => ViewAttendancePage(
  //                 Global.empData!.empCode.toString(),
  //                 Global.empData!.empName.toString()))).then((value) {});
  //   } else if (index == 1) {
  //     Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => DoorAccessDeviceList()))
  //         .then((value) {});
  //   } else if (index == 2) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => MPProgressPage(
  //                 Global.empData!.userId.toString(),
  //                 Global.empData!.empCode.toString(),
  //                 Global.empData!.empName.toString()))).then((value) {});
  //   } else if (index == 3) {
  //     Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const EmployeeClearanceViewPage()))
  //         .then((value) {});
  //   } else if (index == 4) {
  //     Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => CommonDownloadView()))
  //         .then((value) {});
  //   } else if (index == 5) {
  //     Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => const EmpAssetSearch()))
  //         .then((value) {});
  //   } else if (index == 6) {
  //     Navigator.pushNamed(context, Settings.id).then((value) {});
  //   }
  // }

  void onSideMenuItemColorClick(Color color, BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(color);
  }

  void callOnChangeLanguage(BuildContext context) {
    if (context.locale.languageCode == 'en') {
      context.setLocale(const Locale('ar', 'SA'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }
    Global.setLanguage(context);
  }

  final List<Color> colors = [
    const Color(0xFF0046A6),
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    const Color(0xFF305C75),
    const Color(0xFF8C5A21),
  ];

  Widget getColorView(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // Number of columns
        crossAxisSpacing: 2.0, // Spacing between columns
        mainAxisSpacing: 2.0, // Spacing between rows
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.openEndDrawer();
            }
            onSideMenuItemColorClick(colors[index], context);
          },
          child: Container(
            color: colors[index],
          ),
        );
      },
    );
  }

  String? pageType;
  String? pageIcon;
  bool isClicked = false;

  void changePage(String code, String iconData, BuildContext context) {
    searchController.text = '';
    Global.moduleCode = code;
    isClicked = true;
    pageType = code;
    pageIcon = iconData;
    notifyListeners();
    // callMenuListApi(context);
  }

  // List<Menu> moduleByMenuList = [];

  Map getMenuRequestData() {
    Map data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'group_code': pageType.toString(),
    };
    return data;
  }

  bool isMenuApiCalling = false;

  // Future<void> callMenuListApi(BuildContext context) async {
  //   isMenuApiCalling = true;
  //   sideMenuList = [];
  //   filteredMenuList = [];
  //   try {
  //     Navigator.pop(context);
  //     pageOptions[pageOptions.length - 1] =
  //         Common(context).getPageByCodeName(pageType.toString());
  //     selectedIndex = pageOptions.length - 1;
  //     changeSelectedItem(selectedIndex);
  //     final value = await _myRepo.postApi(
  //         ApiUrl.baseUrl! + ApiUrl.getMenuPageList, getMenuRequestData());
  //     MenuResponse dashBoardModel = MenuResponse.fromJson(value);
  //     sideMenuList = dashBoardModel.menu;
  //     filteredMenuList = sideMenuList;
  //   } catch (e) {
  //     print(e.toString());
  //   } finally {
  //     isClicked = false;
  //     isMenuApiCalling = false;
  //     notifyListeners();
  //   }
  // }

  // void openModuleListPage(Menu data, BuildContext context) {
  //   // Navigator.pushNamed(context, CommonListingPage.id, arguments: data);
  //   Global.menuData = data;
  //   Navigator.pushNamed(context, CommonListingPage.id, arguments: "Wasi");
  // }

  void changeSelectedItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }

// void showAppListList(BuildContext context, List<ModulesLst> moduleList) {
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       isDismissible: false,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: 0.5,
//           child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter mystate) {
//             return Scaffold(
//               appBar: AppBar(
//                 // backgroundColor: CustomColors.colorAccentBlue,
//                 centerTitle: true,
//                 title: CommonTextView(
//                   label: 'Modules',
//                   color: context.resources.color.colorWhite,
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.close,
//                       size: 25.0,
//                       color: context.resources.color.colorWhite,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // onBottomNavigationItemClick(2);
//                     },
//                   )
//                 ],
//                 leading: SizedBox(),
//               ),
//               body: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 5, // Number of columns
//                           crossAxisSpacing: 2.0, // Spacing between columns
//                           mainAxisSpacing: 2.0, // Spacing between rows
//                         ),
//                         itemCount: moduleList.length,
//                         itemBuilder: (context, index) {
//                           Uint8List bytes = base64Decode(moduleList[index]
//                               .moduleIcon
//                               .toString()
//                               .split(',')
//                               .last);
//                           return CommonInkWell(
//                             onTap: () {
//                               changePage(
//                                   moduleList[index].moduleCode!, context);
//                             },
//                             splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                             highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(10),
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   moduleList[index].moduleIcon!.isNotEmpty
//                                       ? SizedBox(
//                                           height: 50,
//                                           width: 50,
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(10.0),
//                                             child: Image.memory(
//                                               bytes,
//                                               fit: BoxFit
//                                                   .cover, // You can adjust the BoxFit property as needed
//                                             ),
//                                           ),
//                                         )
//                                       : Icon(Icons.photo,size: 50,),
//                                   SizedBox(height: 3.0,),
//                                   CommonTextView(
//                                     label:
//                                         moduleList[index].moduleDesc.toString(),
//                                     fontSize: 12.0,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         );
//       });
// }

  /*void makeCountryList() {
    Map<String, List<String>> countryStateMap = {
      "India": ["Hindi", "Bengali", "Telugu", "Tamil", "Malayalam", "Kannada"],
      "Saudi Arabia": ["Arabic"],
      "Korea": ["Korean"],
      "USA": ["English"],
      "Tagalog": ["Filipino"]
    };

    List<LanguagesDataParent> parentList = [];

    countryStateMap.forEach((country, states) {
      List<LanguagesDataChild> childList = [];
      for (var state in states) {
        String stateCode = "";
        switch (country) {
          case "India":
            stateCode = "hi";
            break;
          case "Saudi Arabia":
            stateCode = "ar";
            break;
          case "Korea":
            stateCode = "ko";
            break;
          case "USA":
            stateCode = "en";
            break;
          case "Tagalog":
            stateCode = "tag";
            break;
        }
        var child = LanguagesDataChild(stateCode, state, "", false);
        childList.add(child);
      }

      String countryCode = "";
      switch (country) {
        case "India":
          countryCode = "IN";
          break;
        case "Saudi Arabia":
          countryCode = "SA";
          break;
        case "Korea":
          countryCode = "KO";
          break;
        case "USA":
          countryCode = "US";
          break;
        case "Tagalog":
          countryCode = "PH";
          break;
      }

      var parent = LanguagesDataParent(countryCode, country, "", childList);
      parentList.add(parent);
    });
  }*/

  List<String> countryList = [
    "India",
    "Saudi Arabia",
    "Korea",
    "USA",
    "Tagalog"
  ];
  List<String> countryLogo = ["logo1", "logo2", "logo3", "logo4", "logo5"];
  List<String> indiaStateList = [
    "Hindi",
    "Bengali",
    "Telugu",
    "Tamil",
    "Malayalam",
    "Kannada"
  ];
  List<String> indiaCodeStateList = ["hi", "bn", "tl", "ta", "ml", "kn"];
  List<String> saudiStateList = ["Arabic"];
  List<String> koreanStateList = ["Korean"];
  List<String> usaStateList = ["English"];
  List<String> filipinoStateList = ["Filipino"];
  List<LanguagesDataParent> parentList = [];

  void makeCountryList() {
    parentList = [];
    for (int i = 0; i < countryList.length; i++) {
      List<LanguagesDataChild> childList = [];
      if (i == 0) {
        for (int j = 0; j < indiaStateList.length; j++) {
          var child = LanguagesDataChild(
              indiaCodeStateList[j], indiaStateList[j], "", false);
          childList.add(child);
        }
        var s = LanguagesDataParent(
            "IN", countryList[i], countryLogo[i], childList);
        parentList.add(s);
      } else if (i == 1) {
        for (int j = 0; j < saudiStateList.length; j++) {
          var child = LanguagesDataChild("ar", saudiStateList[j], "", false);
          childList.add(child);
        }
        var s = LanguagesDataParent(
            "SA", countryList[i], countryLogo[i], childList);
        parentList.add(s);
      } else if (i == 2) {
        for (int j = 0; j < koreanStateList.length; j++) {
          var child = LanguagesDataChild("ko", koreanStateList[j], "", false);
          childList.add(child);
        }
        var s = LanguagesDataParent(
            "KO", countryList[i], countryLogo[i], childList);
        parentList.add(s);
      } else if (i == 3) {
        for (int j = 0; j < usaStateList.length; j++) {
          var child = LanguagesDataChild("en", usaStateList[j], "", false);
          childList.add(child);
        }
        var s = LanguagesDataParent(
            "US", countryList[i], countryLogo[i], childList);
        parentList.add(s);
      } else {
        for (int j = 0; j < filipinoStateList.length; j++) {
          var child =
              LanguagesDataChild("tag", filipinoStateList[j], "", false);
          childList.add(child);
        }
        var s = LanguagesDataParent(
            "PH", countryList[i], countryLogo[i], childList);
        parentList.add(s);
      }
    }
  }

  void checkAppVersion(BuildContext context) {
    _myRepo.postApi(ApiUrl.baseUrl! + ApiUrl.appVersion, {
      'device_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid
    }).then((value) {
      AppVersionModel? avData = AppVersionModel.fromJson(value);
      if (avData.errorCode == 200) {
        if (Global.packageInfo.version != avData.versionCode) {
          if (avData.isMandatory == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AppVersion(
                        data: avData,
                      )),
              // Replace with your target page
              (Route<dynamic> route) =>
                  false, // This removes all the previous routes
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppVersion(
                          data: avData,
                        )));
          }
        }
      }
    }).onError((error, stackTrace) {
      AppUtils.errorMessage = ''; //no need to check any error
    }).whenComplete(() => notifyListeners());
  }

  void refreshMenu() {
    notifyListeners();
  }

  List<Menu> sideMenuList = [];
  List<Menu> filteredMenuList = [];

  void filterMenuList(String query) {
    if (query.isEmpty) {
      filteredMenuList = sideMenuList;
      notifyListeners();
      return;
    }
    query = query.toLowerCase();
    List<Menu> result = [];
    for (int i = 0; i < sideMenuList.length; i++) {
      var menu = sideMenuList[i];
      if (menu.title.toString().toLowerCase().contains(query)) {
        result.add(menu);
      } else {
        List<Menu> filteredChildMenus = filterChildMenus(menu.child, query);
        if (filteredChildMenus.isNotEmpty) {
          result.add(Menu(
              id: menu.id,
              title: menu.title,
              url: menu.url,
              parentId: menu.parentId,
              txnType: menu.txnType,
              txnCode: menu.txnCode,
              parameter: menu.parameter,
              userId: menu.userId,
              companyId: menu.companyId,
              displayMobileApp: menu.displayMobileApp,
              pageTypeId: menu.pageTypeId,
              pageTypeCode: menu.pageTypeCode,
              pageTypeDesc: menu.pageTypeDesc,
              menuIcon: menu.menuIcon,
              child: filteredChildMenus,
              isShowing: menu.isShowing,
              filterTypeVal: menu.filterTypeVal,
              filterTypeCode: menu.filterTypeCode));
        }
      }
    }
    filteredMenuList = result;
    notifyListeners();
  }

  List<Menu> filterChildMenus(List<Menu> children, String query) {
    List<Menu> result = [];
    for (int j = 0; j < children.length; j++) {
      var child = children[j];
      if (child.title.toString().toLowerCase().contains(query)) {
        result.add(child);
      } else {
        List<Menu> filteredSubChildMenus = filterChildMenus(child.child, query);
        if (filteredSubChildMenus.isNotEmpty) {
          result.add(Menu(
              id: child.id,
              title: child.title,
              url: child.url,
              parentId: child.parentId,
              txnType: child.txnType,
              txnCode: child.txnCode,
              parameter: child.parameter,
              userId: child.userId,
              companyId: child.companyId,
              displayMobileApp: child.displayMobileApp,
              pageTypeId: child.pageTypeId,
              pageTypeCode: child.pageTypeCode,
              pageTypeDesc: child.pageTypeDesc,
              menuIcon: child.menuIcon,
              child: filteredSubChildMenus,
              isShowing: child.isShowing,
              filterTypeVal: child.filterTypeVal,
              filterTypeCode: child.filterTypeCode));
        }
      }
    }
    return result;
  }
}

class LanguagesDataParent {
  String countryCode;
  String countryName;
  String countryLogo;
  List<LanguagesDataChild> child;

  LanguagesDataParent(
    this.countryCode,
    this.countryName,
    this.countryLogo,
    this.child,
  );
}

class LanguagesDataChild {
  String stateCode;
  String stateName;
  String stateLogo;
  bool isLangSelected;

  LanguagesDataChild(
      this.stateCode, this.stateName, this.stateLogo, this.isLangSelected);
}
