// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/pettycash_analysis.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/pr_analysis_model.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/grn_analysis_model.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/global.dart';

class PoDashboardVm extends ChangeNotifier {
  final GeneralRepository _myRepo = GeneralRepository();

  bool isLoading = false;
  PettyCashAnalysis? pettyCashAnalysis;
  bool hasDataLoaded = false;

  List<String> pettyCashList = []; // petty cash names
  String? selectedPettyCash;

  // PR Analysis
  PRAnalysis? prAnalysis;
  bool prHasData = false;

  // GRN Analysis
  GrnAnalysis? grnAnalysis;
  bool grnHasData = false;

  String? get startDate {
    final selectedAccount = pettyCashAnalysis?.pettyCashAccounts?.firstWhere(
      (acc) =>
          acc.pettyCashDescription == selectedPettyCash ||
          acc.pettyCashCode == selectedPettyCash,
      orElse: () => PettyCashAccounts(),
    );
    return selectedAccount?.effectiveStartDate;
  }

  String? get endDate {
    final selectedAccount = pettyCashAnalysis?.pettyCashAccounts?.firstWhere(
      (acc) =>
          acc.pettyCashDescription == selectedPettyCash ||
          acc.pettyCashCode == selectedPettyCash,
      orElse: () => PettyCashAccounts(),
    );
    return selectedAccount?.effectiveEndDate;
  }

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  /// Initialize default values
  Future<void> initDefaultVal(BuildContext context) async {
    await callPettyCashDashboard();
    await callPRAnalysis();
    await callGRNAnalysis();
  }

  /// Petty Cash Dashboard API
  Future<void> callPettyCashDashboard() async {
    setLoading(true);
    String url = ApiUrl.baseUrl! + ApiUrl.getPettyCashAnalysis;

    try {
      final response = await _myRepo.postApi(url, getData());

      if (response != null) {
        pettyCashAnalysis = PettyCashAnalysis.fromJson(response);

        if (pettyCashAnalysis?.pettyCashAccounts != null &&
            pettyCashAnalysis!.pettyCashAccounts!.isNotEmpty) {
          hasDataLoaded = true;

          pettyCashList = pettyCashAnalysis!.pettyCashAccounts!
              .map((e) => e.pettyCashDescription ?? "")
              .where((name) => name.isNotEmpty)
              .toList();

          selectedPettyCash = pettyCashList.contains("Petty Cash")
              ? "Petty Cash"
              : pettyCashList.isNotEmpty
                  ? pettyCashList.first
                  : null;
        }
      }
    } catch (e, st) {
      print(" Error in callPettyCashDashboard: $e");
      print(st);
    } finally {
      setLoading(false);
    }
  }

  /// PR Analysis API
  Future<void> callPRAnalysis() async {
    setLoading(true);
    String url = ApiUrl.baseUrl! + ApiUrl.getPRAnalysis;

    try {
      final response = await _myRepo.postApi(url, getData());

      if (response != null) {
        prAnalysis = PRAnalysis.fromJson(response);
        prHasData = prAnalysis?.prHeadList != null &&
            prAnalysis!.prHeadList!.isNotEmpty;
      }
    } catch (e, st) {
      print(" Error in callPRAnalysis: $e");
      print(st);
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  /// GRN Analysis API
  Future<void> callGRNAnalysis() async {
    setLoading(true);
    String url = ApiUrl.baseUrl! + ApiUrl.getGrnnalysis; // Add endpoint

    try {
      final response = await _myRepo.postApi(url, getData());

      if (response != null) {
        grnAnalysis = GrnAnalysis.fromJson(response);
        grnHasData =
            grnAnalysis?.grnList != null && grnAnalysis!.grnList!.isNotEmpty;
      }
    } catch (e, st) {
      print(" Error in callGRNAnalysis: $e");
      print(st);
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  /// Get only un-approved GRN items
  List<GrnItem> getUnapprovedGRNItems() {
    if (grnAnalysis == null || grnAnalysis!.grnList == null) return [];

    return grnAnalysis!.grnList!
        .expand((grn) => (grn.items ?? []).cast<GrnItem>())
        .toList();
  }

  /// Get only assigned & un-consumed PR items
  List<PrItemList> getAssignedPRItems() {
    if (prAnalysis == null || prAnalysis!.prItemList == null) return [];

    return prAnalysis!.prItemList!.where((item) {
      final qty = double.tryParse(item.priItemQty ?? '0') ?? 0;
      return qty > 0;
    }).toList();
  }

  void setSelectedPettyCash(String value) {
    selectedPettyCash = value;
    notifyListeners();
  }

  Map<String, String> getData() {
    return {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      // 'user_id': '20273', // dynamic user
    };
  }
}
