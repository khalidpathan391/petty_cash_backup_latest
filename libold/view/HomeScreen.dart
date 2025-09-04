// ignore_for_file: unused_import, unnecessary_import, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardModel.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/common_annotated_region.dart';
import 'package:petty_cash/view/connectivity_change_handler.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/PageIndicator.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../view_model/HomePage/HomeMainVM.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

HomeMainVM homeVMGlobal = HomeMainVM();

class HomeScreenState extends State<HomeScreen> implements DialogClickListener {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    homeVMGlobal = Provider.of(context, listen: false);
    super.initState();
    homeVMGlobal.checkAppVersion(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  int count = 0;

  static void openDrawer() {
    if (Global.isArabic) {
      scaffoldKey.currentState?.openEndDrawer();
    } else {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonAnnotatedRegion(
      child: Consumer<HomeMainVM>(
        builder: (context, homeMainVM, widget) {
          //Custom Bottom Navigation
          BottomNavigationBarItem buildSvgNavigationBarItem({
            required String iconPath,
            required String label,
            required int index,
            required double selected,
            required double unSelected,
          }) {
            return BottomNavigationBarItem(
              icon: homeMainVM.selectedIndex == 4 && homeMainVM.isLoading
                  ? Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: context.resources.color.defaultBlueGrey,
                          )))
                  : SvgPicture.asset(
                      iconPath,
                      width: homeMainVM.selectedIndex == index
                          ? selected
                          : unSelected,
                      // Adjust width as needed
                      color: homeMainVM.selectedIndex == index
                          ? context.resources.color.themeColor // Selected color
                          : context.resources.color.themeColor
                              .withOpacity(.4), // Unselected color
                    ),
              label: label,
            );
          }

          return ConnectivityChangeHandler(
            retryClick: () {},
            child: WillPopScope(
              onWillPop: () async {
                if (homeMainVM.selectedIndex != 2) {
                  homeMainVM.selectedIndex = 2;
                  homeMainVM.onItemTapped(homeMainVM.selectedIndex, context);
                  return false;
                }
                return true;
              },
              child: Scaffold(
                key: scaffoldKey,
                body: homeMainVM.pageOptions[homeMainVM.selectedIndex],
                floatingActionButton: AppUtils.floatMenuIcon(context),
                // endDrawer: Global.isArabic ? getDrawer(homeMainVM) : null,
                // drawer: Global.isArabic ? null : getDrawer(homeMainVM),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    // buildSvgNavigationBarItem(
                    //   iconPath: 'assets/images/erp_app_icon/bell.svg',
                    //   label: 'Notification'.tr(),
                    //   index: 0,
                    //   selected: AppHeight(23),
                    //   unSelected: AppHeight(18),
                    // ),
                    buildSvgNavigationBarItem(
                      iconPath: 'assets/images/erp_app_icon/bell.svg',
                      label: 'TODO',
                      index: 0,
                      selected: AppHeight(23),
                      unSelected: AppHeight(18),
                    ),
                    buildSvgNavigationBarItem(
                      iconPath:
                          'assets/images/erp_app_icon/profile_settings.svg',
                      label: 'Profile & Sett'.tr(),
                      index: 1,
                      selected: AppHeight(25),
                      unSelected: AppHeight(20),
                    ),
                    buildSvgNavigationBarItem(
                      iconPath: 'assets/images/erp_app_icon/home.svg',
                      label: 'Home'.tr(),
                      index: 2,
                      selected: AppHeight(25),
                      unSelected: AppHeight(20),
                    ),
                    buildSvgNavigationBarItem(
                      iconPath: 'assets/images/erp_app_icon/company.svg',
                      label: 'Company'.tr(),
                      index: 3,
                      selected: AppHeight(25),
                      unSelected: AppHeight(20),
                    ),
                    buildSvgNavigationBarItem(
                      iconPath: 'assets/images/erp_app_icon/grid.svg',
                      label: 'App'.tr(),
                      index: 4,
                      selected: AppHeight(25),
                      unSelected: AppHeight(20),
                    ),
                  ],
                  currentIndex: homeMainVM.selectedIndex,
                  onTap: (index) {
                    if (index == 4) {
                      homeMainVM.getModulesListData();
                      showAppListList(context);
                      if (homeVMGlobal.paginationIndex != 0) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          homeVMGlobal.jumpToPage(homeVMGlobal.paginationIndex);
                        });
                      }
                    } else {
                      homeMainVM.onItemTapped(index, context);
                    }
                  },
                  showUnselectedLabels: true,
                  selectedItemColor: context.resources.color.defaultMediumGrey,
                  selectedLabelStyle: TextStyle(
                    fontSize: context.resources.dimension.appMediumText,
                    fontFamily: 'Regular',
                  ),
                  unselectedItemColor:
                      context.resources.color.defaultMediumGrey.withOpacity(.5),
                  unselectedLabelStyle: TextStyle(
                    fontSize: context.resources.dimension.appSmallText,
                    fontFamily: 'Regular',
                  ),
                ),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () {
                //     // Change the selected item to index 3 (CompanyPage) when the button is clicked
                //     homeVMGlobal.changeSelectedItem(3);
                //   },
                //   child: Icon(Icons.change_history),
                // ),
              ),
            ),
          );
        },
      ),
    );
  }

  String email = "";
  String address4 = "";
  String address5 = "";

  String callSetView() {
    var vcardData = "BEGIN:VCARD\n"
            "VERSION:3.0\n"
            "N:" +
        Global.empData!.lastName.toString() +
        ";;;" +
        Global.empData!.firstName.toString() +
        ";" +
        "\n"
            "FN:" +
        Global.empData!.empName.toString() +
        "\n"
            "TEL;TYPE=CELL:" +
        Global.empData!.contactMobile.toString() +
        "\n"
            "EMAIL:" +
        email +
        "\n"
            "ADR;TYPE=home:;;" +
        Global.empData!.compAddress1.toString() +
        ";" +
        "" +
        Global.empData!.compAddress2.toString() +
        ";" +
        Global.empData!.compAddress3.toString() +
        ";" +
        address4 +
        ";" +
        address5 +
        "\n"
            "ORG:" +
        Global.empData!.companyName.toString() +
        "\n"
            "TITLE:" +
        Global.empData!.designationDesc.toString() +
        "\n"
            "URL:" +
        Global.empData!.companyWebsite.toString() +
        "\n"
            "NOTE:" +
        Global.empData!.note.toString() +
        "\n"
            "END:VCARD";
    return vcardData;
  }

  /*String callSetView() {
    final empData = Global.empData;
    if (empData == null) {
      return ''; // Return empty if empData is null
    }
    return [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "N:${empData.lastName ?? ''};;;${empData.firstName ?? ''};",
      "FN:${empData.empName ?? ''}",
      "TEL;TYPE=CELL:${empData.contactMobile ?? ''}",
      "EMAIL:${email ?? ''}",
      "ADR;TYPE=home:;;${empData.compAddress1 ?? ''};${empData.compAddress2 ?? ''};${empData.compAddress3 ?? ''};${address4 ?? ''};${address5 ?? ''}",
      "ORG:${empData.companyName ?? ''}",
      "TITLE:${empData.designationDesc ?? ''}",
      "URL:${empData.companyWebsite ?? ''}",
      "NOTE:${empData.note ?? ''}",
      "END:VCARD"
    ].join("\n");
  }*/

  void showAppListList(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // isDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {},
            child: FractionallySizedBox(
              heightFactor: 0.47,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter myState) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Consumer<HomeMainVM>(
                    builder: (context, homeVMGlobal, child) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: context.resources.color.themeColor,
                          centerTitle: true,
                          title: CommonTextView(
                            label: 'modules'.tr(),
                            color: context.resources.color.colorWhite,
                            fontSize: 16,
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                size: 25.0,
                                color: context.resources.color.colorWhite,
                              ),
                              onPressed: () {
                                openSearchDialogView(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 25.0,
                                color: context.resources.color.colorWhite,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                // onBottomNavigationItemClick(2);
                              },
                            )
                          ],
                          leading: Icon(
                            Icons.apps_rounded,
                            size: 25.0,
                            color: context.resources.color.colorWhite,
                          ),
                        ),
                        body: homeVMGlobal.isLoading
                            ? const CommonShimmerView(
                                numberOfRow: 30,
                                isListView: false,
                              )
                            : AppUtils.errorMessage.isNotEmpty
                                ? Center(
                                    child: AppUtils(context)
                                        .getCommonErrorWidget(() {
                                    homeVMGlobal.getModulesListData();
                                  }, ''))
                                : PageView.builder(
                                    controller: homeVMGlobal.pageController,
                                    onPageChanged: (index) {
                                      homeVMGlobal.setPaginationIndex(index);
                                    },
                                    itemCount: homeVMGlobal.pageCount,
                                    itemBuilder:
                                        (BuildContext context, int pageIndex) {
                                      int startIndex =
                                          pageIndex * homeVMGlobal.itemsPerPage;
                                      int endIndex = (pageIndex + 1) *
                                          homeVMGlobal.itemsPerPage;
                                      endIndex = endIndex >
                                              homeVMGlobal.moduleList.length
                                          ? homeVMGlobal.moduleList.length
                                          : endIndex;
                                      List<ModulesLst> pageApps = homeVMGlobal
                                          .moduleList
                                          .sublist(startIndex, endIndex);
                                      return Column(
                                        children: [
                                          // const CommonTextFormField(
                                          //     height: 40,
                                          //     margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                                          //     label: 'Search here'),
                                          homeVMGlobal.isClicked
                                              ? LinearProgressIndicator(
                                                  backgroundColor: Colors
                                                      .deepOrange
                                                      .withOpacity(0.5),
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.deepOrange),
                                                  minHeight: AppHeight(3),
                                                )
                                              : const SizedBox(),
                                          Expanded(
                                            child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                crossAxisSpacing: 1,
                                                mainAxisSpacing: 1,
                                              ),
                                              itemCount: pageApps.length,
                                              itemBuilder: (context, index) {
                                                Uint8List bytes = base64Decode(
                                                    pageApps[index]
                                                        .moduleIcon
                                                        .toString()
                                                        .split(',')
                                                        .last);
                                                return CommonInkWell(
                                                  onTap: () {
                                                    if (homeVMGlobal
                                                        .isClicked) {
                                                      return;
                                                    }
                                                    homeVMGlobal.changePage(
                                                        pageApps[index]
                                                            .moduleCode!,
                                                        pageApps[index]
                                                            .moduleIcon!,
                                                        context);
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        pageApps[index]
                                                                .moduleIcon!
                                                                .isNotEmpty
                                                            ? SizedBox(
                                                                height: 45,
                                                                width: 45,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  child: Image
                                                                      .memory(
                                                                    bytes,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.photo,
                                                                size: 50,
                                                              ),
                                                        const SizedBox(
                                                          height: 3.0,
                                                        ),
                                                        CommonTextView(
                                                          label: pageApps[index]
                                                              .moduleDesc
                                                              .toString(),
                                                          overFlow: TextOverflow
                                                              .ellipsis,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5.0,
                                                                  right: 5.0),
                                                          fontSize: 10.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                        bottomNavigationBar: (homeVMGlobal.isLoading ||
                                AppUtils.errorMessage.isNotEmpty ||
                                homeVMGlobal.pageCount == 1)
                            ? const SizedBox()
                            : SizedBox(
                                height: 20,
                                child: PageIndicator(
                                  pageCount: homeVMGlobal.pageCount,
                                  currentIndex: homeVMGlobal.paginationIndex,
                                ),
                              ),
                      );
                    },
                  ),
                );
              }),
            ),
          );
        }).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        AppUtils.changeStatusBarColor(context.resources.color.themeColor);
      });
    });
  }

  void openSearchDialogView(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
            return Consumer<HomeMainVM>(
              builder: (context, homeVMGlobal, child) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: context.resources.color.themeColor,
                      margin: const EdgeInsets.only(bottom: 5.0, top: 22),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: CommonTextView(
                                label: 'Modules',
                                fontSize: 16.0,
                                padding: EdgeInsets.only(left: 10.0),
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              homeVMGlobal.searchModulesListData('');
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: context.resources.color.colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CommonTextFormField(
                      label: 'Search Here...',
                      onChanged: homeVMGlobal.searchModulesListData,
                      height: 40.0,
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(4.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: homeVMGlobal.filteredModuleList.length,
                        itemBuilder: (context, index) {
                          Uint8List bytes = base64Decode(homeVMGlobal
                              .filteredModuleList[index].moduleIcon
                              .toString()
                              .split(',')
                              .last);
                          return CommonInkWell(
                            onTap: () {
                              Navigator.pop(context);
                              // Navigator.pop(context);
                              homeVMGlobal.changePage(
                                  homeVMGlobal
                                      .filteredModuleList[index].moduleCode!,
                                  homeVMGlobal
                                      .filteredModuleList[index].moduleIcon!,
                                  context);
                              homeVMGlobal.searchModulesListData('');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  homeVMGlobal.filteredModuleList[index]
                                          .moduleIcon!.isNotEmpty
                                      ? SizedBox(
                                          height: 45,
                                          width: 45,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.memory(
                                              bytes,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.photo,
                                          size: 50,
                                        ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  CommonTextView(
                                    label: homeVMGlobal
                                        .filteredModuleList[index].moduleDesc
                                        .toString(),
                                    overFlow: TextOverflow.ellipsis,
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    fontSize: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          });
        }).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        homeVMGlobal.searchModulesListData('');
        AppUtils.changeStatusBarColor(context.resources.color.themeColor);
      });
    });
  }

  @override
  void clickOnNo(int type, dynamic provider) {}

  AuthVM? authVM;

  @override
  void clickOnYes(int type, dynamic provider) {
    authVM!.logout(context);
  }

  // Widget getDrawer(HomeMainVM homeMainVM) {
  //   return SizedBox(
  //     child: homeMainVM.selectedIndex == 4
  //         ? CommonDrawer(
  //             scaffoldKey: scaffoldKey,
  //             menuList: homeMainVM,
  //             onMenuItemClick: (data) {
  //               homeMainVM.openModuleListPage(data, context);
  //             },
  //           )
  //         : SafeArea(
  //             child: Drawer(
  //               shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.zero,
  //               ),
  //               child: Stack(
  //                 children: [
  //                   Column(
  //                     children: <Widget>[
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         padding: const EdgeInsets.all(10.0),
  //                         color: context.resources.color.themeColor,
  //                         child: Center(
  //                             child: CommonTextView(
  //                           label: "erpName".tr(),
  //                           color: Colors.white,
  //                           fontSize: 18,
  //                         )),
  //                       ),
  //                       CommonTextView(
  //                         label: "scanThisVcard".tr(),
  //                         fontSize: 14,
  //                         padding: EdgeInsets.all(5.0),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: QrImageView(
  //                           data: callSetView(),
  //                           version: QrVersions.auto,
  //                           size: 200.0,
  //                           backgroundColor: Colors.transparent,
  //                           foregroundColor: Colors.black,
  //                           padding: const EdgeInsets.only(top: 2.0),
  //                         ),
  //                       ),
  //                       const CommonTextView(
  //                         label: 'V-Card',
  //                         fontSize: 14.0,
  //                         fontFamily: 'Bold',
  //                       ),
  //                       const Divider(),
  //                       ListView.separated(
  //                           scrollDirection: Axis.vertical,
  //                           shrinkWrap: true,
  //                           itemCount: homeMainVM.menuList.length,
  //                           separatorBuilder: (context, index) =>
  //                               const Divider(),
  //                           itemBuilder: (context, index) {
  //                             return InkWell(
  //                               onTap: () {
  //                                 if (scaffoldKey.currentState!.isDrawerOpen) {
  //                                   scaffoldKey.currentState!.openEndDrawer();
  //                                 }
  //                                 homeMainVM.onSideMenuItemClick(
  //                                     index, context);
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(5.0),
  //                                 child: CommonTextView(
  //                                   label: homeMainVM.menuList[index],
  //                                   color: Colors.black,
  //                                   fontSize: 14.0,
  //                                 ),
  //                               ),
  //                             );
  //                           }),
  //                       const Divider(),
  //                     ],
  //                   ),
  //                   Positioned(
  //                       bottom: 0,
  //                       child: CommonTextView(
  //                         padding: const EdgeInsets.all(5.0),
  //                         fontSize: 14.0,
  //                         label: "currentApplicationVersion".tr() +
  //                             " : ${Global.packageInfo.version}",
  //                       ))
  //                 ],
  //               ),
  //             ),
  //           ),
  //   );
  // }
}
