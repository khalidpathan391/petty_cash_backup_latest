// ignore_for_file: unused_field, prefer_function_declarations_over_variables, avoid_print, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:petty_cash/data/models/common/common_searching_model.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';
import 'package:petty_cash/data/models/po_model.dart/po_transaction_model.dart';
import 'package:petty_cash/data/models/po_model.dart/item_details_model.dart'
    as item_model;
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/global.dart';

import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/view/po_transaction/common/CommonPaginationSearching.dart';
import 'package:petty_cash/view/po_transaction/item_search_agination.dart';

class PoApplicationVm extends ChangeNotifier {
  final GeneralRepository _myRepo = GeneralRepository();
  bool _isDisposed = false;
  List<String> tabHeaders = ['Header', 'Item Details'];

  PoApplicationVm() {
    _initializeControllerListeners();
  }

  /// Initialize listeners for controllers that need to update line items
  void _initializeControllerListeners() {
    // Add listeners to charge type controllers
    chargeTypeCodeCtrl.addListener(_onChargeTypeChanged);
    chargeTypeDescCtrl.addListener(_onChargeTypeChanged);

    // Add listeners to charge to controllers
    chargeToCodeCtrl.addListener(_onChargeToChanged);
    chargeToDescCtrl.addListener(_onChargeToChanged);

    // Add listeners to header discount and value controllers
    valueCtrl.addListener(_onValueControllerChanged);
  }

  /// Handle value controller changes
  void _onValueControllerChanged() {
    onValueChanged(valueCtrl.text);
  }

  /// Handle charge type changes
  void _onChargeTypeChanged() {
    // Update chargeTypeCode variable for charge to search functionality
    chargeTypeCode = chargeTypeCodeCtrl.text;

    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (final item in purchaseOrderModel!.itemDetailsTab!) {
        item.chargeTypeCode = chargeTypeCodeCtrl.text;
        item.chargeTypeName = chargeTypeDescCtrl.text;
      }
      if (!_isDisposed) notifyListeners();
    }
  }

  /// Handle charge to changes
  void _onChargeToChanged() {
    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (final item in purchaseOrderModel!.itemDetailsTab!) {
        item.chargeToCode = chargeToCodeCtrl.text;
        item.chargeToName = chargeToDescCtrl.text;
      }
      if (!_isDisposed) notifyListeners();
    }
  }

  // ==================== CONTROLLERS ====================

  /// Document Information Controllers
  final TextEditingController docDateCtrl = TextEditingController();
  final TextEditingController docLocCodeCtrl = TextEditingController();
  final TextEditingController docLocDescCtrl = TextEditingController();
  final TextEditingController docNoTypeCtrl = TextEditingController();
  final TextEditingController docNoCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();

  /// Reference Information Controllers
  final TextEditingController referenceCtrl = TextEditingController();
  final TextEditingController referenceDescCtrl = TextEditingController();
  final TextEditingController refDocCodeCtrl = TextEditingController();
  final TextEditingController refDocNoCtrl = TextEditingController();
  final TextEditingController refDocCtrl = TextEditingController();
  String referenceSelectedCode = 'DIRECT';

  /// Supplier Information Controllers
  final TextEditingController supplierCtrl = TextEditingController();
  final TextEditingController supOfferNoCtrl = TextEditingController();
  final TextEditingController supOfferDateCtrl = TextEditingController();

  /// Additional Supplier Controllers (for supplier creation)
  final TextEditingController supplierCode = TextEditingController();
  final TextEditingController supplierDesc = TextEditingController();
  final TextEditingController supplierType = TextEditingController();
  final TextEditingController supplierTypeDesc = TextEditingController();
  final TextEditingController supplierAddress = TextEditingController();
  final TextEditingController supplierAddressDesc = TextEditingController();

  /// Validation Controllers
  bool crNoSelected = false;
  bool zakatSelected = false;
  bool vatSelected = false;
  final TextEditingController crNoNumber = TextEditingController();
  final TextEditingController crNoExpiry = TextEditingController();
  final TextEditingController zakatNumber = TextEditingController();
  final TextEditingController zakatExpiry = TextEditingController();
  final TextEditingController vatNumber = TextEditingController();
  final TextEditingController vatExpiry = TextEditingController();

  /// Financial Information Controllers
  final TextEditingController currencyCodeCtrl = TextEditingController();
  final TextEditingController currencyDescCtrl = TextEditingController();
  final TextEditingController exchangeRateCtrl = TextEditingController();
  final TextEditingController discountCtrl = TextEditingController();
  final TextEditingController valueCtrl = TextEditingController();

  /// Payment & Shipping Controllers
  final TextEditingController paymentTermCtrl = TextEditingController();
  final TextEditingController modeShipmentCtrl = TextEditingController();
  final TextEditingController modePaymentCtrl = TextEditingController();
  final TextEditingController deliveryTermCodeCtrl = TextEditingController();
  final TextEditingController deliveryTermDescCtrl = TextEditingController();

  /// Charge Information Controllers
  final TextEditingController chargeTypeCodeCtrl = TextEditingController();
  final TextEditingController chargeTypeDescCtrl = TextEditingController();
  final TextEditingController chargeToCodeCtrl = TextEditingController();
  final TextEditingController chargeToDescCtrl = TextEditingController();

  /// Location & Type Controllers
  final TextEditingController shipToStoreCodeCtrl = TextEditingController();
  final TextEditingController shipToStoreDescCtrl = TextEditingController();
  final TextEditingController purchaseTypeCodeCtrl = TextEditingController();
  final TextEditingController purchaseTypeDescCtrl = TextEditingController();

  /// Additional Information Controllers
  final TextEditingController pettyCashCodeCtrl = TextEditingController();
  final TextEditingController pettyCashDescCtrl = TextEditingController();
  final TextEditingController buyerCodeCtrl = TextEditingController();
  final TextEditingController buyerDescCtrl = TextEditingController();
  final TextEditingController etaCtrl = TextEditingController();
  final TextEditingController needByDateCtrl = TextEditingController();

  /// Remarks & Comments Controllers
  final TextEditingController remarkCtrl = TextEditingController();
  final quill.QuillController remarkQuillController =
      quill.QuillController.basic();
  final TextEditingController submitRemarksCtrl = TextEditingController();

  // ==================== STATE MANAGEMENT ====================

  /// Loading States
  bool isLoading = false;
  bool isApiLoading = false;
  bool isReferenceLoading = false;
  bool hasDataLoaded = false;

  /// Data Models
  PurchaseOrderModel? purchaseOrderModel;
  PurchaserequestReferenceModel referencePRModel =
      PurchaserequestReferenceModel(referencePR: []);

  /// UI State Management
  bool isActionAll = false;
  List<int> selectedIndex = [];
  bool isSubmit = false;
  bool isApproved = false;
  bool isAdHistory = false;
  bool isComment = false;
  bool isDraft = false;
  bool isWorkFlow = false;
  bool isWFTab = false;
  bool isLoanDetals = false;
  bool isPaymentDetails = false;

  /// Transaction State
  int myHeaderId = 0; // 0 initially, updated after saving
  String sendData = '';
  String empCode = '';
  String needByDate = '';
  double totalPaidAmount = 0.0;
  double totalBalanceAmount = 0.0;

  /// Index Management
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

  /// Additional Properties
  int supp_id = 0;
  String chargeTypeCode = '';
  List<TaxPopup> taxPopups = [];

  void setLoading(bool val) {
    isLoading = val;
    if (!_isDisposed) notifyListeners();
  }

  void onDiscountChanged(String value) {
    // Only calculate if item details are filled
    if (hasItemDetailsFilled()) {
      _calculateHeaderValueFromDiscount();
    }
    if (!_isDisposed) notifyListeners();
  }

  void onValueChanged(String value) {
    // Only calculate if item details are filled
    if (hasItemDetailsFilled()) {
      _calculateHeaderDiscountFromValue();
    }
    if (!_isDisposed) notifyListeners();
  }

  /// Check if item details are filled
  bool hasItemDetailsFilled() {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        purchaseOrderModel!.itemDetailsTab!.isEmpty) {
      return false;
    }

    // Check if at least one item has quantity and unit price
    for (final item in purchaseOrderModel!.itemDetailsTab!) {
      if ((item.quantity != null &&
              item.quantity!.isNotEmpty &&
              item.quantity != '0') &&
          (item.unitPrice != null &&
              item.unitPrice!.isNotEmpty &&
              item.unitPrice != '0')) {
        return true;
      }
    }
    return false;
  }

  /// Calculate header value from discount
  void _calculateHeaderValueFromDiscount() {
    final discountText = discountCtrl.text.trim();

    // If discount field is cleared, clear value field too
    if (discountText.isEmpty) {
      valueCtrl.clear();
      return;
    }

    try {
      final discount = double.parse(discountText);
      final totalItemNetValue = _calculateTotalItemNetValue();

      if (totalItemNetValue > 0) {
        final value = totalItemNetValue - discount;
        valueCtrl.text = value.toStringAsFixed(2);
      }
    } catch (e) {
      print('Error calculating value from discount: $e');
    }
  }

  /// Calculate header discount from value
  void _calculateHeaderDiscountFromValue() {
    final valueText = valueCtrl.text.trim();

    // If value field is cleared, clear discount field too
    if (valueText.isEmpty) {
      discountCtrl.clear();
      return;
    }

    try {
      final value = double.parse(valueText);
      final totalItemNetValue = _calculateTotalItemNetValue();

      if (totalItemNetValue > 0) {
        final discount = totalItemNetValue - value;
        discountCtrl.text = discount.toStringAsFixed(2);
      }
    } catch (e) {
      print('Error calculating discount from value: $e');
    }
  }

  /// Calculate total net value from all item details
  double _calculateTotalItemNetValue() {
    if (purchaseOrderModel?.itemDetailsTab == null) return 0.0;

    double total = 0.0;
    for (final item in purchaseOrderModel!.itemDetailsTab!) {
      try {
        final netValue = double.tryParse(item.netValue ?? '0') ?? 0.0;
        total += netValue;
      } catch (e) {
        print('Error parsing net value: $e');
      }
    }
    return total;
  }

  /// Get total gross value from all item details
  double getTotalGrossValue() {
    if (purchaseOrderModel?.itemDetailsTab == null) return 0.0;

    double total = 0.0;
    for (final item in purchaseOrderModel!.itemDetailsTab!) {
      try {
        final grossValue = double.tryParse(item.grossValue ?? '0') ?? 0.0;
        total += grossValue;
      } catch (e) {
        print('Error parsing gross value: $e');
      }
    }
    return total;
  }

  /// Get total discount value from all item details
  double getTotalDiscountValue() {
    if (purchaseOrderModel?.itemDetailsTab == null) return 0.0;

    double total = 0.0;
    for (final item in purchaseOrderModel!.itemDetailsTab!) {
      try {
        final discountValue = double.tryParse(item.discountVal ?? '0') ?? 0.0;
        total += discountValue;
      } catch (e) {
        print('Error parsing discount value: $e');
      }
    }
    return total;
  }

  /// Get total net value from all item details
  double getTotalNetValue() {
    return _calculateTotalItemNetValue();
  }

  /// Get header discount value
  double getHeaderDiscountValue() {
    try {
      return double.tryParse(discountCtrl.text.trim()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get header value
  double getHeaderValue() {
    try {
      return double.tryParse(valueCtrl.text.trim()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get final net value (item details + header)
  double getFinalNetValue() {
    final itemNetValue = getTotalNetValue();
    final headerValue = getHeaderValue();
    return itemNetValue + headerValue;
  }

  // ==================== ITEM CALCULATION METHODS ====================

  /// Calculate quantity-related fields when quantity changes
  void onQuantityChanged(String value, int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];
    final quantity = double.tryParse(value) ?? 0.0;

    // Update quantity field
    item.quantity = value;
    if (item.quantityController != null) {
      item.quantityController!.text = value;
    }

    // Set base quantity to same value as quantity (non-clickable)
    item.baseQty = value;

    // Only update loose quantity if item has been loaded from API AND has a loose quantity value
    // This ensures loose quantity calculation only happens when API data is available with actual value (not 0, not empty)
    if (item.itemCode != null &&
        item.itemCode!.isNotEmpty &&
        item.looseQty != null &&
        item.looseQty!.isNotEmpty &&
        item.looseQty != '' &&
        item.looseQty != '0') {
      item.looseQty = value;
    }

    // Recalculate gross value if unit price exists
    if (item.unitPrice != null && item.unitPrice!.isNotEmpty) {
      calculateGrossValue(index);
    }

    if (!_isDisposed) notifyListeners();
  }

  /// Calculate gross value when unit price changes
  void onUnitPriceChanged(String value, int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];

    // Update unit price field
    item.unitPrice = value;
    if (item.unitPriceController != null) {
      item.unitPriceController!.text = value;
    }

    // Calculate gross value
    calculateGrossValue(index);

    if (!_isDisposed) notifyListeners();
  }

  /// Calculate gross value from quantity * unit price
  void calculateGrossValue(int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];
    final quantity = double.tryParse(item.quantity ?? '0') ?? 0.0;
    final unitPrice = double.tryParse(item.unitPrice ?? '0') ?? 0.0;

    final grossValue = quantity * unitPrice;
    item.grossValue = grossValue.toStringAsFixed(2);

    // Recalculate net value if discount exists
    calculateNetValue(index);
  }

  /// Calculate discount value when discount percentage changes
  void onDiscountPercentageChanged(String value, int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];

    // Update discount percentage field
    item.discountPer = value;
    if (item.discountController != null) {
      item.discountController!.text = value;
    }

    // Calculate discount value from percentage
    final grossValue = double.tryParse(item.grossValue ?? '0') ?? 0.0;
    final discountPercent = double.tryParse(value) ?? 0.0;
    final discountValue = (grossValue * discountPercent) / 100;

    item.discountVal = discountValue.toStringAsFixed(2);
    if (item.discountValueController != null) {
      item.discountValueController!.text = item.discountVal!;
    }

    // Calculate net value
    calculateNetValue(index);

    if (!_isDisposed) notifyListeners();
  }

  /// Calculate discount percentage when discount value changes
  void onDiscountValueChanged(String value, int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];

    // Update discount value field
    item.discountVal = value;
    if (item.discountValueController != null) {
      item.discountValueController!.text = value;
    }

    // Calculate discount percentage from value
    final grossValue = double.tryParse(item.grossValue ?? '0') ?? 0.0;
    final discountValue = double.tryParse(value) ?? 0.0;

    if (grossValue > 0) {
      final discountPercent = (discountValue / grossValue) * 100;
      item.discountPer = discountPercent.toStringAsFixed(2);
      if (item.discountController != null) {
        item.discountController!.text = item.discountPer!;
      }
    } else {
      item.discountPer = '0';
      if (item.discountController != null) {
        item.discountController!.text = '0';
      }
    }

    // Calculate net value
    calculateNetValue(index);

    if (!_isDisposed) notifyListeners();
  }

  /// Calculate net value from gross value minus discount
  void calculateNetValue(int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];
    final grossValue = double.tryParse(item.grossValue ?? '0') ?? 0.0;
    final discountValue = double.tryParse(item.discountVal ?? '0') ?? 0.0;

    final netValue = grossValue - discountValue;
    item.netValue = netValue.toStringAsFixed(2);

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

  /// Update all line items with current header charge type and charge to values
  void updateAllLineItemsWithHeaderData() {
    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (final item in purchaseOrderModel!.itemDetailsTab!) {
        // Update charge type
        item.chargeTypeCode = chargeTypeCodeCtrl.text;
        item.chargeTypeName = chargeTypeDescCtrl.text;

        // Update charge to
        item.chargeToCode = chargeToCodeCtrl.text;
        item.chargeToName = chargeToDescCtrl.text;
      }
      notifyListeners();
    }
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
        }
        // Initialize isOpen for item lines to support UI expansion
        if (purchaseOrderModel?.itemDetailsTab != null) {
          for (final item in purchaseOrderModel!.itemDetailsTab!) {
            item.isOpen = false;
            // Populate item details with header charge type data
            if (purchaseOrderModel?.headerTab != null) {
              final headerData = purchaseOrderModel!.headerTab!;
              item.chargeTypeCode = headerData.chargeTypeCode ?? '';
              item.chargeTypeName = headerData.chargeTypeDescription ?? '';
              item.chargeToCode = headerData.chargeToCode ?? '';
              item.chargeToName = headerData.chargeToDescription ?? '';
            }
          }
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
    // Set chargeTypeCode variable for charge to search functionality
    chargeTypeCode = _s(h['charge_type_code']);
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

  void toggleItemOpen(int index) {
    if (purchaseOrderModel?.itemDetailsTab == null) return;
    if (index < 0 || index >= purchaseOrderModel!.itemDetailsTab!.length)
      return;
    final current = purchaseOrderModel!.itemDetailsTab![index].isOpen ?? false;
    purchaseOrderModel!.itemDetailsTab![index].isOpen = !current;
    if (!_isDisposed) notifyListeners();
  }

  // ===================== Reference Search Flow =====================
  Future<void> searchReference(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginationSearching(
          url: ApiUrl.baseUrl! + ApiUrl.commonReferenceSearch,
          searchType: '',
          searchKeyWord: '',
          txnType: 'PO',
          isItem: true,
        ),
      ),
    );

    if (result != null && result is SearchList) {
      referenceCtrl.text = result.code ?? '';
      referenceDescCtrl.text = result.desc ?? '';
      setReferenceSelected(
          referenceDescCtrl.text.isEmpty ? 'DIRECT' : referenceDescCtrl.text);
      // Clear dependent ref doc fields
      refDocCodeCtrl.clear();
      refDocNoCtrl.clear();
      referenceId = result.id ?? 0;
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> searchRefTxnCode(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginationSearching(
          url: ApiUrl.baseUrl! + ApiUrl.getCommonRefTxnCodeList,
          searchType: '',
          searchKeyWord: '',
          txnType: '',
          isItem: true,
          isMenuId: true,
          refId: referenceId.toString(),
          refTxntype: '',
        ),
      ),
    );

    if (result != null && result is SearchList) {
      refDocCodeCtrl.text = result.code ?? '';
      refTxnType = result.code ?? '';
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> searchRefDocNo(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginationSearching(
          url: ApiUrl.baseUrl! + ApiUrl.getRefDocNoList,
          searchType: '',
          searchKeyWord: '',
          txnType: 'PO',
          isItem: true,
          isMenuId: true,
          refId: '',
          refTxntype: refTxnType.toString(),
        ),
      ),
    );

    if (result != null && result is SearchList) {
      refDocNoCtrl.text = result.desc ?? '';
      if (!_isDisposed) notifyListeners();
    }
  }

  // ===================== Generic Searches =====================
  Future<void> searchField(BuildContext context, String fieldName) async {
    String searchType = '';

    switch (fieldName) {
      case 'Doc. Loc.*':
        searchType = 'Location';
        break;
      case 'Supplier*':
        searchType = 'Supplier';
        break;
      case 'Currency*':
        searchType = 'Currency';

        break;
      case 'Payment Term*':
        searchType = 'PAYMENT_TERM';
        break;
      case 'Mode of Shipment*':
        searchType = 'MODE_OF_SHIPMENT';
        break;
      case 'Mode of Payment*':
        searchType = 'MODE_OF_PAYMENT';
        break;
      case 'Charge Type*':
        searchType = 'CHARGE_TYPE';
        break;
      case 'Charge To*':
        searchType = 'CHARGE_TO';
        break;
      case 'Ship to Store Loc*':
        searchType = 'STORE_LOCATION';
        break;
      case 'Purchase Type*':
        searchType = 'PURCHASE_TYPE';
        break;
      case 'Petty Cash No*':
        searchType = 'PETTY_CASH_NO';
        break;
      case 'Buyer ID*':
        searchType = 'BUYER_ID';
        break;
      case 'Delivery Term*':
        searchType = 'DELIVERY_TERM';
        break;
      default:
        searchType = '';
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginationSearching(
          url: ApiUrl.baseUrl! + ApiUrl.commonSearching,
          searchType: searchType,
          searchKeyWord: '',
          txnType: 'PO',
          isItem: true,
          isMenuId: true,
          supp_id: supp_id.toString(),
          chargeTypeCode: chargeTypeCode
              .toString(), // Pass `chargeTypeCode` only if it's set
        ),
      ),
    );

    if (result != null && result is SearchList) {
      switch (fieldName) {
        case 'Doc. Loc.*':
          docLocCodeCtrl.text = result.code ?? '';
          docLocDescCtrl.text = result.desc ?? '';
          break;
        case 'Supplier*':
          supplierCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
          supp_id = result.id ?? 0;
          break;
        case 'Currency*':
          currencyCodeCtrl.text = result.code ?? '';
          currencyDescCtrl.text = result.desc ?? '';
          break;
        case 'Payment Term*':
          paymentTermCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
          break;
        case 'Mode of Shipment*':
          modeShipmentCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
          break;
        case 'Mode of Payment*':
          modePaymentCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
          break;
        case 'Charge Type*':
          chargeTypeCodeCtrl.text = result.code ?? '';
          chargeTypeDescCtrl.text = result.desc ?? '';
          chargeTypeCode = result.code ?? ''; // Update chargeTypeCode

          // Update all existing line items with new charge type
          if (purchaseOrderModel?.itemDetailsTab != null) {
            for (final item in purchaseOrderModel!.itemDetailsTab!) {
              item.chargeTypeCode = result.code ?? '';
              item.chargeTypeName = result.desc ?? '';
            }
          }
          break;
        case 'Charge To*':
          chargeToCodeCtrl.text = result.code ?? '';
          chargeToDescCtrl.text = result.desc ?? '';

          // Update all existing line items with new charge to
          if (purchaseOrderModel?.itemDetailsTab != null) {
            for (final item in purchaseOrderModel!.itemDetailsTab!) {
              item.chargeToCode = result.code ?? '';
              item.chargeToName = result.desc ?? '';
            }
          }
          break;
        case 'Supplier Type':
          supplierType.text = '${result.code ?? ''} - ${result.desc ?? ''}';
          break;
        case 'Address Code':
          supplierAddress.text = result.code ?? '';
          break;
        case 'Address Description':
          supplierAddressDesc.text = result.desc ?? '';
          break;
        case 'Ship to Store Loc*':
          shipToStoreCodeCtrl.text = result.code ?? '';
          shipToStoreDescCtrl.text = result.desc ?? '';
          break;
        case 'Purchase Type*':
          purchaseTypeCodeCtrl.text = result.code ?? '';
          purchaseTypeDescCtrl.text = result.desc ?? '';
          break;
        case 'Petty Cash No*':
          pettyCashCodeCtrl.text = result.code ?? '';
          pettyCashDescCtrl.text = result.desc ?? '';
          break;
        case 'Buyer ID*':
          buyerCodeCtrl.text = result.code ?? '';
          buyerDescCtrl.text = result.desc ?? '';
          break;
        case 'Delivery Term*':
          deliveryTermCodeCtrl.text = result.code ?? '';
          deliveryTermDescCtrl.text = result.desc ?? '';
          break;
      }
      if (!_isDisposed) notifyListeners();
    }
  }

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
        'user_id': Global.empData!.userId.toString(),
      });

      if (response != null) {
        //  Assign to class-level property, not a local variable
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

  /// --- Add PR Reference to PO Item Details ---
  Future<void> addPrReference(List<int> priLineIdList) async {
    if (priLineIdList.isEmpty) return;

    setReferenceLoading(true);

    try {
      String url = ApiUrl.baseUrl! + ApiUrl.addPrReference;
      final response = await _myRepo.postApi(url, {
        'user_id': Global.empData!.userId.toString(),
        'company_id': Global.empData!.companyId.toString(),
        'pri_line_id_list': priLineIdList.join(','),
      });

      if (response != null && response['pr_detail_tab'] != null) {
        // Parse the response and add new line items
        List<dynamic> itemDetailsList = response['pr_detail_tab'];

        for (var itemData in itemDetailsList) {
          // Create new ItemDetailsTab from API response
          var newItem = ItemDetailsTab.fromJson(itemData);

          // Initialize controllers for the new item
          newItem.discountController =
              TextEditingController(text: newItem.discountPer ?? '0');
          newItem.discountValueController =
              TextEditingController(text: newItem.discountVal ?? '0');
          newItem.quantityController =
              TextEditingController(text: newItem.quantity ?? '');
          newItem.unitPriceController =
              TextEditingController(text: newItem.unitPrice ?? '');
          newItem.noteToReceiverController =
              TextEditingController(text: newItem.noteToReceiver ?? '');

          // Set charge type and charge to from header if available
          newItem.chargeTypeCode =
              chargeTypeCodeCtrl.text.isNotEmpty ? chargeTypeCodeCtrl.text : '';
          newItem.chargeTypeName =
              chargeTypeDescCtrl.text.isNotEmpty ? chargeTypeDescCtrl.text : '';
          newItem.chargeToCode =
              chargeToCodeCtrl.text.isNotEmpty ? chargeToCodeCtrl.text : '';
          newItem.chargeToName =
              chargeToDescCtrl.text.isNotEmpty ? chargeToDescCtrl.text : '';

          // Add to item details tab
          purchaseOrderModel?.itemDetailsTab ??= [];
          purchaseOrderModel!.itemDetailsTab!.add(newItem);
        }

        // Update header net value popup data if available
        if (response['header_net_value_popup'] != null &&
            response['header_net_value_popup'].isNotEmpty) {
          var headerData = response['header_net_value_popup'][0];

          // Update header discount and value controllers with API data
          if (headerData['header_discount'] != null) {
            discountCtrl.text = headerData['header_discount'].toString();
          }
          if (headerData['header_net_value'] != null) {
            valueCtrl.text = headerData['header_net_value'].toString();
          }
        }

        if (!_isDisposed) notifyListeners();
      }
    } catch (e, st) {
      print("Error in addPrReference: $e");
      print(st);
    } finally {
      setReferenceLoading(false);
    }
  }

  // ===================== Item Search Flow =====================
  void callItemSearch(BuildContext context, int index, int type) {
    // Ensure there's at least one item line
    if (purchaseOrderModel?.itemDetailsTab == null ||
        purchaseOrderModel!.itemDetailsTab!.isEmpty) {
      addItemDetailsLine();
    }

    if (type == 1) {
      // Item Code search
      callItemCommonSearch(context, index, 'Item', type);
    } else if (type == 2) {
      // UOM search
      callItemCommonSearch(context, index, 'UOM', type);
    } else if (type == 3) {
      // GL Code search
      callItemCommonSearch(context, index, 'GL_CODE', type);
    }
  }

  void callItemCommonSearch(
      BuildContext context, int updateIndex, String searchType, int type) {
    String url = ApiUrl.getItemDetailsSearch;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoItemDetailsSeraching(
          url: ApiUrl.baseUrl! + url,
          searchType: searchType,
          searchKeyWord: '',
          txnType: 'PO',
          supp_id: supp_id.toString(),
        ),
      ),
    ).then((value) {
      if (value != null && value is item_model.SearchList) {
        if (type == 1 && searchType == 'Item') {
          // Item Code search result
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];

            // Populate basic item information
            item.itemCode = value.itemCode ?? '';
            item.itemDesc = value.itemDescription ?? '';
            item.itemId = value.itemId;

            // Populate quantity fields - set initial API values
            item.quantity = '1'; // Default quantity
            // Set loose quantity from API data if available, otherwise leave empty
            item.looseQty = value.itemLooseQty?.toString() ?? '';
            item.baseQty = value.baseLooseQty?.toString() ?? '1';

            // Populate UOM information
            item.uom = value.uomCode ?? '';
            item.uomDesc = value.uomCode ??
                ''; // Using uomCode as desc if no separate desc field
            item.uomId = value.uomId;

            // Populate GL information
            item.glCode = value.glCode ?? '';
            item.glDesc = value.glDesc ?? '';
            item.glId = value.glCodeId;

            // Populate unit price if available
            if (value.stdRate != null && value.stdRate!.isNotEmpty) {
              item.unitPrice = value.stdRate;
            }

            // Update controllers if they exist
            if (item.quantityController != null) {
              item.quantityController!.text = item.quantity ?? '1';
            }
            if (item.unitPriceController != null && item.unitPrice != null) {
              item.unitPriceController!.text = item.unitPrice!;
            }
            if (item.discountValueController != null) {
              item.discountValueController!.text = item.discountVal ?? '0';
            }

            // Initialize calculated fields with API values or defaults
            if (item.grossValue == null || item.grossValue!.isEmpty) {
              item.grossValue = '0.00';
            }
            if (item.discountPer == null || item.discountPer!.isEmpty) {
              item.discountPer = '0';
            }
            if (item.discountVal == null || item.discountVal!.isEmpty) {
              item.discountVal = '0';
            }
            if (item.netValue == null || item.netValue!.isEmpty) {
              item.netValue = '0.00';
            }

            // Calculate initial values if unit price exists
            if (item.unitPrice != null && item.unitPrice!.isNotEmpty) {
              calculateGrossValue(updateIndex);
            }
          }
        } else if (type == 2) {
          // UOM search result - using item SearchList
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];
            item.uom = value.uomCode ?? '';
            item.uomDesc = value.uomCode ?? '';
            item.uomId = value.uomId;
          }
        } else if (type == 3) {
          // GL Code search result - using item SearchList
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];
            item.glCode = value.glCode ?? '';
            item.glDesc = value.glDesc ?? '';
            item.glId = value.glCodeId;
          }
        }
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers in organized groups
    _disposeDocumentControllers();
    _disposeReferenceControllers();
    _disposeSupplierControllers();
    _disposeFinancialControllers();
    _disposePaymentShippingControllers();
    _disposeChargeControllers();
    _disposeLocationTypeControllers();
    _disposeAdditionalControllers();
    _disposeRemarksControllers();

    _isDisposed = true;
    super.dispose();
  }

  /// Dispose Document Information Controllers
  void _disposeDocumentControllers() {
    docDateCtrl.dispose();
    docLocCodeCtrl.dispose();
    docLocDescCtrl.dispose();
    docNoTypeCtrl.dispose();
    docNoCtrl.dispose();
    statusCtrl.dispose();
  }

  /// Dispose Reference Information Controllers
  void _disposeReferenceControllers() {
    referenceCtrl.dispose();
    referenceDescCtrl.dispose();
    refDocCodeCtrl.dispose();
    refDocNoCtrl.dispose();
    refDocCtrl.dispose();
  }

  /// Dispose Supplier Information Controllers
  void _disposeSupplierControllers() {
    supplierCtrl.dispose();
    supOfferNoCtrl.dispose();
    supOfferDateCtrl.dispose();
    supplierCode.dispose();
    supplierDesc.dispose();
    supplierType.dispose();
    supplierTypeDesc.dispose();
    supplierAddress.dispose();
    supplierAddressDesc.dispose();
    crNoNumber.dispose();
    crNoExpiry.dispose();
    zakatNumber.dispose();
    zakatExpiry.dispose();
    vatNumber.dispose();
    vatExpiry.dispose();
  }

  /// Dispose Financial Information Controllers
  void _disposeFinancialControllers() {
    // Remove listeners before disposing
    valueCtrl.removeListener(_onValueControllerChanged);

    currencyCodeCtrl.dispose();
    currencyDescCtrl.dispose();
    exchangeRateCtrl.dispose();
    discountCtrl.dispose();
    valueCtrl.dispose();
  }

  /// Dispose Payment & Shipping Controllers
  void _disposePaymentShippingControllers() {
    paymentTermCtrl.dispose();
    modeShipmentCtrl.dispose();
    modePaymentCtrl.dispose();
    deliveryTermCodeCtrl.dispose();
    deliveryTermDescCtrl.dispose();
  }

  /// Dispose Charge Information Controllers
  void _disposeChargeControllers() {
    // Remove listeners before disposing
    chargeTypeCodeCtrl.removeListener(_onChargeTypeChanged);
    chargeTypeDescCtrl.removeListener(_onChargeTypeChanged);
    chargeToCodeCtrl.removeListener(_onChargeToChanged);
    chargeToDescCtrl.removeListener(_onChargeToChanged);

    chargeTypeCodeCtrl.dispose();
    chargeTypeDescCtrl.dispose();
    chargeToCodeCtrl.dispose();
    chargeToDescCtrl.dispose();
  }

  /// Dispose Location & Type Controllers
  void _disposeLocationTypeControllers() {
    shipToStoreCodeCtrl.dispose();
    shipToStoreDescCtrl.dispose();
    purchaseTypeCodeCtrl.dispose();
    purchaseTypeDescCtrl.dispose();
  }

  /// Dispose Additional Information Controllers
  void _disposeAdditionalControllers() {
    pettyCashCodeCtrl.dispose();
    pettyCashDescCtrl.dispose();
    buyerCodeCtrl.dispose();
    buyerDescCtrl.dispose();
    etaCtrl.dispose();
    needByDateCtrl.dispose();
  }

  /// Dispose Remarks & Comments Controllers
  void _disposeRemarksControllers() {
    remarkCtrl.dispose();
    remarkQuillController.dispose();
    submitRemarksCtrl.dispose();
  }

  // ==================== CONTROLLER UTILITY METHODS ====================

  /// Clear all document information controllers
  void clearDocumentControllers() {
    docDateCtrl.clear();
    docLocCodeCtrl.clear();
    docLocDescCtrl.clear();
    docNoTypeCtrl.clear();
    docNoCtrl.clear();
    statusCtrl.clear();
  }

  /// Clear all reference information controllers
  void clearReferenceControllers() {
    referenceCtrl.clear();
    referenceDescCtrl.clear();
    refDocCodeCtrl.clear();
    refDocNoCtrl.clear();
    refDocCtrl.clear();
    referenceSelectedCode = 'DIRECT';
  }

  /// Clear all supplier information controllers
  void clearSupplierControllers() {
    supplierCtrl.clear();
    supOfferNoCtrl.clear();
    supOfferDateCtrl.clear();
    supplierCode.clear();
    supplierDesc.clear();
    supplierType.clear();
    supplierTypeDesc.clear();
    supplierAddress.clear();
    supplierAddressDesc.clear();
    crNoSelected = false;
    zakatSelected = false;
    vatSelected = false;
    crNoNumber.clear();
    crNoExpiry.clear();
    zakatNumber.clear();
    zakatExpiry.clear();
    vatNumber.clear();
    vatExpiry.clear();
  }

  /// Clear all financial information controllers
  void clearFinancialControllers() {
    currencyCodeCtrl.clear();
    currencyDescCtrl.clear();
    exchangeRateCtrl.clear();
    discountCtrl.clear();
    valueCtrl.clear();
  }

  /// Clear all payment & shipping controllers
  void clearPaymentShippingControllers() {
    paymentTermCtrl.clear();
    modeShipmentCtrl.clear();
    modePaymentCtrl.clear();
    deliveryTermCodeCtrl.clear();
    deliveryTermDescCtrl.clear();
  }

  /// Clear all charge information controllers
  void clearChargeControllers() {
    chargeTypeCodeCtrl.clear();
    chargeTypeDescCtrl.clear();
    chargeToCodeCtrl.clear();
    chargeToDescCtrl.clear();
  }

  /// Clear all location & type controllers
  void clearLocationTypeControllers() {
    shipToStoreCodeCtrl.clear();
    shipToStoreDescCtrl.clear();
    purchaseTypeCodeCtrl.clear();
    purchaseTypeDescCtrl.clear();
  }

  /// Clear all additional information controllers
  void clearAdditionalControllers() {
    pettyCashCodeCtrl.clear();
    pettyCashDescCtrl.clear();
    buyerCodeCtrl.clear();
    buyerDescCtrl.clear();
    etaCtrl.clear();
    needByDateCtrl.clear();
  }

  /// Clear all remarks & comments controllers
  void clearRemarksControllers() {
    remarkCtrl.clear();
    remarkQuillController.clear();
    submitRemarksCtrl.clear();
  }

  /// Clear all controllers (useful for reset functionality)
  void clearAllControllers() {
    clearDocumentControllers();
    clearReferenceControllers();
    clearSupplierControllers();
    clearFinancialControllers();
    clearPaymentShippingControllers();
    clearChargeControllers();
    clearLocationTypeControllers();
    clearAdditionalControllers();
    clearRemarksControllers();
  }

  ///  Select/Deselect All in ItemDetailsTab
  void onItemDetailsSelectAll() {
    isActionAll = !isActionAll;

    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (var item in purchaseOrderModel!.itemDetailsTab!) {
        item.isSelected = isActionAll;
      }
    }

    selectedIndex.clear();
    if (isActionAll && purchaseOrderModel?.itemDetailsTab != null) {
      for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
        selectedIndex.add(i);
      }
    }
    if (!_isDisposed) notifyListeners();
  }

  void onItemDetailsSelected(int index) {
    final item = purchaseOrderModel!.itemDetailsTab![index];

    // Ensure null safety
    item.isSelected = !(item.isSelected ?? false);

    if (item.isSelected!) {
      selectedIndex.add(index);
    } else {
      selectedIndex.remove(index);
    }

    // Update "Select All" state
    isActionAll =
        selectedIndex.length == purchaseOrderModel!.itemDetailsTab!.length;

    notifyListeners();
  }

  ///  Add a new empty Item Line
  void addItemDetailsLine() {
    final currentDate = DateTime.now();
    final formattedDate =
        DateFormat('dd-MMM-yyyy', 'en_US').format(currentDate);

    var newItem = ItemDetailsTab(
      itemLineId: 0,
      txnNo: '',
      refDocNo: '',
      itemCode:
          '', // Empty initially - will be set when item is selected from API
      itemDesc: '',
      uom: '',
      quantity: '1',
      looseQty:
          '', // Empty initially - will be set only when item code is loaded from API
      baseQty: '1',
      unitPrice: '',
      grossValue: '0.00',
      discountPer: '0',
      discountVal: '0',
      netValue: '0.00',
      mnfDesc: '',
      chargeTypeCode:
          chargeTypeCodeCtrl.text.isNotEmpty ? chargeTypeCodeCtrl.text : '',
      chargeTypeName:
          chargeTypeDescCtrl.text.isNotEmpty ? chargeTypeDescCtrl.text : '',
      chargeToCode:
          chargeToCodeCtrl.text.isNotEmpty ? chargeToCodeCtrl.text : '',
      chargeToName:
          chargeToDescCtrl.text.isNotEmpty ? chargeToDescCtrl.text : '',
      needByDt: formattedDate,
      etaDate: '',
      glCode: '',
      glDesc: '',
      noteToReceiver: '',
      isSelected: false,
      isOpen: false,
      // Add controllers if your model supports
      quantityController: TextEditingController(text: '1'),
      unitPriceController: TextEditingController(),
      discountController: TextEditingController(text: '0'),
      discountValueController: TextEditingController(text: '0'),
      noteToReceiverController: TextEditingController(),
    );

    purchaseOrderModel?.itemDetailsTab ??= [];
    purchaseOrderModel!.itemDetailsTab!.add(newItem);

    if (!_isDisposed) notifyListeners();
  }

  /// Delete selected lines (or all if SelectAll is on)
  void deleteItemDetailsLine() {
    if (purchaseOrderModel?.itemDetailsTab == null) return;

    if (isActionAll) {
      purchaseOrderModel!.itemDetailsTab!.clear();
      selectedIndex.clear();
      isActionAll = false;
    } else {
      selectedIndex.sort((a, b) => b.compareTo(a)); // delete from back
      for (int i = 0; i < selectedIndex.length; i++) {
        purchaseOrderModel!.itemDetailsTab!.removeAt(selectedIndex[i]);
      }
      selectedIndex.clear();
    }
    if (!_isDisposed) notifyListeners();
  }

  void onItemAttachment(int index) {
    // Just prepare/update state related to attachments
    print("Open attachment for item $index");
  }

  void onItemTaxPopup(int index) {
    // Prepare/update state related to tax
    print("Open tax popup for item $index");
  }

  void addTaxPopup(TaxPopup popup) {
    taxPopups.add(popup);
    notifyListeners();
  }

  void deleteTaxPopup(int index) {
    if (index >= 0 && index < taxPopups.length) {
      taxPopups.removeAt(index);
      notifyListeners();
    }
  }
}
