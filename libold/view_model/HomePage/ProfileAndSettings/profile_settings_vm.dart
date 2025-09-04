// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/HomePage/ProfileAndSettings/ddt.dart';
import 'package:petty_cash/data/models/HomePage/ProfileAndSettings/employee_id.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';

class ProfileSettingsVM extends ChangeNotifier {
  final _myRepo = GeneralRepository();
  bool isLoading = false;
  bool isLoading1 = false;
  String empErrorMsg = '';
  String DdtErrorMsg = '';

  EmployeeIDModel? employeeIDModel;
  EmployeeDTDModel? empDDt;

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void setLoading1(bool val) {
    isLoading1 = val;
    notifyListeners();
  }

  Future<void> callEmpIDApi() async {
    isLoading = true;
    _myRepo.postApiMultiLanguage(ApiUrl.baseUrl! + ApiUrl.empIdDocuments,
        {"emp_id": Global.empData!.empId.toString()}).then((value) {
      if (value['error_code'] == 200) {
        employeeIDModel = EmployeeIDModel.fromJson(value);
        print(employeeIDModel.toString());
      } else {
        empErrorMsg = value['error_description'];
        // AppUtils.showToastRedBg(context, value['error_description']);
      }
    }).onError((error, stackTrace) {
      empErrorMsg = error.toString();
    }).whenComplete(() {
      setLoading(false);
    });
  }

  // For DDT
  Future<void> callDDTApi() async {
    isLoading1 = true;
    _myRepo.postApiMultiLanguage(ApiUrl.baseUrl! + ApiUrl.empDDT,
        {"emp_id": Global.empData!.empId.toString()}).then((value) {
      if (value['error_code'] == 200) {
        empDDt = EmployeeDTDModel.fromJson(value);
        print(empDDt.toString());
      } else {
        DdtErrorMsg = value['error_description'];
      }
    }).onError((error, stackTrace) {
      DdtErrorMsg = error.toString();
    }).whenComplete(() {
      setLoading1(false);
    });
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;

    final List<String> words = text.split(' '); // Split the string by spaces
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

  String getQrData() {
    if (employeeIDModel == null ||
        employeeIDModel!.data == null ||
        employeeIDModel!.data!.isEmpty) {
      return '';
    }
    final employeeData = employeeIDModel!.data![0];
    final qrData = {
      'empId': Global.empData!.empId,
      'empName': employeeData.empName,
      'empJobTitle': employeeData.empJobTitle,
      'emp_iqama_no': employeeData.empIqamaNo,
      'manual_vehicle': empDDt!.data!.manualVehicle.toString(),
      'driving_iss_dt': empDDt!.data!.drivingIssDt.toString(),
      'drivingExpDt': empDDt!.data!.drivingIssDt.toString()
    };
    return jsonEncode(qrData);
  }
}
