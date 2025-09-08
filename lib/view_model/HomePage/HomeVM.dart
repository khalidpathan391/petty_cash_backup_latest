// ignore_for_file: unused_import, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardFilterModel.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardModel.dart';
import 'package:petty_cash/data/models/HomePage/DashBoardTabModel.dart';
import 'package:petty_cash/data/models/HomePage/MenuResponse.dart';
import 'package:petty_cash/data/models/HomePage/dash_board_condition_model.dart';
import 'package:petty_cash/data/models/HomePage/dash_board_multi_filter_model.dart';
import 'package:petty_cash/data/models/HomePage/dash_board_setting_model.dart';
import 'package:petty_cash/data/models/HomePage/dash_board_update_model.dart';
import 'package:petty_cash/data/models/custom/chartdata.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/po_transaction/transaction_page/po_transaction.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeVM extends ChangeNotifier {
  final _myRepo = GeneralRepository();

  bool isLoading = false;

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  late PagingController<int, NotificationLst> pagingController;
  late RefreshController refreshController;
  late TextEditingController searchController;
  late dynamic filteredSearchList;

  //Constructor for all the pagination calling
  HomeVM() {
    searchController = TextEditingController();
    searchController.text = '';
    pageIndex = 0;
    tabVal = 'pending';
    tabDataType = 'static';
    pagingController = PagingController(firstPageKey: 0);
    refreshController = RefreshController(initialRefresh: false);
    getDashBoardTabApi();
    pagingController.addPageRequestListener((pageKey) {
      // set pageIndex as pageKey if they are in case diff.
      pageIndex = pageKey;
      callDashBoardApi();
    });
  }

  //Dash Board Tab
  Map getDashBoardTabData() {
    Map data = {
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
    };
    return data;
  }

  DashBoardTabModel? dashBoardTabData;
  List<NotificationTabList> notificationTabListData = [];

  bool tabLoading = false;

  void setTabLoading(bool val) {
    tabLoading = val;
    notifyListeners();
  }

  Future<void> getDashBoardTabApi() async {
    tabLoading = true;
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardTab, getDashBoardTabData())
        .then((value) {
      dashBoardTabData = DashBoardTabModel.fromJson(value);
      notificationTabListData = dashBoardTabData!.notificationTabList!;
      notificationTabListData[previousIndex].isSelected = true;
      pagingController.refresh();
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
      //AppUtils.showToastRedBg(context, error.toString().tr());
    }).whenComplete(() {
      tabLoading = false;
      notifyListeners();
    });
  }

  // All the one time static value that will change when u click on the tabs
  String tabVal = 'pending';
  String tabDataType = 'static';
  int pageIndex = 0;

  //set start at 0 as start index is 0
  int previousIndex = 0;
  bool isTabDisable = false;

  // Function to load data and handle pagination
  void loadData(int? index) {
    isTabDisable = true;
    pageIndex = 0;
    // change color of selected tab
    notificationTabListData[index!].isSelected = true;
    //making old index unselected if condition to make sure if double clicked then it shouldn't get unselected
    if (index != previousIndex) {
      notificationTabListData[previousIndex].isSelected = false;
    }
    previousIndex = index;
    pagingController.refresh();
  }

  //Dash Board
  Map getDashBoardData() {
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
      'start': pageIndex.toString(),
      'mobile_app_id': Global.mobileId,
    };
    return data;
  }

  void callPullToRefresh() {
    isPullToRefresh = true;
    pageIndex = 0;
    loadData(previousIndex);
    notifyListeners();
  }

  List<ModulesLst> modulesList = [];
  List<CompanyLst> companyList = [];
  bool isPullToRefresh = false;

  Future<void> callDashBoardApi() async {
    try {
      final value = await _myRepo.postApi(
          '${ApiUrl.baseUrl}${ApiUrl.dashBoard}', getDashBoardData());
      DashBoardModel dashBoardData = DashBoardModel.fromJson(value);
      if (AppUtils.errorMessage.isEmpty) {
        if (dashBoardData.notificationLst!.length < 15) {
          pagingController.appendLastPage(dashBoardData.notificationLst!);
        } else {
          final nextPageKey = pageIndex + dashBoardData.notificationLst!.length;
          if (nextPageKey == dashBoardData.totalData) {
            pagingController.appendLastPage(dashBoardData.notificationLst!);
          } else {
            pagingController.appendPage(
                dashBoardData.notificationLst!, nextPageKey);
          }
        }
      }
    } catch (e) {
      // print(e.toString());
      pagingController.error = e;
    } finally {
      isPullToRefresh = false;
      isTabDisable = false;
      notifyListeners();
    }
  }

  void callNextPage(BuildContext context, NotificationLst item) {
    try {
      var data = Menu(
          id: getMenuId(item.enRedirectUrl.toString()),
          title: '',
          url: '',
          parentId: 0,
          txnType: item.enTxnCode.toString(),
          txnCode: item.enTxnCode.toString(),
          parameter: '',
          userId: '',
          companyId: 0,
          displayMobileApp: 0,
          pageTypeId: 0,
          pageTypeCode: '',
          pageTypeDesc: '',
          menuIcon: '',
          child: [],
          isShowing: false,
          filterTypeVal: '',
          filterTypeCode: '');
      Global.menuData = data;
      // Navigator.pushNamed(context, Global.menuData!.txnType,
      //         arguments: item.transactionId)
      //     .then((value) {});
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => PoTransaction(item)))
          .then((value) {
        refreshView();
      });
    } catch (e) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PoTransaction(item))).then((value) {
      //   refreshView();
      // });
    }
  }

// for getting color from string api
  Color hexToColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // for circular avatar
  double minDimension =
      AppHeight(34) < AppWidth(34) ? AppHeight(34) : AppWidth(34);

  // for diff. icons according to one variable
  Icon getNotificationIcon(dynamic notificationValue, Color color) {
    final Map<dynamic, IconData> iconMap = {
      1: Icons.more_time_rounded,
      4: Icons.turn_slight_left_sharp,
      5: Icons.access_time,
      10: Icons.info_outline,
      'someStringValue': Icons.abc,
    };
    IconData iconData = iconMap[notificationValue] ?? Icons.more_time_rounded;
    return Icon(
      iconData,
      size: 15,
      color: color,
    );
  }

  // get different svg images for 1 variable value
  SvgPicture getSvgPicture(BuildContext context, dynamic value, Color? color) {
    final Map<dynamic, String> svgMap = {
      1: 'assets/images/erp_app_icon/pending.svg',
      2: 'assets/images/erp_app_icon/reply.svg',
    };
    String svgIcon = svgMap[value] ?? 'assets/images/erp_app_icon/pending.svg';
    return SvgPicture.asset(
      svgIcon,
      height: AppHeight(10),
      color: color,
    );
  }

  //Filter Api

  Map<String, String> getFilterParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'device_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'time_zone': 'Asia/Riyadh',
      'timezone': 'Asia/Riyadh',
      'sort_by_key': '',
      'sort_by_val': '',
      'filter_by_key': '',
      'filter_by_type': '',
      'filter_by_one': '',
      'filter_by_two': '',
      'search_val': '',
    };
    return data;
  }

  DashBoardFilterModel? dashBoardFilterData;
  List<SortTypeList> sortListData = [];

// List<FilterDataLst> filterListData = [];
  String myFilterKey = '';
  String myFilterVal = '';

  Future<void> callFilterApi() async {
    setLoading(true);
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardFilter, getFilterParam())
        .then((value) {
      dashBoardFilterData = DashBoardFilterModel.fromJson(value);
      sortListData = dashBoardFilterData!.sortTypeList!;
      // filterListData = dashBoardFilterData.filterDataLst!;
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void setSelected(int index, int type) {
    if (type == 0) {
      if (sortListData[index].isDescSelected!) {
        sortListData[index].isAscSelected = true;
        sortListData[index].isDescSelected = false;
      } else {
        sortListData[index].isAscSelected =
            !(sortListData[index].isAscSelected!);
        sortListData[index].isChecked = !(sortListData[index].isChecked!);
      }
    } else {
      if (sortListData[index].isAscSelected!) {
        sortListData[index].isAscSelected = false;
        sortListData[index].isDescSelected = true;
      } else {
        sortListData[index].isDescSelected =
            !(sortListData[index].isDescSelected!);
        sortListData[index].isChecked = !(sortListData[index].isChecked!);
      }
    }
    notifyListeners();
  }

  void setKeyVal() {
    myFilterKey = '';
    myFilterVal = '';
    for (int i = 0; i < sortListData.length; i++) {
      if (sortListData[i].isAscSelected!) {
        myFilterKey += '${sortListData[i].code},';
        myFilterVal += 'asc,';
      }
      if (sortListData[i].isDescSelected!) {
        myFilterKey += '${sortListData[i].code},';
        myFilterVal += 'desc,';
      }
    }
  }

  Map<String, String> getFilterApplyParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'device_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'time_zone': 'Asia/Riyadh',
      'timezone': 'Asia/Riyadh',
      'sort_filter': filterJsonData,
      'search_val': '',
      'tab_data_type': 'static',
    };
    return data;
  }

  bool isApply = false;
  String filterJsonData = '';

  void setApply(bool val) {
    isApply = val;
    notifyListeners();
  }

  Future<void> callFilterApplyApi(BuildContext context) async {
    setApply(true);
    // setKeyVal();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardFilterApply,
            getFilterApplyParam())
        .then((value) {
      // dashBoardFilterData = DashBoardFilterModel.fromJson(value);
      // sortListData = dashBoardFilterData!.sortTypeList!;
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      notifyListeners();
    });
  }

  void setOnChangeValue(String query, int index) {
    dashBoardFilterData!.filterDataLst![index].filterByValue = query;
    notifyListeners();
  }

  void setOnBetweenValue(String query, int index, int i) {
    dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].betweenVal =
        query;
    notifyListeners();
  }

  void setFilterSelected(int index, int j, String type) {
    for (int i = 0;
        i < dashBoardFilterData!.filterDataLst![index].filterTypeLst!.length;
        i++) {
      if (i != j) {
        dashBoardFilterData!
            .filterDataLst![index].filterTypeLst![i].isSelected = false;
      } else {
        dashBoardFilterData!
                .filterDataLst![index].filterTypeLst![j].isSelected =
            !(dashBoardFilterData!
                .filterDataLst![index].filterTypeLst![j].isSelected!);
      }
    }
    notifyListeners();
  }

  void setFilterDate(int index, dynamic date) {
    dashBoardFilterData!.filterDataLst![index].filterByDate = '';
    dashBoardFilterData!.filterDataLst![index].filterByDate = date.toString();
    notifyListeners();
  }

  void setFilterJsonData(BuildContext context) {
    filterJsonData = jsonEncode(dashBoardFilterData);
    print(filterJsonData);
    callFilterApplyApi(context);
  }

//Setting Home

  bool isPriority = true;
  bool isFYIClear = false;
  bool isNotification = false;
  bool isNotificationTick = false;

  void setPriority() {
    isPriority = true;
    isFYIClear = false;
    isNotification = false;
    notifyListeners();
  }

  void setFYIClear() {
    isPriority = false;
    isFYIClear = true;
    isNotification = false;
    notifyListeners();
  }

  void setNotification() {
    isPriority = false;
    isFYIClear = false;
    isNotification = true;
    notifyListeners();
  }

  void setNotificationTick(bool val) {
    isNotificationTick = val;
    notifyListeners();
  }

  Map<String, String> getSettingParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'is_view': '1', //0 when sending below params
      'priority_id': '',
      'line_id': '',
      'min': '',
      'max': '',
      'color_code': '',
    };
    return data;
  }

  DashBoardSettingModel? dashBoardSettingData;

  Future<void> callSettingPriorityApi() async {
    isLoading = true;
    setPriority();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardSetting, getSettingParam())
        .then((value) {
      if (value['error_code'] == 200) {
        dashBoardSettingData = DashBoardSettingModel.fromJson(value);
        isNotificationTick = dashBoardSettingData!.enableDisableCheckBox!;
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  Color getPriorityColor(String myColor) {
    if (myColor.startsWith('#')) {
      myColor = myColor.substring(1);
    }
    Color color = Color(int.parse("0xFF$myColor"));
    return color;
  }

  void setMinChange(String val, int index) {
    dashBoardSettingData!.priority![index].min = int.parse(val);
    notifyListeners();
  }

  void setMaxChange(String val, int index) {
    dashBoardSettingData!.priority![index].max = int.parse(val);
    notifyListeners();
  }

  void getColorInString(Color color, int index) {
    String colorHex = color.toString().substring(8, 16);
    dashBoardSettingData!.priority![index].color = colorHex;
    notifyListeners();
  }

  String priorityId = '';
  String min = '';
  String lineId = '';
  String max = '';
  String colorCode = '';

  void settingApplyParams() {
    priorityId = '';
    min = '';
    lineId = '';
    max = '';
    colorCode = '';
    for (int i = 0; i < dashBoardSettingData!.priority!.length; i++) {
      priorityId += '${dashBoardSettingData!.priority![i].priorityId},';
      min += '${dashBoardSettingData!.priority![i].min},';
      if (dashBoardSettingData!.priority![i].lineId != 0) {
        lineId += '${dashBoardSettingData!.priority![i].lineId},';
      }
      max += '${dashBoardSettingData!.priority![i].max},';
      colorCode += '${dashBoardSettingData!.priority![i].color},';
    }
    //removing comma from last element
    priorityId = priorityId.substring(0, priorityId.length - 1);
    min = min.substring(0, min.length - 1);
    if (lineId.isNotEmpty) {
      lineId = lineId.substring(0, lineId.length - 1);
    }
    max = max.substring(0, max.length - 1);
    colorCode = colorCode.substring(0, colorCode.length - 1);
  }

  Map<String, String> getSettingApplyParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'is_view': '0', //0 when sending below params
      'priority_id': priorityId,
      'line_id': lineId,
      'min': min,
      'max': max,
      'color_code': colorCode,
    };
    return data;
  }

  Future<void> callSettingPriorityApplyApi(BuildContext context) async {
    setApply(true);
    settingApplyParams();
    _myRepo
        .postApi(
            ApiUrl.baseUrl! + ApiUrl.dashBoardSetting, getSettingApplyParam())
        .then((value) {
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      notifyListeners();
    });
  }

  Map<String, String> getSettingFYIClearApplyParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
    };
    return data;
  }

  Future<void> callSettingFYIClearApplyApi(BuildContext context) async {
    setApply(true);
    settingApplyParams();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardSettingFYIClear,
            getSettingFYIClearApplyParam())
        .then((value) {
      Navigator.pop(context);
      AppUtils.showToastGreenBg(context, value['msg'].toString());
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      notifyListeners();
    });
  }

  Map<String, String> getSettingNotificationApplyParam() {
    Map<String, String> data = {
      'enable_disable_not_val': isNotificationTick ? 'True' : 'False',
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
    };
    return data;
  }

  Future<void> callSettingNotificationApplyApi(BuildContext context) async {
    setApply(true);
    settingApplyParams();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardSettingNotification,
            getSettingNotificationApplyParam())
        .then((value) {
      Navigator.pop(context);
      AppUtils.showToastGreenBg(
          context, value['notification_enable_disable'][0]['msg'].toString());
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      notifyListeners();
    });
  }

  Map<String, String> getMultiFilterParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
    };
    return data;
  }

  DashBoardMultiFilterModel? multiFilterData;

  Future<void> callMultiFilterListApi() async {
    setLoading(true);
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilter,
            getMultiFilterParam())
        .then((value) {
      if (value['error_code'] == 200) {
        multiFilterData = DashBoardMultiFilterModel.fromJson(value);
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  List<String> ruleIdList = [];

  void setMultiFilterSelected(int index, String id) {
    multiFilterData!.rulesList![index].isSelected =
        !(multiFilterData!.rulesList![index].isSelected!);
    if (multiFilterData!.rulesList![index].isSelected!) {
      ruleIdList.add(id);
    } else {
      ruleIdList.remove(id);
    }
    notifyListeners();
  }

  TextEditingController? ruleTypeController = TextEditingController();
  String ruleName = '';
  String ruleId = '';

  void setRuleName(String val) {
    ruleName = val;
    notifyListeners();
  }

  bool allNotification = true;
  bool newNotification = false;

  void setRulesNewNotification() {
    allNotification = false;
    newNotification = true;
    notifyListeners();
  }

  void setRulesAllNotification() {
    allNotification = true;
    newNotification = false;
    notifyListeners();
  }

  String searchListKey = '';

  void searchList(String query) {
    if (searchListKey == 'Condition') {
      filteredSearchList = conditionList
          .where((item) => item.showvalue
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    if (searchListKey == 'Txn') {
      filteredSearchList = txnListData
          .where((item) => item.showvalue
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    if (searchListKey == 'User') {
      filteredSearchList = userListData
          .where((item) => item.showval
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    if (searchListKey == 'Notification') {
      filteredSearchList = notificationListData
          .where((item) => item.showval
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Map<String, String> getMultiFilterConditionParam() {
    Map<String, String> data = {
      'lookup_code': 'CONDITIONAL_CODE',
      'search_val': '',
      'primaryId': '0',
    };
    return data;
  }

  DashBoardConditionalModel? conditionData;
  List<CommonSearchList> conditionList = [];
  String conditionType = '';
  String conditionCode = '';
  int conditionId = 0;

  Future<void> callMultiFilterConditionApi() async {
    setLoading(true);
    searchListKey = 'Condition';
    conditionType = '';
    setDefaultOnSearchPop();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterCondition,
            getMultiFilterConditionParam())
        .then((value) {
      if (value['error_code'] == 200) {
        conditionData = DashBoardConditionalModel.fromJson(value);
        conditionList = conditionData!.commonSearchList!;
        filteredSearchList = conditionList;
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void setDefaultOnSearchPop() {
    searchController = TextEditingController();
    searchController.text = '';
    notifyListeners();
  }

  void setConditionType(String val, int id, String code) {
    conditionType = val;
    conditionCode = code;
    conditionId = id;
    notifyListeners();
  }

  TextEditingController? subjectTypeController = TextEditingController();
  String subjectWith = '';

  void setSubjectWith(String val) {
    subjectWith = val;
    notifyListeners();
  }

  Map<String, String> getMultiFilterTxnParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'primary_ids': conditionId.toString(),
      'search_string': '',
    };
    return data;
  }

  DashBoardConditionalModel? txnData;
  List<CommonSearchList> txnListData = [];
  List<ChartData> txnSelectedData = [];

  Future<void> callMultiFilterTxnApi() async {
    setLoading(true);
    searchListKey = 'Txn';
    setDefaultOnSearchPop();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterTransaction,
            getMultiFilterTxnParam())
        .then((value) {
      if (value['error_code'] == 200) {
        txnData = DashBoardConditionalModel.fromJson(value);
        txnListData = txnData!.commonSearchList!;
        filteredSearchList = txnListData;
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void addTxnType(String val, int id) {
    txnSelectedData.add(ChartData(x: val, y: id, chartList: []));
    notifyListeners();
  }

  void removeTxnType(dynamic data) {
    txnSelectedData.remove(data);
    notifyListeners();
  }

  Map<String, String> getMultiFilterUserParam() {
    Map<String, String> data = {
      'primary_id': conditionId.toString(),
      'emp_code': '',
    };
    return data;
  }

  DashBoardConditionalModel? userData;
  List<CommonSearchList> userListData = [];
  List<ChartData> userSelectedData = [];

  Future<void> callMultiFilterUserApi() async {
    setLoading(true);
    searchListKey = 'User';
    setDefaultOnSearchPop();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterUser,
            getMultiFilterUserParam())
        .then((value) {
      if (value['error_code'] == 200) {
        userData = DashBoardConditionalModel.fromJson(value);
        userListData = userData!.commonSearchList!;
        filteredSearchList = userListData;
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void addUserType(String val, int id) {
    userSelectedData.add(ChartData(x: val, y: id, chartList: []));
    notifyListeners();
  }

  void removeUserType(dynamic data) {
    userSelectedData.remove(data);
    notifyListeners();
  }

  Map<String, String> getMultiFilterNotificationParam() {
    Map<String, String> data = {
      'notification_type': '',
    };
    return data;
  }

  DashBoardConditionalModel? notificationData;
  List<CommonSearchList> notificationListData = [];
  List<ChartData> notificationSelectedData = [];

  Future<void> callMultiFilterNotificationApi() async {
    setLoading(true);
    searchListKey = 'Notification';
    setDefaultOnSearchPop();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterNotification,
            getMultiFilterNotificationParam())
        .then((value) {
      if (value['error_code'] == 200) {
        notificationData = DashBoardConditionalModel.fromJson(value);
        notificationListData = notificationData!.commonSearchList!;
        filteredSearchList = notificationListData;
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  String selectedNotification = '';

  void addNotificationType(String val, int id, String desc) {
    if (desc == 'All') {
      notificationSelectedData.clear();
      selectedNotification = desc;
    }
    notificationSelectedData.add(ChartData(x: desc, y: id, chartList: []));
    notifyListeners();
  }

  void removeNotificationType(dynamic data) {
    notificationSelectedData.remove(data);
    if (selectedNotification == 'All') {
      selectedNotification = '';
    }
    notifyListeners();
  }

  String notificationIds = '';
  String userIds = '';
  String txnIds = '';

  void setAddRulesParams() {
    notificationIds = '';
    userIds = '';
    txnIds = '';
    if (userSelectedData.isNotEmpty) {
      for (int i = 0; i < userSelectedData.length; i++) {
        userIds += '${userSelectedData[i].y},';
      }
      //removing comma from last place
      userIds = userIds.substring(0, userIds.length - 1);
    }
    if (txnSelectedData.isNotEmpty) {
      for (int i = 0; i < txnSelectedData.length; i++) {
        txnIds += '${txnSelectedData[i].y},';
      }
      //removing comma from last place
      txnIds = txnIds.substring(0, txnIds.length - 1);
    }
    if (notificationSelectedData.isNotEmpty) {
      for (int i = 0; i < notificationSelectedData.length; i++) {
        notificationIds += '${notificationSelectedData[i].y},';
      }
      //removing comma from last place
      notificationIds =
          notificationIds.substring(0, notificationIds.length - 1);
    }
  }

  void setDefaultOnAddRulesPop() {
    searchController = TextEditingController();
    searchController.text = '';
    ruleTypeController = TextEditingController();
    ruleTypeController!.text = '';
    subjectTypeController = TextEditingController();
    subjectTypeController!.text = '';
    conditionType = '';
    searchListKey = '';
    ruleName = '';
    subjectWith = '';
    notificationSelectedData = [];
    userSelectedData = [];
    txnSelectedData = [];
    updatePage = '';
    selectedNotification = '';
    setRulesAllNotification();
  }

  Map<String, String> getMultiFilterAddParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      // 'company_id': '2',//Global.empData!.companyId.toString(),
      // 'user_id': '3',//Global.empData!.userId.toString(),
      // 'authentication_id': '101431',//Global.empData!.id.toString(),
      // 'valid_key': 'MTAYODQ',//Global.empData!.key.toString(),
      // 'mobile_id': 'b40a250fce404f01',//Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'rule_name': ruleName,
      'condition_notification': allNotification ? '0' : '1',
      'conditional_code': conditionCode,
      'conditional_id': conditionId.toString(),
      'sub_code': subjectWith,
      'notification_type_ids': notificationIds,
      'hidden_txn_ids': txnIds,
      'hidden_user_ids': userIds,
    };
    return data;
  }

  void checkAndAddRule(BuildContext context) {
    if (ruleName.isEmpty) {
      AppUtils.showToastRedBg(context, 'Please Enter Name');
    } else if (conditionType.isEmpty) {
      AppUtils.showToastRedBg(context, 'Please Select Condition');
    } else if (subjectWith.isEmpty && conditionCode == 'SUBJECT') {
      AppUtils.showToastRedBg(context, 'Please Enter Subject');
    } else if (txnSelectedData.isEmpty && conditionCode == 'TXN') {
      AppUtils.showToastRedBg(context, 'Please Select TXN');
    } else if (userSelectedData.isEmpty && conditionCode == 'USER') {
      AppUtils.showToastRedBg(context, 'Please Select User');
    } else if (notificationSelectedData.isEmpty) {
      AppUtils.showToastRedBg(context, 'Please Select Notification Type');
    } else {
      callMultiFilterAddApi(context);
    }
  }

  Future<void> callMultiFilterAddApi(BuildContext context) async {
    setApply(true);
    setAddRulesParams();
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterAdd,
            getMultiFilterAddParam())
        .then((value) {
      if (value['error_code'] == 200) {
        AppUtils.showToastGreenBg(
            context, value['error_description'].toString());
      }
      if (value['error_code'] == 100) {
        AppUtils.showToastRedBg(context, value['error_description'].toString());
      }
      Navigator.pop(context);
      callMultiFilterListApi();
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      notifyListeners();
    });
  }

  Map<String, String> getMultiFilterDeleteParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      // 'company_id': '2',//Global.empData!.companyId.toString(),
      // 'user_id': '3',//Global.empData!.userId.toString(),
      // 'authentication_id': '101431',//Global.empData!.id.toString(),
      // 'valid_key': 'MTAYODQ',//Global.empData!.key.toString(),
      // 'mobile_id': 'b40a250fce404f01',//Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      //removing the brackets of the list and directly sending as string so from 1 to the last-1 we are concatenating it
      //there by reducing 1 for loop to get and store elements as string
      'primary_ids':
          ruleIdList.toString().substring(1, ruleIdList.toString().length - 1),
    };
    return data;
  }

  Future<void> callMultiFilterDeleteApi(BuildContext context) async {
    setApply(true);
    if (ruleIdList.isEmpty) {
      AppUtils.showToastRedBg(context, 'No Rule Selected');
      setApply(false);
    } else {
      _myRepo
          .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterDelete,
              getMultiFilterDeleteParam())
          .then((value) {
        if (value['error_code'] == 200) {
          AppUtils.showToastGreenBg(
              context, value['error_description'].toString());
        }
        if (value['error_code'] == 100) {
          AppUtils.showToastRedBg(
              context, value['error_description'].toString());
        }
        callMultiFilterListApi();
        ruleIdList = [];
      }).onError((error, stackTrace) {
        if (AppUtils.errorMessage.isEmpty) {
          AppUtils.errorMessage = error.toString();
        }
      }).whenComplete(() {
        isApply = false;
        notifyListeners();
      });
    }
  }

  Map<String, String> getMultiFilterUpdateParam() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'authentication_id': Global.empData!.id.toString(),
      'valid_key': Global.empData!.key.toString(),
      'mobile_id': Global.mobileId.toString(),
      // 'company_id': '2',//Global.empData!.companyId.toString(),
      // 'user_id': '3',//Global.empData!.userId.toString(),
      // 'authentication_id': '101431',//Global.empData!.id.toString(),
      // 'valid_key': 'MTAYODQ',//Global.empData!.key.toString(),
      // 'mobile_id': 'b40a250fce404f01',//Global.mobileId.toString(),
      'mobile_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'is_view': isView.toString(), //0 when updating
      'line_rule_id': ruleId,
      'select_rule_id': allNotification ? '0' : '1',
      'condition_id': conditionId.toString(),
      'txn_ids': txnIds,
      'user_ids': userIds,
      'subject_code': subjectWith,
      'notification_type_ids': notificationIds,
    };
    return data;
  }

  int isView = 1;
  int myRuleIndex = 0;
  DashBoardUpdateModel? updateData;
  List<int> userId = [];
  List<String> userCode = [];
  List<int> notificationId = [];
  List<String> notificationCode = [];
  List<int> txnId = [];
  List<String> txnCode = [];
  String updatePage = '';

  Future<void> callMultiFilterUpdateApi(
      BuildContext context, int index, int type) async {
    isView = type;
    ruleId = multiFilterData!.rulesList![index].ruleId.toString();
    myRuleIndex = index;
    if (type == 1) {
      setLoading(true);
    }
    if (type == 0) {
      setAddRulesParams();
      setApply(true);
    }
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.dashBoardMultiFilterUpdate,
            getMultiFilterUpdateParam())
        .then((value) {
      updatePage = 'yes';
      if (type == 1) {
        updateData = DashBoardUpdateModel.fromJson(value);
        userId = updateData!.runRules!.userId!;
        userCode = updateData!.runRules!.userCode!;
        notificationId = updateData!.runRules!.notificationTypeId!;
        notificationCode = updateData!.runRules!.notificationTypeCode!;
        txnId = updateData!.runRules!.txnsId!;
        txnCode = updateData!.runRules!.txnsCode!;
        ruleName = updateData!.runRules!.ruleName!;
        ruleTypeController!.text = ruleName;
        updateData!.runRules!.selectRuleToRunId == 0
            ? setRulesAllNotification()
            : setRulesNewNotification();
        conditionId = updateData!.runRules!.conditionId!;
        if (updateData!.runRules!.conditionCode == 'SUBJECT-Subject') {
          conditionType = 'SUBJECT - Subject';
          subjectWith = updateData!.runRules!.subjectCode!;
          subjectTypeController!.text = subjectWith;
        }
        if (updateData!.runRules!.conditionCode == 'USER-User') {
          conditionType = 'USER - User';
          for (int i = 0; i < userId.length; i++) {
            userSelectedData
                .add(ChartData(x: userCode[i], y: userId[i], chartList: []));
          }
        }
        if (updateData!.runRules!.conditionCode == 'TXN-Txn') {
          conditionType = 'TXN - Txn';
          for (int i = 0; i < txnId.length; i++) {
            txnSelectedData
                .add(ChartData(x: txnCode[i], y: txnId[i], chartList: []));
          }
        }
        for (int i = 0; i < notificationId.length; i++) {
          notificationSelectedData.add(ChartData(
              x: notificationCode[i], y: notificationId[i], chartList: []));
        }
      }
      if (type == 0) {
        callMultiFilterListApi();
        updatePage = '';
        Navigator.pop(context);
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
    }).whenComplete(() {
      isApply = false;
      isLoading = false;
      notifyListeners();
    });
  }

  int getMenuId(String url) {
    Map<String, String> queryParams = Uri.parse(url).queryParameters;
    String? mid = queryParams['mid'];
    return int.parse(mid.toString());
  }

  void refreshView() {}
}
