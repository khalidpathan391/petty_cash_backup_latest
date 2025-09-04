// ignore_for_file: file_names, unused_import

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/Authentication/AuthenticationModel.dart';
import 'package:petty_cash/data/models/Authentication/CompanySelectingModel.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/data/sources/local/shared_preference.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:provider/provider.dart';

class CompanyVM extends ChangeNotifier {
  final _myRepo = GeneralRepository();

  Map getData() {
    Map data = {
      'emp_code': Global.empData!.empCode.toString(),
    };
    return data;
  }

  bool isLoading = false;
  List<AllCompData> allCompDataList = [];

  Future<void> callCompanyListApi() async {
    allCompDataList = [];
    isLoading = true;
    try {
      final value = await _myRepo.postApi(
          ApiUrl.baseUrl! + ApiUrl.searchCompany, getData());
      CompanySelectingModel compData = CompanySelectingModel.fromJson(value);
      allCompDataList = compData.allCompData!;
      allCompDataList.isEmpty
          ? AppUtils.errorMessage = AppUtils.noDataFound
          : '';
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void callTryAgain() {
    notifyListeners();
    callCompanyListApi();
  }

  int companyId = 0;

  void callChangeCompany() {
    if (companyId != 0) {
      EmpData? empData = Global.empData;
      empData!.companyId = companyId;
      DataPreferences.saveEmpData(empData);
      notifyListeners();
    }
  }
}
