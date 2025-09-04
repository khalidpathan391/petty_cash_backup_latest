// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:local_auth/local_auth.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardModel.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_page.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/CustomAppBar.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/custom_refresher.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';

import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final VoidCallback callback;

  const HomePage(this.callback, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

HomeVM homeProvider = HomeVM();

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Timer? _timer;

  _HomePageState();

  final LocalAuthentication auth = LocalAuthentication();
  bool hasCancelledBiometric = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    //  homeVMGlobal = Provider.of(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // homeVM = Provider.of<HomeVM>(context, listen: false);
    _loadBiometricStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _isBiometricEnabled &&
        !homeProvider.hasAuthenticatedThisSession &&
        !hasCancelledBiometric) {
      _checkBiometricAvailability();
    }
  }

  Future<void> _loadBiometricStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool('isBiometricEnabled') ?? false;

    if (_isBiometricEnabled && !homeProvider.hasAuthenticatedThisSession) {
      _checkBiometricAvailability();
    }
  }

  Future<void> _checkBiometricAvailability() async {
    if (hasCancelledBiometric || homeProvider.hasAuthenticatedThisSession)
      return;

    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access your dashboard.',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          homeProvider.setAuthenticatedSession(true);
          AppUtils.showToastGreenBg(
              context, "Biometric authentication successful.");
        }
      } else {
        AppUtils.showToastRedBg(context,
            "Biometric authentication is not available on this device.");
      }
    } on PlatformException {
      setState(() {
        hasCancelledBiometric = true;
      });
      AppUtils.yesNoDialog(
        context,
        isType: 1,
        "Unlock",
        'Please unlock your phone',
        onYes: () {
          _checkBiometricAvailability();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //all the api is called in the constructor of VM
    HomeVM();
    return Consumer<HomeVM>(
      builder: (context, homeProvider, _) {
        return Scaffold(
          appBar: CustomAppBar(
            onTap: () {
              Navigator.pushNamed(context, MyAccount.id);
            },
            filter: true,
            settings: true,
            multiFilter: true,
            refresh: true,
            myFilter: () {
              // homeProvider.callFilterApi();
              // Navigator.pushNamed(context, HomeFilter.id).then((value) {});
            },
            mySettings: () {
              // homeProvider.callSettingPriorityApi();
              // Navigator.pushNamed(context, SettingHome.id).then((value) {});
            },
            myMultiFilter: () {
              // homeProvider.callMultiFilterListApi();
              // Navigator.pushNamed(context, MultiFilter.id).then((value) {
              //   homeProvider.setTabLoading(true);
              //   homeProvider.getDashBoardTabApi();
              //   // homeProvider.callDashBoardApi();
              // });
            },
            myRefresh: () {
              homeProvider.loadData(homeProvider.previousIndex);
            },
          ),
          body: homeProvider.tabLoading
              ? const CommonShimmerView(
                  shimmerViewType: ShimmerViewType.HOME_TAB,
                  numberOfRow: 18,
                )
              : AppUtils.errorMessage.isNotEmpty
                  ? AppUtils(context).getCommonErrorWidget(() {
                      // homeProvider.getDashBoardTabApi();
                    }, '')
                  : homeProvider.notificationTabListData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: AppHeight(90),
                              alignment: Alignment.center,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeProvider
                                      .notificationTabListData.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      left: AppWidth(35), right: AppWidth(35)),
                                  itemBuilder: (context, index) {
                                    return CommonInkWell(
                                      onTap: () {
                                        if (!homeProvider.isTabDisable) {
                                          homeProvider.tabVal = homeProvider
                                              .notificationTabListData[index]
                                              .tabVal
                                              .toString();
                                          homeProvider.tabDataType =
                                              homeProvider
                                                  .notificationTabListData[
                                                      index]
                                                  .tabDataType
                                                  .toString();
                                          homeProvider.loadData(index);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(5),
                                      child: MyTabs(
                                          text: homeProvider
                                              .notificationTabListData[index]
                                              .fTabDataCount
                                              .toString(),
                                          label: homeProvider
                                              .notificationTabListData[index]
                                              .tabName
                                              .toString(),
                                          isNeedColorChange: homeProvider
                                              .notificationTabListData[index]
                                              .isSelected!),
                                    );
                                  }),
                            ),
                            Row(
                              children: [
                                CommonTextView(
                                  label: 'Pending Notification'.tr(),
                                  fontSize: appTextSize(17),
                                  margin: EdgeInsets.only(
                                      left: Global.isArabic ? 0 : AppWidth(10),
                                      right:
                                          Global.isArabic ? AppWidth(10) : 0),
                                ),
                              ],
                            ),
                            Container(
                              height: AppHeight(6),
                              margin: EdgeInsets.only(
                                  right: AppWidth(6),
                                  left: AppWidth(6),
                                  top: AppHeight(5)),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color:
                                        context.resources.color.colorLightGrey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  homeProvider.callPullToRefresh();
                                },
                                edgeOffset: -300,
                                child: homeProvider.isPullToRefresh
                                    ? const CustomRefresher()
                                    : PagedListView<int, NotificationLst>(
                                        pagingController:
                                            homeProvider.pagingController,
                                        builderDelegate:
                                            PagedChildBuilderDelegate<
                                                NotificationLst>(
                                          animateTransitions: true,
                                          transitionDuration:
                                              const Duration(microseconds: 500),
                                          firstPageProgressIndicatorBuilder:
                                              (_) => const CommonShimmerView(
                                            numberOfRow: 15,
                                            shimmerViewType:
                                                ShimmerViewType.HOME_PAGE,
                                          ),
                                          firstPageErrorIndicatorBuilder: (_) =>
                                              Center(
                                                  child: AppUtils(context)
                                                      .getCommonErrorWidget(() {
                                            homeProvider.pagingController
                                                .retryLastFailedRequest();
                                          }, 'Error Loading Data')),
                                          newPageProgressIndicatorBuilder:
                                              (_) => const CommonShimmerView(
                                                  numberOfRow: 15,
                                                  shimmerViewType:
                                                      ShimmerViewType
                                                          .HOME_PAGE),
                                          newPageErrorIndicatorBuilder: (_) =>
                                              Center(
                                                  child: AppUtils(context)
                                                      .getCommonErrorWidget(() {
                                            homeProvider.pagingController
                                                .retryLastFailedRequest();
                                          }, 'Error Loading More Data')),
                                          noItemsFoundIndicatorBuilder: (_) =>
                                              EmptyListWidget(
                                            onTap: () {
                                              homeProvider.pagingController
                                                  .refresh();
                                            },
                                          ),
                                          noMoreItemsIndicatorBuilder: (_) =>
                                              const Center(
                                            child: CommonTextView(
                                              label: 'List over',
                                            ),
                                          ),
                                          itemBuilder: (context, item, index) {
                                            double minDimension =
                                                AppHeight(34) < AppWidth(34)
                                                    ? AppHeight(34)
                                                    : AppWidth(34);

                                            return CommonInkWell(
                                              onTap: () {
                                                homeProvider.callNextPage(
                                                    context, item);
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: AppWidth(4),
                                                            height:
                                                                AppHeight(34),
                                                            color: homeProvider
                                                                .hexToColor(item
                                                                    .colorCode!),
                                                          ),
                                                          Container(
                                                            height:
                                                                AppHeight(34),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        AppWidth(
                                                                            8),
                                                                    left:
                                                                        AppWidth(
                                                                            8)),
                                                            width: AppWidth(34),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: context
                                                                      .resources
                                                                      .color
                                                                      .colorLightGrey,
                                                                  width: .5),
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (item.media ==
                                                                    1) {
                                                                  AppUtils.showPhotoDialog(
                                                                      context,
                                                                      item.enRaisedBy
                                                                          .toString(),
                                                                      '${ApiUrl.baseUrl}${item.fileName}');
                                                                }
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius:
                                                                    minDimension /
                                                                        2,
                                                                backgroundColor: context
                                                                    .resources
                                                                    .color
                                                                    .colorLightGrey
                                                                    .withOpacity(
                                                                        .5),
                                                                child: item.media ==
                                                                        0
                                                                    ? CommonTextView(
                                                                        label: item
                                                                            .fileName!,
                                                                        fontSize: context
                                                                            .resources
                                                                            .dimension
                                                                            .appBigText,
                                                                        color: context
                                                                            .resources
                                                                            .color
                                                                            .themeColor,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            '${ApiUrl.baseUrl}${item.fileName}',
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          height:
                                                                              AppHeight(34),
                                                                          width:
                                                                              AppWidth(34),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                          ),
                                                                        ),
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                progress) =>
                                                                            SizedBox(
                                                                          width:
                                                                              10.0,
                                                                          height:
                                                                              10.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            value:
                                                                                progress.progress,
                                                                            color:
                                                                                context.resources.color.themeColor,
                                                                            strokeWidth:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context, url, error) => CommonTextView(
                                                                            label:
                                                                                item.fileName!,
                                                                            fontSize: context.resources.dimension.appBigText,
                                                                            color: context.resources.color.themeColor),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CommonTextView(
                                                                label: item
                                                                    .enRaisedBy!,
                                                                width: AppWidth(
                                                                    225),
                                                                fontSize:
                                                                    appTextSize(
                                                                        13),
                                                                maxLine: 1,
                                                                overFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                padding: EdgeInsets.only(
                                                                    bottom:
                                                                        AppHeight(
                                                                            2)),
                                                              ),
                                                              SizedBox(
                                                                width: AppWidth(
                                                                    225),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  alignment: Global.isArabic
                                                                      ? Alignment
                                                                          .centerRight
                                                                      : Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      CommonTextView(
                                                                        label:
                                                                            '${item.enTxnFor!}(${item.enNtfId!})',
                                                                        fontSize:
                                                                            appTextSize(11),
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top: AppHeight(
                                                                              2),
                                                                          right: Global.isArabic
                                                                              ? 0
                                                                              : AppWidth(7),
                                                                          left: Global.isArabic
                                                                              ? AppWidth(7)
                                                                              : 0,
                                                                        ),
                                                                        color: context
                                                                            .resources
                                                                            .color
                                                                            .themeColor,
                                                                        overFlow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      // homeProvider.getNotificationIcon(item.notificationStatus!,context.resources.color.colorBlack),
                                                                      homeProvider.getSvgPicture(
                                                                          context,
                                                                          item
                                                                              .notificationStatus!,
                                                                          context
                                                                              .resources
                                                                              .color
                                                                              .colorBlack),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CommonTextView(
                                                            label: item.enCrDt!,
                                                            fontSize:
                                                                appTextSize(12),
                                                            maxLine: 1,
                                                            overFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            // margin: EdgeInsets.only(left: Global.isArabic ? 0 : AppWidth(2), right: Global.isArabic ? AppWidth(2) : 0),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/images/erp_app_icon/calendar.svg',
                                                                height:
                                                                    AppHeight(
                                                                        13),
                                                              ),
                                                              CommonTextView(
                                                                label: item
                                                                    .humanAgo!,
                                                                fontSize:
                                                                    appTextSize(
                                                                        13),
                                                                margin: EdgeInsets.only(
                                                                    left: Global
                                                                            .isArabic
                                                                        ? 0
                                                                        : AppWidth(
                                                                            2),
                                                                    right: Global
                                                                            .isArabic
                                                                        ? AppWidth(
                                                                            2)
                                                                        : 0),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: AppHeight(6),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: AppWidth(385),
                                                        padding: EdgeInsets.only(
                                                            left: Global
                                                                    .isArabic
                                                                ? 0
                                                                : AppWidth(12),
                                                            right: Global
                                                                    .isArabic
                                                                ? AppWidth(12)
                                                                : 0),
                                                        child: ReadMoreText(
                                                          item.enSubject!,
                                                          trimLines: 3,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  appTextSize(
                                                                      13),
                                                              fontFamily:
                                                                  'Regular'),
                                                          trimMode:
                                                              TrimMode.Line,
                                                          moreStyle: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontFamily: 'Bold',
                                                            color: context
                                                                .resources
                                                                .color
                                                                .themeColor,
                                                          ),
                                                          lessStyle: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontFamily:
                                                                'BoldItalic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: context
                                                                .resources
                                                                .color
                                                                .themeColor,
                                                          ),
                                                          trimCollapsedText:
                                                              'Show More',
                                                          trimExpandedText:
                                                              ' Show Less',
                                                        ),
                                                      ),
                                                      // Container(
                                                      //     height:AppHeight(25),
                                                      //     width:AppWidth(10),
                                                      //     margin: EdgeInsets.only(right: Global.isArabic ? AppWidth(7) :AppWidth(11),left: Global.isArabic ? AppWidth(11) :AppWidth(7)),
                                                      //     decoration: DottedDecoration(
                                                      //       shape: Shape.box,
                                                      //       color: Colors.black,
                                                      //       strokeWidth: 0.5,
                                                      //       dash: const [1,1],
                                                      //       // borderRadius: BorderRadius.circular(AppHeight(25)*.05),
                                                      //     ),
                                                      //     child: const Icon(Icons.more_vert,size: 10,),
                                                      // ),
                                                      SvgPicture.asset(
                                                        'assets/images/erp_app_icon/menu.svg',
                                                        height: AppHeight(25),
                                                        width: AppWidth(10),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: AppHeight(6),
                                                    margin: EdgeInsets.only(
                                                        right: AppWidth(6),
                                                        left: AppWidth(6),
                                                        top: AppHeight(10),
                                                        bottom: AppHeight(10)),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorLightGrey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

@override
Widget build(BuildContext context) {
  //all the api is called in the constructor of VM
  HomeVM();
  return Consumer<HomeVM>(
    builder: (context, homeProvider, _) {
      return Scaffold(
        appBar: CustomAppBar(
          onTap: () {
            Navigator.pushNamed(context, MyAccount.id);
          },
          filter: true,
          settings: true,
          multiFilter: true,
          refresh: true,
          myFilter: () {
            // homeProvider.callFilterApi();
            // Navigator.pushNamed(context, HomeFilter.id).then((value) {});
          },
          mySettings: () {
            // homeProvider.callSettingPriorityApi();
            // Navigator.pushNamed(context, SettingHome.id).then((value) {});
          },
          myMultiFilter: () {
            // homeProvider.callMultiFilterListApi();
            // Navigator.pushNamed(context, MultiFilter.id).then((value) {
            //   homeProvider.setTabLoading(true);
            //   homeProvider.getDashBoardTabApi();
            //   // homeProvider.callDashBoardApi();
            // });
          },
          myRefresh: () {
            homeProvider.loadData(homeProvider.previousIndex);
          },
        ),
        body: homeProvider.tabLoading
            ? const CommonShimmerView(
                shimmerViewType: ShimmerViewType.HOME_TAB,
                numberOfRow: 18,
              )
            : AppUtils.errorMessage.isNotEmpty
                ? AppUtils(context).getCommonErrorWidget(() {
                    // homeProvider.getDashBoardTabApi();
                  }, '')
                : homeProvider.notificationTabListData.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: AppHeight(90),
                            alignment: Alignment.center,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    homeProvider.notificationTabListData.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    left: AppWidth(35), right: AppWidth(35)),
                                itemBuilder: (context, index) {
                                  return CommonInkWell(
                                    onTap: () {
                                      if (!homeProvider.isTabDisable) {
                                        homeProvider.tabVal = homeProvider
                                            .notificationTabListData[index]
                                            .tabVal
                                            .toString();
                                        homeProvider.tabDataType = homeProvider
                                            .notificationTabListData[index]
                                            .tabDataType
                                            .toString();
                                        homeProvider.loadData(index);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: MyTabs(
                                        text: homeProvider
                                            .notificationTabListData[index]
                                            .fTabDataCount
                                            .toString(),
                                        label: homeProvider
                                            .notificationTabListData[index]
                                            .tabName
                                            .toString(),
                                        isNeedColorChange: homeProvider
                                            .notificationTabListData[index]
                                            .isSelected!),
                                  );
                                }),
                          ),
                          Row(
                            children: [
                              CommonTextView(
                                label: 'Pending Notification'.tr(),
                                fontSize: appTextSize(17),
                                margin: EdgeInsets.only(
                                    left: Global.isArabic ? 0 : AppWidth(10),
                                    right: Global.isArabic ? AppWidth(10) : 0),
                              ),
                            ],
                          ),
                          Container(
                            height: AppHeight(6),
                            margin: EdgeInsets.only(
                                right: AppWidth(6),
                                left: AppWidth(6),
                                top: AppHeight(5)),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: context.resources.color.colorLightGrey,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                homeProvider.callPullToRefresh();
                              },
                              edgeOffset: -300,
                              child: homeProvider.isPullToRefresh
                                  ? const CustomRefresher()
                                  : PagedListView<int, NotificationLst>(
                                      pagingController:
                                          homeProvider.pagingController,
                                      builderDelegate:
                                          PagedChildBuilderDelegate<
                                              NotificationLst>(
                                        animateTransitions: true,
                                        transitionDuration:
                                            const Duration(microseconds: 500),
                                        firstPageProgressIndicatorBuilder:
                                            (_) => const CommonShimmerView(
                                          numberOfRow: 15,
                                          shimmerViewType:
                                              ShimmerViewType.HOME_PAGE,
                                        ),
                                        firstPageErrorIndicatorBuilder: (_) =>
                                            Center(
                                                child: AppUtils(context)
                                                    .getCommonErrorWidget(() {
                                          homeProvider.pagingController
                                              .retryLastFailedRequest();
                                        }, 'Error Loading Data')),
                                        newPageProgressIndicatorBuilder: (_) =>
                                            const CommonShimmerView(
                                                numberOfRow: 15,
                                                shimmerViewType:
                                                    ShimmerViewType.HOME_PAGE),
                                        newPageErrorIndicatorBuilder: (_) =>
                                            Center(
                                                child: AppUtils(context)
                                                    .getCommonErrorWidget(() {
                                          homeProvider.pagingController
                                              .retryLastFailedRequest();
                                        }, 'Error Loading More Data')),
                                        noItemsFoundIndicatorBuilder: (_) =>
                                            EmptyListWidget(
                                          onTap: () {
                                            homeProvider.pagingController
                                                .refresh();
                                          },
                                        ),
                                        noMoreItemsIndicatorBuilder: (_) =>
                                            const Center(
                                          child: CommonTextView(
                                            label: 'List over',
                                          ),
                                        ),
                                        itemBuilder: (context, item, index) {
                                          double minDimension =
                                              AppHeight(34) < AppWidth(34)
                                                  ? AppHeight(34)
                                                  : AppWidth(34);

                                          return CommonInkWell(
                                            onTap: () {
                                              homeProvider.callNextPage(
                                                  context, item);
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: AppWidth(4),
                                                          height: AppHeight(34),
                                                          color: homeProvider
                                                              .hexToColor(item
                                                                  .colorCode!),
                                                        ),
                                                        Container(
                                                          height: AppHeight(34),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      AppWidth(
                                                                          8),
                                                                  left:
                                                                      AppWidth(
                                                                          8)),
                                                          width: AppWidth(34),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: context
                                                                    .resources
                                                                    .color
                                                                    .colorLightGrey,
                                                                width: .5),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (item.media ==
                                                                  1) {
                                                                AppUtils.showPhotoDialog(
                                                                    context,
                                                                    item.enRaisedBy
                                                                        .toString(),
                                                                    '${ApiUrl.baseUrl}${item.fileName}');
                                                              }
                                                            },
                                                            child: CircleAvatar(
                                                              radius:
                                                                  minDimension /
                                                                      2,
                                                              backgroundColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorLightGrey
                                                                  .withOpacity(
                                                                      .5),
                                                              child: item.media ==
                                                                      0
                                                                  ? CommonTextView(
                                                                      label: item
                                                                          .fileName!,
                                                                      fontSize: context
                                                                          .resources
                                                                          .dimension
                                                                          .appBigText,
                                                                      color: context
                                                                          .resources
                                                                          .color
                                                                          .themeColor,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${ApiUrl.baseUrl}${item.fileName}',
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        height:
                                                                            AppHeight(34),
                                                                        width: AppWidth(
                                                                            34),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              progress) =>
                                                                          SizedBox(
                                                                        width:
                                                                            10.0,
                                                                        height:
                                                                            10.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value:
                                                                              progress.progress,
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor,
                                                                          strokeWidth:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context, url, error) => CommonTextView(
                                                                          label: item
                                                                              .fileName!,
                                                                          fontSize: context
                                                                              .resources
                                                                              .dimension
                                                                              .appBigText,
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonTextView(
                                                              label: item
                                                                  .enRaisedBy!,
                                                              width:
                                                                  AppWidth(225),
                                                              fontSize:
                                                                  appTextSize(
                                                                      13),
                                                              maxLine: 1,
                                                              overFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              padding: EdgeInsets.only(
                                                                  bottom:
                                                                      AppHeight(
                                                                          2)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  AppWidth(225),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                alignment: Global
                                                                        .isArabic
                                                                    ? Alignment
                                                                        .centerRight
                                                                    : Alignment
                                                                        .centerLeft,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    CommonTextView(
                                                                      label:
                                                                          '${item.enTxnFor!}(${item.enNtfId!})',
                                                                      fontSize:
                                                                          appTextSize(
                                                                              11),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: AppHeight(
                                                                            2),
                                                                        right: Global.isArabic
                                                                            ? 0
                                                                            : AppWidth(7),
                                                                        left: Global.isArabic
                                                                            ? AppWidth(7)
                                                                            : 0,
                                                                      ),
                                                                      color: context
                                                                          .resources
                                                                          .color
                                                                          .themeColor,
                                                                      overFlow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    // homeProvider.getNotificationIcon(item.notificationStatus!,context.resources.color.colorBlack),
                                                                    homeProvider.getSvgPicture(
                                                                        context,
                                                                        item
                                                                            .notificationStatus!,
                                                                        context
                                                                            .resources
                                                                            .color
                                                                            .colorBlack),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CommonTextView(
                                                          label: item.enCrDt!,
                                                          fontSize:
                                                              appTextSize(12),
                                                          maxLine: 1,
                                                          overFlow: TextOverflow
                                                              .ellipsis,
                                                          // margin: EdgeInsets.only(left: Global.isArabic ? 0 : AppWidth(2), right: Global.isArabic ? AppWidth(2) : 0),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/images/erp_app_icon/calendar.svg',
                                                              height:
                                                                  AppHeight(13),
                                                            ),
                                                            CommonTextView(
                                                              label: item
                                                                  .humanAgo!,
                                                              fontSize:
                                                                  appTextSize(
                                                                      13),
                                                              margin: EdgeInsets.only(
                                                                  left: Global
                                                                          .isArabic
                                                                      ? 0
                                                                      : AppWidth(
                                                                          2),
                                                                  right: Global
                                                                          .isArabic
                                                                      ? AppWidth(
                                                                          2)
                                                                      : 0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: AppHeight(6),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: AppWidth(385),
                                                      padding: EdgeInsets.only(
                                                          left: Global.isArabic
                                                              ? 0
                                                              : AppWidth(12),
                                                          right: Global.isArabic
                                                              ? AppWidth(12)
                                                              : 0),
                                                      child: ReadMoreText(
                                                        item.enSubject!,
                                                        trimLines: 3,
                                                        style: TextStyle(
                                                            fontSize:
                                                                appTextSize(13),
                                                            fontFamily:
                                                                'Regular'),
                                                        trimMode: TrimMode.Line,
                                                        moreStyle: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily: 'Bold',
                                                          color: context
                                                              .resources
                                                              .color
                                                              .themeColor,
                                                        ),
                                                        lessStyle: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily:
                                                              'BoldItalic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: context
                                                              .resources
                                                              .color
                                                              .themeColor,
                                                        ),
                                                        trimCollapsedText:
                                                            'Show More',
                                                        trimExpandedText:
                                                            ' Show Less',
                                                      ),
                                                    ),
                                                    // Container(
                                                    //     height:AppHeight(25),
                                                    //     width:AppWidth(10),
                                                    //     margin: EdgeInsets.only(right: Global.isArabic ? AppWidth(7) :AppWidth(11),left: Global.isArabic ? AppWidth(11) :AppWidth(7)),
                                                    //     decoration: DottedDecoration(
                                                    //       shape: Shape.box,
                                                    //       color: Colors.black,
                                                    //       strokeWidth: 0.5,
                                                    //       dash: const [1,1],
                                                    //       // borderRadius: BorderRadius.circular(AppHeight(25)*.05),
                                                    //     ),
                                                    //     child: const Icon(Icons.more_vert,size: 10,),
                                                    // ),
                                                    SvgPicture.asset(
                                                      'assets/images/erp_app_icon/menu.svg',
                                                      height: AppHeight(25),
                                                      width: AppWidth(10),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: AppHeight(6),
                                                  margin: EdgeInsets.only(
                                                      right: AppWidth(6),
                                                      left: AppWidth(6),
                                                      top: AppHeight(10),
                                                      bottom: AppHeight(10)),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: context
                                                            .resources
                                                            .color
                                                            .colorLightGrey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
      );
    },
  );
}

class EmptyListWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const EmptyListWidget({
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SvgPicture.asset(
            'assets/images/erp_app_icon/notification_watermark.svg',
            height: AppHeight(209),
          )),
          CommonTextView(
            label: 'No notification yet',
            fontSize: context.resources.dimension.appMediumText,
            margin: EdgeInsets.only(
              top: AppHeight(26),
              bottom: AppHeight(126),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTextView(
                  label: 'Reload this Page',
                  fontSize: context.resources.dimension.appBigText,
                  fontFamily: 'Bold',
                  color: context.resources.color.themeColor,
                  margin: EdgeInsets.only(
                    right: Global.isArabic ? 0 : AppWidth(5),
                    left: Global.isArabic ? AppWidth(5) : 0,
                  ),
                ),
                Icon(
                  Icons.refresh,
                  size: 20,
                  color: context.resources.color.themeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTabs extends StatefulWidget {
  final String? text;
  final String? label;
  final bool isNeedColorChange;

  const MyTabs({
    super.key,
    this.text,
    this.label,
    required this.isNeedColorChange,
  });

  @override
  State<MyTabs> createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: AppHeight(15), right: AppWidth(35 / 2), left: AppWidth(35 / 2)),
      height: AppHeight(75),
      child: Column(
        children: [
          CommonTextView(
            label: widget.text!,
            fontSize: context.resources.dimension.appExtraBigText,
            //extra big text
            fontFamily: 'BlackItalic',
            color: widget.isNeedColorChange
                ? context.resources.color.themeColor
                : context.resources.color.themeColor.withOpacity(.5),
            // fontWeight: FontWeight.bold,
          ),
          CommonTextView(
            label: widget.label!,
            fontSize: context.resources.dimension.appMediumText,
            fontWeight: FontWeight.bold,
            color: widget.isNeedColorChange
                ? context.resources.color.themeColor
                : context.resources.color.themeColor.withOpacity(.5),
          )
        ],
      ),
    );
  }
}
