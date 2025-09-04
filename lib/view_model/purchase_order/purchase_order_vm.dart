// ignore_for_file: unused_field, prefer_function_declarations_over_variables, avoid_print, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:petty_cash/data/models/common/common_searching_model.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';
import 'package:petty_cash/data/models/po_model.dart/po_transaction_model.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/global.dart';

import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/view/po_transaction/common/CommonPaginationSearching.dart';
import 'package:petty_cash/view/po_transaction/item_search_agination.dart';

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
  int supp_id = 0;
  String chargeTypeCode = '';

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
        }
        // Initialize isOpen for item lines to support UI expansion
        if (purchaseOrderModel?.itemDetailsTab != null) {
          for (final item in purchaseOrderModel!.itemDetailsTab!) {
            item.isOpen = false;
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
          break;
        case 'Charge To*':
          chargeToCodeCtrl.text = result.code ?? '';
          chargeToDescCtrl.text = result.desc ?? '';
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

  // ===================== Item Search Flow =====================
  void callItemSearch(BuildContext context, int index, int type) {
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
      if (value != null && value is SearchList) {
        if (type == 1 && searchType == 'ITEM') {
          // Item Code search result
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];
            item.itemCode = value.code ?? '';
            item.itemDesc = value.desc ?? '';
            item.itemId = value.id;

            // Update controllers if they exist
            if (item.quantityController != null) {
              item.quantityController!.text = item.quantity ?? '1';
            }
          }
        } else if (type == 2) {
          // UOM search result
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];
            item.uom = value.code ?? '';
            item.uomDesc = value.desc ?? '';
            item.uomId = value.id;
          }
        } else if (type == 3) {
          // GL Code search result
          if (purchaseOrderModel?.itemDetailsTab != null &&
              updateIndex >= 0 &&
              updateIndex < purchaseOrderModel!.itemDetailsTab!.length) {
            final item = purchaseOrderModel!.itemDetailsTab![updateIndex];
            item.glCode = value.code ?? '';
            item.glDesc = value.desc ?? '';
            item.glId = value.id;
          }
        }
        notifyListeners();
      }
    });
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
      itemCode: '',
      itemDesc: '',
      uom: '',
      quantity: '',
      looseQty: '',
      baseQty: '',
      unitPrice: '',
      grossValue: '',
      discountPer: '',
      discountVal: '',
      netValue: '',
      mnfDesc: '',
      chargeTypeCode: '',
      chargeTypeName: '',
      chargeToCode: '',
      chargeToName: '',
      needByDt: formattedDate,
      etaDate: '',
      glCode: '',
      glDesc: '',
      noteToReceiver: '',
      isSelected: false,
      isOpen: false,
      // Add controllers if your model supports
      quantityController: TextEditingController(),
      unitPriceController: TextEditingController(),
      discountController: TextEditingController(),
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

  List<TaxPopup> taxPopups = [];

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
