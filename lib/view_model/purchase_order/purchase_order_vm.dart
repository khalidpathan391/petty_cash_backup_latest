// ignore_for_file: unused_field, prefer_function_declarations_over_variables, avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';
import 'package:petty_cash/data/models/po_model.dart/po_transaction_model.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/global.dart';

import 'package:petty_cash/data/repository/general_rep.dart';

class PoApplicationVm extends ChangeNotifier {
  final GeneralRepository _myRepo = GeneralRepository();
  bool _isDisposed = false;
  List<String> tabHeaders = ['Header', 'Item Details'];
  TextEditingController submitRemarksCtrl = TextEditingController();

  int docIndex = -1;

  int txnIndex = -1;

  int statusIndex = -1;
  int remarkIndex = -1;

  int reference = 0;
  int referenceId = 0;
  String refTxnType = '';
  int referenceDoc = 0;
  String docNo = '';
  int docLocationIndex = -1;
  int empCodeIndex = -1;
  int needByDateIndex = -1;
  int loanTypeCodeIndex = -1;
  int loanTypeId = -1;
  int earningCodeIndex = -1;
  int earningTypeIndex = -1;
  int deductionCodeIndex = -1;
  int deductionTypeIndex = -1;
  int amountIndex = -1;
  int noOfInstalmentIndex = -1;
  int maxAmountIndex = -1;
  int periodFromIndex = -1;
  int periodToIndex = -1;
  int withPayrollIndex = -1;
  int separateIndex = -1;
  int installmentAmtIndex = -1;
  double totalPaidAmount = 0.0;
  double totalBalanceAmount = 0.0;
  bool isSubmit = false;
  bool isApproved = false;
  String sendData = '';
  String empCode = '';
  String needByDate = '';
  bool isActionAll = false;
  List<int> selectedIndex = [];
  int myHeaderId = 0; // 0 initially, updated after saving
  bool isAdHistory = false;
  bool isComment = false;
  bool isDraft = false;
  bool isWorkFlow = false;
  bool isWFTab = false;
  bool isLoanDetals = false;
  bool isPaymentDetails = false;

  // Header controllers
  final TextEditingController docDateCtrl = TextEditingController();
  final TextEditingController docLocCodeCtrl = TextEditingController();
  final TextEditingController docLocDescCtrl = TextEditingController();
  final TextEditingController docNoTypeCtrl = TextEditingController();
  final TextEditingController docNoCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();

  final TextEditingController referenceCtrl = TextEditingController();
  final TextEditingController referenceDescCtrl = TextEditingController();
  String referenceSelectedCode = 'DIRECT';
  final TextEditingController refDocCodeCtrl = TextEditingController();
  final TextEditingController refDocNoCtrl = TextEditingController();
  final TextEditingController refDocCtrl = TextEditingController();

  final TextEditingController supplierCtrl = TextEditingController();
  final TextEditingController supOfferNoCtrl = TextEditingController();
  final TextEditingController supOfferDateCtrl = TextEditingController();

  final TextEditingController currencyCodeCtrl = TextEditingController();
  final TextEditingController currencyDescCtrl = TextEditingController();
  final TextEditingController exchangeRateCtrl = TextEditingController();
  final TextEditingController discountCtrl = TextEditingController();
  final TextEditingController valueCtrl = TextEditingController();

  final TextEditingController paymentTermCtrl = TextEditingController();
  final TextEditingController modeShipmentCtrl = TextEditingController();
  final TextEditingController modePaymentCtrl = TextEditingController();

  final TextEditingController chargeTypeCodeCtrl = TextEditingController();
  final TextEditingController chargeTypeDescCtrl = TextEditingController();
  final TextEditingController chargeToCodeCtrl = TextEditingController();
  final TextEditingController chargeToDescCtrl = TextEditingController();

  final TextEditingController shipToStoreCodeCtrl = TextEditingController();
  final TextEditingController shipToStoreDescCtrl = TextEditingController();

  final TextEditingController purchaseTypeCodeCtrl = TextEditingController();
  final TextEditingController purchaseTypeDescCtrl = TextEditingController();

  final TextEditingController pettyCashCodeCtrl = TextEditingController();
  final TextEditingController pettyCashDescCtrl = TextEditingController();

  final TextEditingController buyerCodeCtrl = TextEditingController();
  final TextEditingController buyerDescCtrl = TextEditingController();

  final TextEditingController etaCtrl = TextEditingController();
  final TextEditingController deliveryTermCodeCtrl = TextEditingController();
  final TextEditingController deliveryTermDescCtrl = TextEditingController();
  final TextEditingController needByDateCtrl = TextEditingController();
  final TextEditingController remarkCtrl = TextEditingController();

  final TextEditingController supplierCode = TextEditingController();
  final TextEditingController supplierDesc = TextEditingController();
  final TextEditingController supplierType = TextEditingController();
  final TextEditingController supplierAddress = TextEditingController();

  final quill.QuillController remarkQuillController =
      quill.QuillController.basic();

  bool isLoading = false;
  bool isApiLoading = false;
  bool hasDataLoaded = false;
  PurchaseOrderModel? purchaseOrderModel;

  // Reference PR specific fields
  bool isReferenceLoading = false;
  PurchaserequestReferenceModel referencePRModel =
      PurchaserequestReferenceModel(referencePR: []);

  void setLoading(bool val) {
    isLoading = val;
    if (!_isDisposed) notifyListeners();
  }

  void onDiscountChanged(String value) {
    // auto-calc header value if discount entered, assuming header gross is not provided.
    // Here we keep valueCtrl as (value after discount) if exchangeRate exists; simplistic rule: value = max(0, exchangeRate - discount).
    // Adjust when backend provides proper formula.
    final double rate = double.tryParse(exchangeRateCtrl.text) ?? 0.0;
    final double disc = double.tryParse(value) ?? 0.0;
    double result = rate - disc;
    if (result < 0) result = 0;
    valueCtrl.text = result.toStringAsFixed(2);
    if (!_isDisposed) notifyListeners();
  }

  void setApiLoading(bool val) {
    isApiLoading = val;
    if (!_isDisposed) notifyListeners();
  }

  void setDefault() {
    tabHeaders.clear();
    tabHeaders = ['Header', 'Item Details'];
    myHeaderId = -1;
    notifyListeners();
  }

  bool get isReferenceDirect => referenceSelectedCode == 'DIRECT';

  void setReferenceSelected(String value) {
    referenceSelectedCode = value;
    if (isReferenceDirect) {
      refDocCodeCtrl.clear();
      refDocNoCtrl.clear();
    }
    if (!_isDisposed) notifyListeners();
  }

  void _updateRemarkQuillFromText() {
    final len = remarkQuillController.document.length;
    remarkQuillController.document.delete(0, len);
    if (remarkCtrl.text.isNotEmpty) {
      remarkQuillController.document.insert(0, remarkCtrl.text);
    }
  }

  void setRemarkFromQuill() {
    remarkCtrl.text = remarkQuillController.document.toPlainText().trim();
  }

// default view api
  Future<void> callPoView(int headerId) async {
    setLoading(true);
    myHeaderId = headerId; // update headerId first
    String url = ApiUrl.baseUrl! + ApiUrl.getPoTransaction;

    try {
      final dynamic response = await _myRepo.postApi(url, getData(headerId));

      if (response != null) {
        // Parse API response into model
        purchaseOrderModel = PurchaseOrderModel.fromJson(response);

        if (purchaseOrderModel?.headerTab != null) {
          _applyHeaderData(purchaseOrderModel!.headerTab!.toJson());
          hasDataLoaded = true;
        } else {
          // Fallback empty HeaderTab to avoid UI issues
          // poDefaultModel!.headerTab =
          // _applyHeaderData(purchaseOrderModel!.headerTab!.toJson());
          print("Warning: header_tab is null from API, fallback applied");
          print("Full API response: $response"); // Debug log
        }
      }
    } catch (e, st) {
      print("Error in callPoView: $e");
      print(st);
    } finally {
      setLoading(false);
    }
  }

  /// Return data map for API call
  Map<String, String> getData(int myHeaderId) {
    return {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'default': myHeaderId > 0 ? '0' : '1',
      'is_view': '1',
      'header_id': myHeaderId > 0 ? myHeaderId.toString() : '0',
      'is_submit': '0',
    };
  }

  /// Return data map for API call depending on myHeaderId

  void _applyHeaderData(Map<String, dynamic> h) {
    docDateCtrl.text = _s(h['doc_date']);
    docLocCodeCtrl.text = _s(h['doc_loc_code']);
    docLocDescCtrl.text = _s(h['doc_loc_desc']);
    docNoTypeCtrl.text = _s(h['txn_type']);
    docNoCtrl.text = _s(h['txn_no']);
    statusCtrl.text = _s(h['status_description']);

    referenceCtrl.text = _s(h['reference']);
    referenceDescCtrl.text = _s(h['reference_desc']);
    referenceSelectedCode =
        referenceDescCtrl.text.isEmpty ? 'DIRECT' : referenceDescCtrl.text;

    supplierCtrl.text = _s(h['supplier_code']);
    supOfferNoCtrl.text = _s(h['supplier_offer_no']);
    supOfferDateCtrl.text = _s(h['supplier_offer_date']);
    currencyCodeCtrl.text = _s(h['currency_code']);
    currencyDescCtrl.text = _s(h['currency_description']);
    exchangeRateCtrl.text = _s(h['exchange_rate']);
    discountCtrl.text = _s(h['discount']);
    valueCtrl.text = _s(h['value']);
    paymentTermCtrl.text = _s(h['payment_term_desc']);
    modeShipmentCtrl.text = _s(h['mode_of_shipment_desc']);
    modePaymentCtrl.text = _s(h['mode_of_payment_desc']);
    chargeTypeCodeCtrl.text = _s(h['charge_type_code']);
    chargeTypeDescCtrl.text = _s(h['charge_type_description']);
    chargeToCodeCtrl.text = _s(h['charge_to_code']);
    chargeToDescCtrl.text = _s(h['charge_to_description']);
    shipToStoreCodeCtrl.text = _s(h['ship_to_store_loc_code']);
    shipToStoreDescCtrl.text = _s(h['ship_to_store_loc_description']);
    purchaseTypeCodeCtrl.text = _s(h['purchase_type_code']);
    purchaseTypeDescCtrl.text = _s(h['purchase_type_desc']);
    pettyCashCodeCtrl.text = _s(h['petty_cash_code']);
    pettyCashDescCtrl.text = _s(h['petty_cash_desc']);
    buyerCodeCtrl.text = _s(h['buyer_code']);
    buyerDescCtrl.text = _s(h['buyer_desc']);
    etaCtrl.text = _s(h['header_eta']);
    deliveryTermCodeCtrl.text = _s(h['delivery_term_code']);
    deliveryTermDescCtrl.text = _s(h['delivery_term_desc']);
    needByDateCtrl.text = _s(h['need_by_date']);
    remarkCtrl.text = _s(h['remark']);
    _updateRemarkQuillFromText();
    if (!_isDisposed) notifyListeners();
  }

  String _s(dynamic v) => v == null ? '' : v.toString();
  // reference pr api
  void setReferenceLoading(bool val) {
    isReferenceLoading = val;
    if (!_isDisposed) notifyListeners();
  }

  /// --- Fetch Reference PR from API ---
  Future<void> fetchReferencePR() async {
    setReferenceLoading(true);

    try {
      String url = ApiUrl.baseUrl! + ApiUrl.getPrReference;
      final response = await _myRepo.postApi(url, {
        'company_id': Global.empData!.companyId.toString(),
        'user_id': '20273'
        //  Global.empData!.userId.toString(),
      });

      if (response != null) {
        // ✅ Assign to class-level property, not a local variable
        referencePRModel = PurchaserequestReferenceModel.fromJson(response);
      } else {
        referencePRModel = PurchaserequestReferenceModel(referencePR: []);
      }
    } catch (e, st) {
      print("Error in fetchReferencePR: $e");
      print(st);
      referencePRModel = PurchaserequestReferenceModel(referencePR: []);
    } finally {
      setReferenceLoading(false);
    }
  }

  @override
  void dispose() {
    submitRemarksCtrl.dispose();
    docDateCtrl.dispose();
    docLocCodeCtrl.dispose();
    docLocDescCtrl.dispose();
    docNoTypeCtrl.dispose();
    docNoCtrl.dispose();
    statusCtrl.dispose();
    referenceCtrl.dispose();
    referenceDescCtrl.dispose();
    refDocCodeCtrl.dispose();
    refDocNoCtrl.dispose();
    refDocCtrl.dispose();
    supplierCtrl.dispose();
    supOfferNoCtrl.dispose();
    supOfferDateCtrl.dispose();
    currencyCodeCtrl.dispose();
    currencyDescCtrl.dispose();
    exchangeRateCtrl.dispose();
    discountCtrl.dispose();
    valueCtrl.dispose();
    paymentTermCtrl.dispose();
    modeShipmentCtrl.dispose();
    modePaymentCtrl.dispose();
    chargeTypeCodeCtrl.dispose();
    chargeTypeDescCtrl.dispose();
    chargeToCodeCtrl.dispose();
    chargeToDescCtrl.dispose();
    shipToStoreCodeCtrl.dispose();
    shipToStoreDescCtrl.dispose();
    purchaseTypeCodeCtrl.dispose();
    purchaseTypeDescCtrl.dispose();
    pettyCashCodeCtrl.dispose();
    pettyCashDescCtrl.dispose();
    buyerCodeCtrl.dispose();
    buyerDescCtrl.dispose();
    etaCtrl.dispose();
    deliveryTermCodeCtrl.dispose();
    deliveryTermDescCtrl.dispose();
    needByDateCtrl.dispose();
    remarkCtrl.dispose();
    remarkQuillController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
