import 'package:flutter/material.dart';

import 'package:petty_cash/data/models/Authentication/AuthenticationModel.dart';
import 'package:petty_cash/data/models/Authentication/CompanySelectingModel.dart';

import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/data/sources/local/shared_preference.dart';

import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/HomeScreen.dart';
import 'package:petty_cash/view/login/ActivateQRCode.dart';
import 'package:petty_cash/view/login/LoginScreen.dart';

import 'package:petty_cash/view_model/CommonProvider.dart';
import 'package:provider/provider.dart';

CommonVM commonProvider = CommonVM();

class AuthVM extends ChangeNotifier {
  //Constructor so where ever we initialize it then all the default value should be made
  AuthVM() {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    passwordController.addListener(_updateButtonState);
  }

  final _myRepo = GeneralRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  String baseUrl = '';

  Future<void> callGenerateQRCodeAPI(BuildContext context, dynamic data) async {
    setLoading(true);
    baseUrl = data['base_url'];
    _myRepo.postApi(baseUrl + ApiUrl.qrGenerating, data).then((value) {
      AuthenticationModel authData = AuthenticationModel.fromJson(value);
      if (authData.errorCode == 100) {
        AppUtils.showToastRedBg(context, authData.errorDescription.toString());
      } else {
        EmpData data = authData.empData!;
        if (authData.errorCode == 201) {
          data.isLoggedIn = true;
        } else {
          data.isLoggedIn = false;
        }
        saveEmpData(data);
        setdisable(true);
        // Navigator.pushNamed(context, ActivateQRCode.id);
        callNextPage(context, authData.errorCode!);
      }
      setLoading(false);
      setContainerFalse(context);
    }).onError((error, stackTrace) {
      setLoading(false);
      setContainerFalse(context);
      AppUtils.showToastRedBg(context, error.toString());
    });
  }

  String getQrData() {
    return '${Global.empData!.key}-${Global.empData!.id}-$baseUrl';
  }

  //For Authentication of QR

  Map getUserData() {
    Map data = {
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
      'mobile_id': Global.mobileId,
      'mobile_app_code': Global.appName,
      'id': Global.empData!.id.toString(),
      'key': Global.empData!.key.toString(),
      'firebase_id': Global.firebaseToken,
    };
    return data;
  }

  Future<void> callQRActivateCodeApi(BuildContext context) async {
    setLoading(true);
    _myRepo.postApi(baseUrl + ApiUrl.qrActivate, getUserData()).then((value) {
      AuthenticationModel authData = AuthenticationModel.fromJson(value);
      if (authData.errorCode == 200) {
        AppUtils.showToastGreenBg(
            context, authData.errorDescription.toString());
        EmpData data = authData.empData!;
        data.isLoggedIn = true;
        saveEmpData(data);
        setdisable(true);
        callNextPage(context, 201);
      } else {
        AppUtils.showToastRedBg(context, authData.errorDescription.toString());
      }
      setLoading(false);
      setContainerFalse(context);
    }).onError((error, stackTrace) {
      setLoading(false);
      setContainerFalse(context);
      AppUtils.showToastRedBg(context, error.toString());
    });
  }

  //For Login
  // String empUserName = '';
  // String empPassword = '';
  late TextEditingController userNameController;
  late TextEditingController passwordController;

  void _updateButtonState() {
    if (userNameController.text.isNotEmpty &&
        passwordController.text.length > 5 &&
        allCompDataList.isNotEmpty) {
      setdisable(false);
    } else {
      setdisable(true);
    }
  }

  Map getLoginUserData() {
    Map<String, String> params = {};
    params['emp_code'] = userNameController.text.toString().trim();
    params['password'] = passwordController.text.toString().trim();
    params['company_id'] = singleCompData!.compId.toString();
    // params['mobile_id'] = Global.mobileId!;
    params['mobile_id'] = "123";
    params['firebase_id'] = Global.firebaseToken!;
    params['mobile_app_code'] = Global.appName;
    if (Global.empData != null && Global.tempAuthId.isEmpty) {
      params['authentication_id'] = Global.empData!.id.toString();
      params['valid_key'] = Global.empData!.key.toString();
    } else {
      params['authentication_id'] = Global.tempAuthId;
      params['valid_key'] = Global.tempAuthKey;
    }
    return params;
  }

  Future<void> callLoginApi(BuildContext context) async {
    setLoading(true);
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.login, getLoginUserData())
        .then((value) {
      setContainerFalse(context);
      setLoading(false);
      AuthenticationModel authData = AuthenticationModel.fromJson(value);
      if (authData.errorCode == 200) {
        AppUtils.showToastGreenBg(
            context, authData.errorDescription.toString());
        EmpData data = authData.empData!;
        data.isLoggedIn = true;
        saveEmpData(data);
        setdisable(true);
        saveRememberMeData();
        callNextPage(context, 201);
      } else {
        AppUtils.showToastRedBg(context, authData.errorDescription.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      setContainerFalse(context);
      AppUtils.showToastRedBg(context, error.toString());
    });
  }

  void saveRememberMeData() {
    DataPreferences.saveData('userName', userNameController.text.toString());
    DataPreferences.saveData('password', passwordController.text.toString());
    DataPreferences.saveDataBoolVal('isRemember', isRemember);
    userNameController.text = '';
    passwordController.text = '';
  }

  bool isRemember = false;

  void setIsRemember(bool val) {
    isRemember = val;
    notifyListeners();
  }

  void setIsRememberValue() async {
    isRemember = (await DataPreferences.getBoolData('isRemember'))!;
    if (isRemember) {
      userNameController.text = (await DataPreferences.getData('userName'))!;
      passwordController.text = (await DataPreferences.getData('password'))!;
      callCompList(userNameController.text.toString());
      setdisable(false);
    } else {
      setdisable(true);
    }
  }

  void logout(BuildContext context) async {
    EmpData? empData = Global.empData;
    empData!.isLoggedIn = false;
    DataPreferences.saveEmpData(empData);
    // Global.empData = await DataPreferences.loadEmpData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.id, (route) => false);
  }

  void validate(
      BuildContext context, String authId, String authKey, String url) {
    if (AppUtils.isValidated(context, authId, authKey)) {
      ApiUrl.baseUrl = url;
      Global.tempAuthId = authId;
      Global.tempAuthKey = authKey;
      //clear remembered data
      userNameController.text = '';
      passwordController.text = '';
      allCompDataList.clear();
      notifyListeners();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen(shouldRemember: false))).then((value) {
        setDefaultUrl(context);
        userNameController.text = '';
        passwordController.text = '';
        allCompDataList = [];
        isdisable = false;
        notifyListeners();
      });
    }
  }

  //for qrcode resume
  bool isQrCodeResume = false;

  // confirm the below function once more to understand
  void setDefaultUrl(BuildContext context) async {
    ApiUrl.baseUrl = await DataPreferences.getData('base_url');
    isQrCodeResume = false;
  }

  // for textfield disable
  bool isdisable = true;

  // set it to false when u achieve what u want in the api
  void setdisable(bool val) {
    isdisable = val;
    notifyListeners();
  }

  // for animation end
  void setContainerFalse(BuildContext context) {
    commonProvider = Provider.of(context, listen: false);
    Future.delayed(const Duration(milliseconds: 300), () {
      commonProvider.setContainer(commonProvider.animateContainer);
    });
  }

  void saveEmpData(EmpData empData) async {
    if (baseUrl.isNotEmpty) {
      DataPreferences.saveData('base_url', baseUrl);
      ApiUrl.baseUrl = baseUrl;
    } else {
      DataPreferences.saveData('base_url', ApiUrl.baseUrl!);
    }
    DataPreferences.saveEmpData(empData);
    Global.empData = await DataPreferences.loadEmpData();
  }

  void callNextPage(BuildContext context, int type) {
    if (type == 200) {
      AppUtils.showToastGreenBg(context, 'Successfully Generated');
      Navigator.pushNamed(context, ActivateQRCode.id);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    }
  }

  List<AllCompData> allCompDataList = [];

  void clearData() {
    allCompDataList = [];
    //singleCompData = null;
    _updateButtonState();
    notifyListeners();
  }

  AllCompData? singleCompData;

  void setCompanyData(AllCompData singleCompData) {
    this.singleCompData = singleCompData;
    notifyListeners();
  }

  bool isUserNameControllerDisable = false;
  void callCompList(String ss) {
    if (ss.length == 6) {
      String userName = userNameController.text.toString().trim();
      Map data = {
        'emp_code': userName,
      };
      isUserNameControllerDisable = true;
      notifyListeners();
      callCompanyListApi(data);
    } else {
      clearData();
    }
  }

  Future<void> callCompanyListApi(dynamic data) async {
    _myRepo.postApi(ApiUrl.baseUrl! + ApiUrl.searchCompany, data).then((value) {
      CompanySelectingModel compData = CompanySelectingModel.fromJson(value);
      if (compData.errorCode == 200) {
        allCompDataList = compData.allCompData!;
        singleCompData = allCompDataList.firstWhere(
            (comp) => comp.defaultComp == 1,
            orElse: () => AllCompData());
        allCompDataList.isEmpty
            ? AppUtils.errorMessage = AppUtils.noDataFound
            : '';
        _updateButtonState();
      } else {
        allCompDataList = [];
        singleCompData = null;
      }
    }).onError((error, stackTrace) {
      allCompDataList = [];
      singleCompData = null;
    }).whenComplete(() {
      isUserNameControllerDisable = false;
      notifyListeners();
    });
  }
}
