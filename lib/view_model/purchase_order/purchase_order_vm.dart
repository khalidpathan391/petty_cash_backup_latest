// ignore_for_file: unused_field, prefer_function_declarations_over_variables, avoid_print, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, unnecessary_this, prefer_conditional_assignment, curly_braces_in_flow_control_structures, unused_catch_stack

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:petty_cash/data/models/common/common_searching_model.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';
import 'package:petty_cash/data/models/po_model.dart/po_transaction_model.dart';
import 'package:petty_cash/data/models/po_model.dart/item_details_model.dart'
    as item_model;
import 'package:petty_cash/data/models/po_model.dart/tax_search_list_model.dart'
    as tax_model;
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/global.dart';

import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/view/common/transaction_common/common_attachments.dart';
import 'package:petty_cash/view/po_transaction/common_pagination/CommonPaginationSearching.dart';
import 'package:petty_cash/view/po_transaction/pagination_searching/create_supplier_pagination.dart';
import 'package:petty_cash/view/po_transaction/pagination_searching/supplier_code_pagination.dart';
import 'package:petty_cash/view/po_transaction/pagination_searching/item_search_pagination.dart';
import 'package:petty_cash/data/models/po_model.dart/supplier_type_model.dart'
    as supplier_type;
import 'package:petty_cash/utils/app_utils.dart';

class PoApplicationVm extends ChangeNotifier {
  final GeneralRepository _myRepo = GeneralRepository();
  bool _isDisposed = false;
  List<String> tabHeaders = ['Header', 'Item Details'];
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
  final TextEditingController supplierHeaderCodeCtrl = TextEditingController();
  final TextEditingController supplierHeaderDescCtrl = TextEditingController();
  final TextEditingController supOfferNoCtrl = TextEditingController();
  final TextEditingController supOfferDateCtrl = TextEditingController();

  /// Additional Supplier Controllers (for supplier creation)
  final TextEditingController supplierCode = TextEditingController();
  final TextEditingController supplierDesc = TextEditingController();
  final TextEditingController supplierType = TextEditingController();
  final TextEditingController supplierTypeDesc = TextEditingController();
  final TextEditingController supplierAddress = TextEditingController();
  final TextEditingController supplierAddressDesc = TextEditingController();
  final TextEditingController supplierAddress2 = TextEditingController();

  /// Dynamic Supplier Validation Data
  List<supplier_type.SupplierValidation>? selectedSupplierValidation = [];

  /// Dynamic Validation Controllers
  Map<String, bool> dynamicValidationSelected = {};
  Map<String, TextEditingController> dynamicValidationNumbers = {};
  Map<String, TextEditingController> dynamicValidationExpiry = {};

  /// Fallback Validation Controllers (when no dynamic validation data)
  bool fallbackValidationSelected = false;
  int fallbackValidationTypeId = 0;
  final TextEditingController fallbackValidationType = TextEditingController();
  final TextEditingController fallbackValidationNumber =
      TextEditingController();
  final TextEditingController fallbackValidationExpiry =
      TextEditingController();

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
  final TextEditingController grossValueCtrl = TextEditingController();
  final TextEditingController discountValueCtrl = TextEditingController();
  final TextEditingController netValueCtrl = TextEditingController();

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
  late final quill.QuillController remarkQuillController;
  final TextEditingController submitRemarksCtrl = TextEditingController();
  final TextEditingController termsCtrl = TextEditingController();

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
  int reference = 0;
  int referenceId = 0;
  String refTxnType = '';
  int referenceDoc = 0;
  String docNo = '';

  ///
  // int docIndex = -1;
  // int txnIndex = -1;
  // int statusIndex = -1;
  // int remarkIndex = -1;

  // int docLocationIndex = -1;
  // int empCodeIndex = -1;
  // int needByDateIndex = -1;
  // int loanTypeCodeIndex = -1;
  // int loanTypeId = -1;
  // int earningCodeIndex = -1;
  // int earningTypeIndex = -1;
  // int deductionCodeIndex = -1;
  // int deductionTypeIndex = -1;
  // int amountIndex = -1;
  // int noOfInstalmentIndex = -1;
  // int maxAmountIndex = -1;
  // int periodFromIndex = -1;
  // int periodToIndex = -1;
  // int withPayrollIndex = -1;
  // int separateIndex = -1;
  // int installmentAmtIndex = -1;

  /// Additional Properties
  int supp_id = 0;
  int doc_id = 0;
  int currency_id = 0;
  int paymentTermId = 0;
  int modeOfShipId = 0;
  int modePaymentId = 0;
  int deliveryTermId = 0;
  int chargeTypeId = 0;
  int chargeToId = 0;
  int shipToStoreId = 0;
  int purchaseTypeId = 0;
  int pettyCashId = 0;
  int buyerId = 0;
  int deliveryTermCodeId = 0;
  int supplierTypeId = 0;
  int supplierAddressId = 0;
  int ceateSupplierTypeId = 0;
  String chargeTypeCode = '';
  // List<TaxPopup> taxPopups = [];

  void setDefault() {
    tabHeaders.clear();
    tabHeaders = ['Header', 'Item Details'];
    isWorkFlow = false;
    isWFTab = false;
    myHeaderId = -1;
    isSubmit = false;
    isApproved = false;
    notifyListeners();
  }

  PoApplicationVm() {
    // Initialize Quill controller with error handling
    try {
      remarkQuillController = quill.QuillController.basic();
    } catch (e) {
      remarkQuillController = quill.QuillController(
        document: quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
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
    discountCtrl.addListener(_onDiscountControllerChanged);
    valueCtrl.addListener(_onValueControllerChanged);
  }

  /// Handle discount controller changes
  void _onDiscountControllerChanged() {
    onDiscountChanged(discountCtrl.text);
  }

  /// Handle value controller changes
  void _onValueControllerChanged() {
    onValueChanged(valueCtrl.text);
  }

  /// Update header net value popup with current calculations
  void _updateHeaderNetValuePopup() {
    if (purchaseOrderModel?.headerNetValPopup == null) return;

    final totalItemGrossValue = getTotalGrossValue();
    final totalItemNetValue = _calculateTotalItemNetValue();
    final headerDiscount = getHeaderDiscountValue();
    final headerValue = getHeaderValue();

    for (var netValPopup in purchaseOrderModel!.headerNetValPopup!) {
      // Update item-level calculations
      netValPopup.itemGrossValue = totalItemGrossValue.toString();
      netValPopup.itemDiscount =
          getTotalDiscountValue().toString(); // Show total item discount
      netValPopup.itemGrossValAfterDis =
          totalItemNetValue.toString(); // Show item net value
      netValPopup.itemNetValue = totalItemNetValue.toString();

      // Update header-level calculations
      netValPopup.headerDiscount = headerDiscount.toString();

      // Calculate header net value: Item Details Net Value - Header Value
      final headerNetValue = totalItemNetValue - headerValue;
      netValPopup.headerNetValue = headerNetValue.toString();

      // Debug print to see what values we're working with
    }
  }

  /// Check mandatory fields for header tab
  Future<bool> checkHeaderMandatoryFields(BuildContext context) async {
    print("=== COMPREHENSIVE MANDATORY FIELD VALIDATION ===");

    // Set default values for mandatory fields before validation

    List<String> missingFields = [];

    // 2. Supplier (MANDATORY)
    if (supplierHeaderCodeCtrl.text.isEmpty ||
        supplierHeaderDescCtrl.text.isEmpty) {
      missingFields.add("Supplier");
    }

    // 8. Charge Type (MANDATORY)
    if (chargeTypeCodeCtrl.text.isEmpty || chargeTypeId == 0) {
      missingFields.add("Charge Type");
    }

    // 9. Charge To (MANDATORY)
    if (chargeToCodeCtrl.text.isEmpty || chargeToId == 0) {
      missingFields.add("Charge To");
    }

    // 10. Ship To Store Location (MANDATORY)
    if (shipToStoreCodeCtrl.text.isEmpty || shipToStoreId == 0) {
      missingFields.add("Ship To Store Location");
    }

    // 12. Petty Cash (MANDATORY)
    if (pettyCashCodeCtrl.text.isEmpty || pettyCashId == 0) {
      missingFields.add("Petty Cash");
    }

    // 13. Buyer (MANDATORY)
    if (buyerCodeCtrl.text.isEmpty || buyerId == 0) {
      missingFields.add("Buyer");
    }

    // 15. Reference Document (CONDITIONAL - only if reference is not 'D')
    if (referenceCtrl.text != 'D') {
      if (refDocCodeCtrl.text.isEmpty || referenceId == 0) {
        missingFields.add("Reference Document");
      }
    }

    // Check if there are any missing mandatory fields
    if (missingFields.isNotEmpty) {
      String errorMessage =
          "Please fill the following mandatory fields:\n• ${missingFields.join('\n• ')}";
      AppUtils.showToastRedBg(context, errorMessage);

      // Debug: Print missing fields

      for (String field in missingFields) {}

      return false;
    }

    // Validate item details if any exist
    if (purchaseOrderModel?.itemDetailsTab != null &&
        purchaseOrderModel!.itemDetailsTab!.isNotEmpty) {
      for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
        var item = purchaseOrderModel!.itemDetailsTab![i];

        // Check if item has required data
        if (item.itemCode == null || item.itemCode!.isEmpty) {
          AppUtils.showToastRedBg(
              context, "Item ${i + 1}: Item Code is required");
          return false;
        }

        if (item.quantity == null ||
            item.quantity!.isEmpty ||
            item.quantity == "0") {
          AppUtils.showToastRedBg(
              context, "Item ${i + 1}: Quantity is required");
          return false;
        }

        if (item.unitPrice == null ||
            item.unitPrice!.isEmpty ||
            item.unitPrice == "0") {
          AppUtils.showToastRedBg(
              context, "Item ${i + 1}: Unit Price is required");
          return false;
        }
      }
    } else {
      AppUtils.showToastRedBg(context, "At least one line item is required");
      return false;
    }

    if (referenceCtrl.text != 'D') {}

    return true;
  }

  /// Check mandatory fields for item details tab
  Future<bool> checkItemDetailsMandatoryFields(BuildContext context) async {
    print("Checking item details mandatory fields...");

    // For now, we'll implement basic validation
    // This can be expanded when the line items structure is available
    AppUtils.showToastRedBg(context,
        "Item details validation will be implemented when line items structure is available");

    print("Item details validation placeholder.");
    return true;
  }

  /// Get create/update data for API call

  bool isSaveSubmit = false;
  bool isSubmit = false;

  /// Prepare all data from UI controllers and populate the model
  /// Prepare all data from UI controllers and populate the model
  void prepareAllDataForSave() {
    // Ensure purchaseOrderModel exists
    purchaseOrderModel ??= PurchaseOrderModel();

    // ================= HEADER TAB =================
    purchaseOrderModel!.headerTab ??= HeaderTab();
    final headerTab = purchaseOrderModel!.headerTab!;

    // Document info
    headerTab.docDate = formatDateForBackend(docDateCtrl.text);
    headerTab.docLocCode = docLocCodeCtrl.text;
    headerTab.docLocDesc = docLocDescCtrl.text;
    headerTab.docLocId = doc_id;
    headerTab.txnNo = docNoCtrl.text;
    headerTab.txnType = docNoTypeCtrl.text;
    headerTab.statusCode = statusCtrl.text;

    // Reference
    headerTab.reference = referenceCtrl.text;
    headerTab.referenceDesc = referenceDescCtrl.text;
    headerTab.refDocId = referenceId;
    headerTab.refDocCode = refDocCodeCtrl.text;
    headerTab.refDocNo = refDocNoCtrl.text;

    // Supplier
    headerTab.supplierId = supp_id;
    headerTab.supplierCode = supplierHeaderCodeCtrl.text;
    headerTab.supplierName = supplierHeaderDescCtrl.text;
    headerTab.supplierOfferNo =
        supOfferNoCtrl.text.isEmpty ? '' : supOfferNoCtrl.text;
    headerTab.supplierOfferDate = formatDateForBackend(supOfferDateCtrl.text);

    // Currency & values
    headerTab.currencyId = currency_id;
    headerTab.currencyCode = currencyCodeCtrl.text;
    headerTab.currencyDescription = currencyDescCtrl.text;
    headerTab.exchangeRate = exchangeRateCtrl.text;
    headerTab.discount = discountCtrl.text;
    headerTab.value = valueCtrl.text;
    headerTab.grossValue = grossValueCtrl.text;
    headerTab.discountValue = discountValueCtrl.text;
    headerTab.netValue = netValueCtrl.text;

    // Payment / Shipment / Delivery
    headerTab.paymentTermId = paymentTermId;
    headerTab.paymentTermCode = paymentTermCtrl.text;
    headerTab.modeOfShipmentId = modeOfShipId;
    headerTab.modeOfShipmentCode = modeShipmentCtrl.text;
    headerTab.modeOfPaymentId = modePaymentId;
    headerTab.modeOfPaymentCode = modePaymentCtrl.text;
    headerTab.deliveryTermId = deliveryTermId;
    headerTab.deliveryTermCode = deliveryTermCodeCtrl.text;
    headerTab.deliveryTermDesc = deliveryTermDescCtrl.text;

    // Charge / Ship To
    headerTab.chargeTypeId = chargeTypeId;
    headerTab.chargeTypeCode = chargeTypeCodeCtrl.text;
    headerTab.chargeTypeDescription = chargeTypeDescCtrl.text;
    headerTab.chargeToId = chargeToId;
    headerTab.chargeToCode = chargeToCodeCtrl.text;
    headerTab.chargeToDescription = chargeToDescCtrl.text;
    headerTab.shipToStoreLocId = shipToStoreId;
    headerTab.shipToStoreLocCode = shipToStoreCodeCtrl.text;
    headerTab.shipToStoreLocDescription = shipToStoreDescCtrl.text;

    // Purchase Type / Petty Cash
    headerTab.purchaseTypeId = purchaseTypeId;
    headerTab.purchaseTypeCode = purchaseTypeCodeCtrl.text;
    headerTab.purchaseTypeDesc = purchaseTypeDescCtrl.text;
    headerTab.pettyCashId = pettyCashId;
    headerTab.pettyCashCode = pettyCashCodeCtrl.text;
    headerTab.pettyCashDesc = pettyCashDescCtrl.text;

    // Buyer
    headerTab.buyerId = buyerId;
    headerTab.buyerCode = buyerCodeCtrl.text;
    headerTab.buyerDesc = buyerDescCtrl.text;

    // Dates / Others
    headerTab.headerEta = formatDateForBackend(etaCtrl.text);
    headerTab.needByDate = formatDateForBackend(needByDateCtrl.text);
    headerTab.remark = remarkCtrl.text;
    headerTab.terms = termsCtrl.text;
    saveTermsData();

    // Supplier creation data
    headerTab.supplierCode = supplierHeaderCodeCtrl.text;
    headerTab.supplierDesc = supplierHeaderDescCtrl.text;
    headerTab.supplierType = supplierType.text;
    headerTab.supplierTypeDesc = supplierTypeDesc.text;
    headerTab.supplierAddress = supplierAddress.text;
    headerTab.supplierAddressDesc = supplierAddressDesc.text;
    headerTab.supplierAddress2 = supplierAddress2.text;

    // Validation data
    headerTab.crNoSelected = crNoSelected;
    headerTab.crNoNumber = crNoNumber.text;
    headerTab.crNoExpiry = formatDateForBackend(crNoExpiry.text);
    headerTab.zakatSelected = zakatSelected;
    headerTab.zakatNumber = zakatNumber.text;
    headerTab.zakatExpiry = formatDateForBackend(zakatExpiry.text);
    headerTab.vatSelected = vatSelected;
    headerTab.vatNumber = vatNumber.text;
    headerTab.vatExpiry = formatDateForBackend(vatExpiry.text);

    // Dynamic validations
    headerTab.dynamicValidationSelected = dynamicValidationSelected;
    headerTab.dynamicValidationNumbers =
        dynamicValidationNumbers.map((key, ctrl) => MapEntry(key, ctrl.text));
    headerTab.dynamicValidationExpiry = dynamicValidationExpiry
        .map((key, ctrl) => MapEntry(key, formatDateForBackend(ctrl.text)));

    // Fallback validation
    headerTab.fallbackValidationSelected = fallbackValidationSelected;
    headerTab.fallbackValidationType = fallbackValidationType.text;
    headerTab.fallbackValidationNumber = fallbackValidationNumber.text;
    headerTab.fallbackValidationExpiry =
        formatDateForBackend(fallbackValidationExpiry.text);

    // ================= ITEM DETAILS =================
    purchaseOrderModel!.itemDetailsTab ??= [];
    for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
      var item = purchaseOrderModel!.itemDetailsTab![i];

      // Preserve original & convert dates
      item.needByDt = formatDateForBackend(item.needByDt ?? '');
      item.etaDate = formatDateForBackend(item.etaDate ?? '');

      // From controller if available
      if (item.noteToReceiverController != null) {
        item.noteToReceiver = item.noteToReceiverController!.text;
      }

      // Recalculate values
      calculateGrossValue(i);

      // Copy header charge info
      item.chargeTypeId = chargeTypeId;
      item.chargeTypeCode = chargeTypeCodeCtrl.text;
      item.chargeTypeName = chargeTypeDescCtrl.text;
      item.chargeToId = chargeToId;
      item.chargeToCode = chargeToCodeCtrl.text;
      item.chargeToName = chargeToDescCtrl.text;
    }

    // ================= HEADER NET VALUE =================
    final totalItemNetValue = _calculateTotalItemNetValue();
    final headerDiscount = getHeaderDiscountValue();
    final headerValue = double.tryParse(valueCtrl.text) ?? 0.0;
    final headerNetValue = totalItemNetValue - headerValue;

    if (purchaseOrderModel!.headerNetValPopup != null &&
        purchaseOrderModel!.headerNetValPopup!.isNotEmpty) {
      for (var netValPopup in purchaseOrderModel!.headerNetValPopup!) {
        netValPopup.itemGrossValue = totalItemNetValue.toString();
        netValPopup.itemDiscount = headerDiscount.toString();
        netValPopup.itemGrossValAfterDis =
            (totalItemNetValue - headerDiscount).toString();
        netValPopup.itemNetValue =
            (totalItemNetValue - headerDiscount).toString();
        netValPopup.headerDiscount = headerDiscount.toString();
        netValPopup.headerNetValue = headerNetValue.toString();
      }
    } else {
      purchaseOrderModel!.headerNetValPopup = [
        HeaderNetValPopup(
          itemGrossValue: totalItemNetValue.toString(),
          itemDiscount: headerDiscount.toString(),
          itemGrossValAfterDis: (totalItemNetValue - headerDiscount).toString(),
          itemNetValue: (totalItemNetValue - headerDiscount).toString(),
          headerDiscount: headerDiscount.toString(),
          headerNetValue: headerNetValue.toString(),
        )
      ];
    }

    // ================= CREATE SUPPLIER =================
    // Prepare validation data for supplier creation
    List<SuppValidation> validationList = [];

    // Add fallback validation if selected
    if (fallbackValidationSelected && fallbackValidationType.text.isNotEmpty) {
      validationList.add(SuppValidation(
        validationTypeId: fallbackValidationTypeId,
        validationTypeName: fallbackValidationType.text,
        validationNumber: fallbackValidationNumber.text,
        validationExpyDate: fallbackValidationExpiry.text,
      ));
    }

    // Add dynamic validations if any
    for (var entry in dynamicValidationSelected.entries) {
      if (entry.value && dynamicValidationNumbers.containsKey(entry.key)) {
        // Find the validation type ID from selectedSupplierValidation
        int validationTypeId = 0;
        if (selectedSupplierValidation != null) {
          for (var validation in selectedSupplierValidation!) {
            if (validation.fieldCode == entry.key ||
                validation.fieldName == entry.key) {
              validationTypeId = validation.fieldId ?? 0;
              break;
            }
          }
        }

        validationList.add(SuppValidation(
          validationTypeId: validationTypeId,
          validationTypeName: entry.key,
          validationNumber: dynamicValidationNumbers[entry.key]?.text ?? '',
          validationExpyDate: dynamicValidationExpiry[entry.key]?.text ?? '',
        ));
      }
    }

    purchaseOrderModel!.createSupplier = [
      CreateSupplier(
        crSuppCode: supplierCode.text.isEmpty ? '' : supplierCode.text,
        crSuppDesc: supplierDesc.text.isEmpty ? '' : supplierDesc.text,
        crSuppTypeId: ceateSupplierTypeId,
        crSuppTypeCode: supplierType.text.isEmpty ? '' : supplierType.text,
        crSuppTypeDesc:
            supplierTypeDesc.text.isEmpty ? '' : supplierTypeDesc.text,
        crSuppAddressId: supplierAddressId,
        crSuppAddressCode:
            supplierAddress.text.isEmpty ? '' : supplierAddress.text,
        crSuppAddressDesc:
            supplierAddressDesc.text.isEmpty ? '' : supplierAddressDesc.text,
        suppValidation: validationList.isNotEmpty ? validationList : null,
      )
    ];

    // ================= ALWAYS EMPTY LISTS =================
    purchaseOrderModel!.referencePR = [];
    purchaseOrderModel!.headerAttachmentLst = [];
    purchaseOrderModel!.apprvlLvlStatus = [];
  }

  Map<String, String> getCreateData() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'header_id': myHeaderId != -1 ? myHeaderId.toString() : '0',
      'is_view': '0',
      'is_submit': '0',
      'po_detail_all_data': sendData,
      'default': '0',
    };
    return data;
  }

  /// Save/Update Purchase Order API call
  Future<void> callPurchaseOrderSaveUpdate(BuildContext context,
      {bool isSubmit = false}) async {
    // Show the loader while the operation is in progress
    AppUtils.customLoader(context);

    // Check mandatory fields before proceeding
    isSaveSubmit = await checkHeaderMandatoryFields(context);

    if (isSaveSubmit) {
      isSaveSubmit = false;

      // Set the submit flag
      this.isSubmit = isSubmit;

      // Prepare all data from UI controllers
      prepareAllDataForSave();

      // Ensure all line items have their tax popup data saved
      _saveAllTaxPopupData();

      // Prepare data for API
      sendData = jsonEncode(purchaseOrderModel);
      print("senddata333:$sendData");
      Map<String, String> data = getCreateData();
      String url = ApiUrl.baseUrl! + ApiUrl.getPoTransaction;
      print("senddata:$sendData");
      await _myRepo.postApi(url, data).then((value) async {
        print("value:$value");
        if (value['error_code'] == 200) {
          AppUtils.showToastGreenBg(
              context, value['error_description'].toString());

          setDefault();

          // Try to load the saved data, but don't let it interfere with success
          try {
            await callPoView(value['header_id']);
          } catch (e) {
            print("Warning: Could not reload data after save: $e");
            // Don't show error to user since save was successful
          }
        } else {
          AppUtils.showToastRedBg(
              context, value['error_description'].toString());
        }
      }).onError((error, stackTrace) {
        if (AppUtils.errorMessage.isEmpty) {
          AppUtils.errorMessage = error.toString();
        }
        AppUtils.showToastRedBg(context, 'Error: $error');
      }).whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  Map<String, String> getSubmitData() {
    Map<String, String> data = {
      'company_id': Global.empData!.companyId.toString(),
      'user_id': Global.empData!.userId.toString(),
      'header_id': myHeaderId != -1 ? myHeaderId.toString() : '0',
      'is_view': '0',
      'is_submit': '1',
      'po_detail_all_data': sendData,
      'default': '0',
    };
    return data;
  }

  /// Submit Purchase Order API call
  Future<void> callPurchaseOrderSubmit(BuildContext context) async {
    // Show the loader while the operation is in progress
    AppUtils.customLoader(context);

    // Check mandatory fields before proceeding
    isSaveSubmit = await checkHeaderMandatoryFields(context);

    if (isSaveSubmit) {
      isSaveSubmit = false;

      // Set the submit flag to true for submission
      this.isSubmit = true;

      // Prepare all data from UI controllers
      prepareAllDataForSave();

      // Ensure all line items have their tax popup data saved
      _saveAllTaxPopupData();

      // Prepare data for API
      sendData = jsonEncode(purchaseOrderModel);
      Map<String, String> data = getSubmitData();
      String url = ApiUrl.baseUrl! + ApiUrl.getPoTransaction;

      await _myRepo.postApi(url, data).then((value) async {
        if (value['error_code'] == 200) {
          AppUtils.showToastGreenBg(
              context, value['error_description'].toString());

          setDefault();

          // Try to load the saved data, but don't let it interfere with success
          try {
            await callPoView(value['header_id']);
          } catch (e) {
            print("Warning: Could not reload data after save: $e");
            // Don't show error to user since save was successful
          }
        } else {
          AppUtils.showToastRedBg(
              context, value['error_description'].toString());
        }
      }).onError((error, stackTrace) {
        if (AppUtils.errorMessage.isEmpty) {
          AppUtils.errorMessage = error.toString();
        }
        AppUtils.showToastRedBg(context, 'Error: $error');
      }).whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
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

  void setLoading(bool val) {
    isLoading = val;
    if (!_isDisposed) notifyListeners();
  }

  void onDiscountChanged(String value) {
    // Only calculate if item details are filled
    if (hasItemDetailsFilled()) {
      _calculateHeaderValueFromDiscount();
    }
    // Update header popup when discount changes
    _updateHeaderNetValuePopup();
    if (!_isDisposed) notifyListeners();
  }

  void onValueChanged(String value) {
    // Only calculate if item details are filled
    if (hasItemDetailsFilled()) {
      _calculateHeaderDiscountFromValue();
    }
    // Update header popup when value changes
    _updateHeaderNetValuePopup();
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

      // Calculate value as: (Total Item Net Value * Discount Percentage) / 100
      // This gives the discount value based on percentage
      final calculatedValue = (totalItemNetValue * discount) / 100;
      valueCtrl.text = calculatedValue.toStringAsFixed(2);
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

      // Calculate discount percentage as: (Header Value / Total Item Net Value) * 100
      // This gives the discount percentage based on value
      final calculatedDiscount =
          totalItemNetValue > 0 ? (value / totalItemNetValue) * 100 : 0;
      discountCtrl.text = calculatedDiscount.toStringAsFixed(2);
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

  /// Get final net value (item details - header value)
  double getFinalNetValue() {
    final itemNetValue = getTotalNetValue();
    final headerValue = getHeaderValue();
    return itemNetValue - headerValue;
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

    // If quantity is cleared or zero, clear related fields
    if (value.isEmpty || value == '0' || quantity == 0) {
      item.baseQty = '0';
      item.looseQty = '0';
      item.unitPrice = '0';
      item.grossValue = '0.00';
      item.discountPer = '0';
      item.discountVal = '0';
      item.netValue = '0.00';

      // Clear controllers
      if (item.unitPriceController != null) {
        item.unitPriceController!.text = '0';
      }
      if (item.discountController != null) {
        item.discountController!.text = '0';
      }
      if (item.discountValueController != null) {
        item.discountValueController!.text = '0';
      }
    } else {
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
      if (item.unitPrice != null &&
          item.unitPrice!.isNotEmpty &&
          item.unitPrice != '0') {
        calculateGrossValue(index);
      }
    }

    // Update header popup when line items change
    _updateHeaderNetValuePopup();

    if (!_isDisposed) notifyListeners();
  }

  /// Calculate gross value when unit price changes
  void onUnitPriceChanged(String value, int index) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        index < 0 ||
        index >= purchaseOrderModel!.itemDetailsTab!.length) return;

    final item = purchaseOrderModel!.itemDetailsTab![index];
    final unitPrice = double.tryParse(value) ?? 0.0;

    // Update unit price field
    item.unitPrice = value;
    if (item.unitPriceController != null) {
      item.unitPriceController!.text = value;
    }

    // If unit price is cleared or zero, clear related fields
    if (value.isEmpty || value == '0' || unitPrice == 0) {
      item.grossValue = '0.00';
      item.discountPer = '0';
      item.discountVal = '0';
      item.netValue = '0.00';

      // Clear controllers
      if (item.discountController != null) {
        item.discountController!.text = '0';
      }
      if (item.discountValueController != null) {
        item.discountValueController!.text = '0';
      }
    } else {
      // Calculate gross value if quantity exists
      if (item.quantity != null &&
          item.quantity!.isNotEmpty &&
          item.quantity != '0') {
        calculateGrossValue(index);
      }
    }

    // Update header popup when line items change
    _updateHeaderNetValuePopup();

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

    // Update controllers
    if (item.grossValueController != null) {
      item.grossValueController!.text = item.grossValue!;
    }

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

    // Update header popup when line items change
    _updateHeaderNetValuePopup();

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

    // Update header popup when line items change
    _updateHeaderNetValuePopup();

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

    // Update header totals after line item calculation
    calculateHeaderTotals();

    if (!_isDisposed) notifyListeners();
  }

  void setApiLoading(bool val) {
    isApiLoading = val;
    if (!_isDisposed) notifyListeners();
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
    try {
      final len = remarkQuillController.document.length;
      if (len > 0) {
        remarkQuillController.document.delete(0, len);
      }
      if (remarkCtrl.text.isNotEmpty) {
        remarkQuillController.document.insert(0, remarkCtrl.text);
      }
      // Clear any invalid selection
      remarkQuillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.local,
      );
    } catch (e) {
      print('Error updating Quill from text: $e');
      // Reset the document if there's an error
      remarkQuillController.document = quill.Document();
    }
  }

  void setRemarkFromQuill() {
    try {
      remarkCtrl.text = remarkQuillController.document.toPlainText().trim();
    } catch (e) {
      print('Error getting text from Quill: $e');
      remarkCtrl.text = '';
    }
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

    myHeaderId = headerId;
    Global.transactionHeaderId = headerId.toString();

    // Reset submit and approval flags when loading a new transaction
    isSubmit = false;
    isApproved = false;

    // For new transactions (headerId == -1), ensure all flags are reset
    if (headerId == -1) {
      isWorkFlow = false;
      isWFTab = false;
      tabHeaders = ['Header', 'Item Details'];
    }

    String url = ApiUrl.baseUrl! + ApiUrl.getPoTransaction;

    try {
      final dynamic response = await _myRepo.postApi(url, getData(headerId));

      if (response != null) {
        // Load status first before parsing the full model
        if (response['header_tab'] != null) {
          final headerTab = response['header_tab'];
          statusCtrl.text = headerTab['status_description']?.toString() ?? '';
          print('🔍 Direct status load from API: "${statusCtrl.text}"');

          // Check WorkFlow tab immediately after loading status
          final currentStatus = statusCtrl.text.trim().toUpperCase();
          if (currentStatus == 'SUBMITTED') {
            isWorkFlow = true;
            isWFTab = true;
            isSubmit = true; // Set submit flag for submitted transactions
            isApproved = false; // Not approved yet
            if (!tabHeaders.contains('WorkFlow')) {
              tabHeaders.add('WorkFlow');
            }
            print('🔍 WorkFlow tab added for SUBMITTED status');
          } else if (currentStatus == 'APPROVED') {
            isWorkFlow = true;
            isWFTab = true;
            isSubmit = true; // Submitted
            isApproved = true; // Approved
            if (!tabHeaders.contains('WorkFlow')) {
              tabHeaders.add('WorkFlow');
            }
            print('🔍 WorkFlow tab added for APPROVED status');
          } else {
            isWorkFlow = false;
            isWFTab = false;
            isSubmit = false; // Not submitted
            isApproved = false; // Not approved
            tabHeaders.removeWhere((tab) => tab == 'WorkFlow');
            print('🔍 WorkFlow tab removed for status: $currentStatus');
          }
        }

        try {
          purchaseOrderModel = PurchaseOrderModel.fromJson(response);
        } catch (parseError) {
          print('Error parsing PurchaseOrderModel: $parseError');
          // Continue with status already loaded above
        }

        if (purchaseOrderModel?.headerId != null) {
          myHeaderId = purchaseOrderModel!.headerId!;
          Global.transactionHeaderId = myHeaderId.toString();
        }

        if (purchaseOrderModel?.headerTab != null) {
          // Debug: Print full header data from API
          print(
              '🔍 HeaderTab statusDescription: "${purchaseOrderModel!.headerTab!.statusDescription}"');
          print(
              '🔍 HeaderTab toJson(): ${purchaseOrderModel!.headerTab!.toJson()}');
          print('🔍 About to call _applyHeaderData with headerTab data');

          _applyHeaderData(purchaseOrderModel!.headerTab!.toJson());

          print(
              '🔍 After _applyHeaderData - statusCtrl.text: "${statusCtrl.text}"');
          hasDataLoaded = true;
        }

        if (purchaseOrderModel?.itemDetailsTab == null ||
            purchaseOrderModel!.itemDetailsTab!.isEmpty) {
          addItemDetailsLine();
        } else {
          for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
            final item = purchaseOrderModel!.itemDetailsTab![i];
            item.isOpen = false;

            // Initialize controllers for existing line items if they don't exist
            item.quantityController ??=
                TextEditingController(text: item.quantity ?? '1');
            item.unitPriceController ??=
                TextEditingController(text: item.unitPrice ?? '');
            item.grossValueController ??=
                TextEditingController(text: item.grossValue ?? '0.00');
            item.discountController ??=
                TextEditingController(text: item.discountPer ?? '0');
            item.discountValueController ??=
                TextEditingController(text: item.discountVal ?? '0');
            item.noteToReceiverController ??=
                TextEditingController(text: item.noteToReceiver ?? '');

            // Initialize tax popup list if it doesn't exist, but don't add empty entries
            item.taxPopup ??= [];

            if (purchaseOrderModel?.headerTab != null) {
              final headerData = purchaseOrderModel!.headerTab!;
              item.chargeTypeCode = headerData.chargeTypeCode ?? '';
              item.chargeTypeName = headerData.chargeTypeDescription ?? '';
              item.chargeToCode = headerData.chargeToCode ?? '';
              item.chargeToName = headerData.chargeToDescription ?? '';
            }
          }
        }

        // Ensure all line items have at least one empty tax popup entry
        _ensureAllLineItemsHaveTaxPopup();

        // Calculate header totals after loading data
        calculateHeaderTotals();
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
    Map<String, String> data = {};
    if (myHeaderId == -1) {
      data = {
        'company_id': Global.empData!.companyId.toString(),
        'user_id': Global.empData!.userId.toString(),
        'default': '1',
        'is_view': '0',
        'header_id': '0',
        'is_submit': '0',
      };
    } else {
      data = {
        'company_id': Global.empData!.companyId.toString(),
        'user_id': Global.empData!.userId.toString(),
        'default': '0',
        'is_view': '1',
        'is_submit': '0',
        'header_id': myHeaderId.toString(),
      };
    }
    return data;
  }

  void _applyHeaderData(Map<String, dynamic> h) {
    docDateCtrl.text = _s(h['doc_date']);
    docLocCodeCtrl.text = _s(h['doc_loc_code']);
    docLocDescCtrl.text = _s(h['doc_loc_desc']);
    docNoTypeCtrl.text = _s(h['txn_type']);
    docNoCtrl.text = _s(h['txn_no']);

    referenceCtrl.text = _s(h['reference']);
    referenceDescCtrl.text = _s(h['reference_desc']);
    referenceSelectedCode =
        referenceDescCtrl.text.isEmpty ? 'DIRECT' : referenceDescCtrl.text;

    // Supplier - concatenate code and description
    // final supplierHeadCode = _s(h['supplier_code']);
    // final supplierHeadDesc = _s(h['supplier_name']);
    supplierHeaderCodeCtrl.text = _s(h['supplier_code']);
    supplierHeaderDescCtrl.text = _s(h['supplier_name']);

    // supplierHeaderCodeCtrl.text =
    //     supplierHeadCode.isNotEmpty && supplierHeadDesc.isNotEmpty
    //         ? '$supplierHeadCode - $supplierHeadDesc'
    //         : supplierHeadDesc.isNotEmpty
    //             ? supplierHeadDesc
    //             : supplierHeadCode;

    supOfferNoCtrl.text = _s(h['supplier_offer_no']);
    supOfferDateCtrl.text = _s(h['supplier_offer_date']);
    currencyCodeCtrl.text = _s(h['currency_code']);
    currencyDescCtrl.text = _s(h['currency_description']);
    exchangeRateCtrl.text = _s(h['exchange_rate']);
    discountCtrl.text = _s(h['discount']);
    valueCtrl.text = _s(h['value']);

    // Payment Term - concatenate code and description
    final paymentTermCode = _s(h['payment_term_code']);
    final paymentTermDesc = _s(h['payment_term_desc']);
    // paymentTermCtrl.text =
    //     paymentTermCode.isNotEmpty && paymentTermDesc.isNotEmpty
    //         ? '$paymentTermCode - $paymentTermDesc'
    //         : paymentTermDesc.isNotEmpty
    //             ? paymentTermDesc
    //             : paymentTermCode;

    // Mode of Shipment - concatenate code and description
    final modeShipmentCode = _s(h['mode_of_shipment_code']);
    final modeShipmentDesc = _s(h['mode_of_shipment_desc']);
    modeShipmentCtrl.text =
        modeShipmentCode.isNotEmpty && modeShipmentDesc.isNotEmpty
            ? '$modeShipmentCode - $modeShipmentDesc'
            : modeShipmentDesc.isNotEmpty
                ? modeShipmentDesc
                : modeShipmentCode;

    // Mode of Payment - concatenate code and description
    final modePaymentCode = _s(h['mode_of_payment_code']);
    final modePaymentDesc = _s(h['mode_of_payment_desc']);
    modePaymentCtrl.text =
        modePaymentCode.isNotEmpty && modePaymentDesc.isNotEmpty
            ? '$modePaymentCode - $modePaymentDesc'
            : modePaymentDesc.isNotEmpty
                ? modePaymentDesc
                : modePaymentCode;

    // Charge Type - concatenate code and description
    chargeTypeCodeCtrl.text = _s(h['charge_type_code']);
    chargeTypeDescCtrl.text = _s(h['charge_type_description']);
    // chargeTypeCodeCtrl.text =
    //     chargeTypeCode.isNotEmpty && chargeTypeDesc.isNotEmpty
    //         ? '$chargeTypeCode - $chargeTypeDesc'
    //         : chargeTypeDesc.isNotEmpty
    //             ? chargeTypeDesc
    //             : chargeTypeCode;
    // chargeTypeDescCtrl.text = chargeTypeDesc;
    // Set chargeTypeCode variable for charge to search functionality
    // this.chargeTypeCode = chargeTypeCode;

    // Charge To - concatenate code and description
    chargeToCodeCtrl.text = _s(h['charge_to_code']);
    chargeToDescCtrl.text = _s(h['charge_to_description']);
    // chargeToCodeCtrl.text = chargeToCode.isNotEmpty && chargeToDesc.isNotEmpty
    //     ? '$chargeToCode - $chargeToDesc'
    //     : chargeToDesc.isNotEmpty
    //         ? chargeToDesc
    //         : chargeToCode;
    // chargeToDescCtrl.text = chargeToDesc;

    // Ship To Store - concatenate code and description
    shipToStoreCodeCtrl.text = _s(h['ship_to_store_loc_code']);
    shipToStoreDescCtrl.text = _s(h['ship_to_store_loc_description']);
    // shipToStoreCodeCtrl.text =
    //     shipToStoreCode.isNotEmpty && shipToStoreDesc.isNotEmpty
    //         ? '$shipToStoreCode - $shipToStoreDesc'
    //         : shipToStoreDesc.isNotEmpty
    //             ? shipToStoreDesc
    //             : shipToStoreCode;
    // shipToStoreDescCtrl.text = shipToStoreDesc;

    // Purchase Type - concatenate code and description
    final purchaseTypeCode = _s(h['purchase_type_code']);
    final purchaseTypeDesc = _s(h['purchase_type_desc']);
    purchaseTypeCodeCtrl.text =
        purchaseTypeCode.isNotEmpty && purchaseTypeDesc.isNotEmpty
            ? '$purchaseTypeCode - $purchaseTypeDesc'
            : purchaseTypeDesc.isNotEmpty
                ? purchaseTypeDesc
                : purchaseTypeCode;
    purchaseTypeDescCtrl.text = purchaseTypeDesc;

    // Petty Cash - concatenate code and description
    pettyCashCodeCtrl.text = _s(h['petty_cash_code']);
    pettyCashDescCtrl.text = _s(h['petty_cash_desc']);
    // pettyCashCodeCtrl.text =
    //     pettyCashCode.isNotEmpty && pettyCashDesc.isNotEmpty
    //         ? '$pettyCashCode - $pettyCashDesc'
    //         : pettyCashDesc.isNotEmpty
    //             ? pettyCashDesc
    //             : pettyCashCode;
    // pettyCashDescCtrl.text = pettyCashDesc;

    // Buyer - concatenate code and description
    buyerCodeCtrl.text = _s(h['buyer_code']);
    buyerDescCtrl.text = _s(h['buyer_desc']);
    // buyerCodeCtrl.text = buyerCode.isNotEmpty && buyerDesc.isNotEmpty
    //     ? '$buyerCode - $buyerDesc'
    //     : buyerDesc.isNotEmpty
    //         ? buyerDesc
    //         : buyerCode;
    // buyerDescCtrl.text = buyerDesc;

    etaCtrl.text = _s(h['header_eta']);

    // Delivery Term - concatenate code and description
    final deliveryTermCode = _s(h['delivery_term_code']);
    final deliveryTermDesc = _s(h['delivery_term_desc']);
    deliveryTermCodeCtrl.text =
        deliveryTermCode.isNotEmpty && deliveryTermDesc.isNotEmpty
            ? '$deliveryTermCode - $deliveryTermDesc'
            : deliveryTermDesc.isNotEmpty
                ? deliveryTermDesc
                : deliveryTermCode;
    deliveryTermDescCtrl.text = deliveryTermDesc;
    needByDateCtrl.text = _s(h['need_by_date']);
    remarkCtrl.text = _s(h['remark']);
    termsCtrl.text = _s(h['header_term_popup']);

    // Update header values from header_net_val_popup if available
    if (purchaseOrderModel?.headerNetValPopup != null &&
        purchaseOrderModel!.headerNetValPopup!.isNotEmpty) {
      final headerPopup = purchaseOrderModel!.headerNetValPopup![0];

      // Update controllers with header popup values
      grossValueCtrl.text = _s(headerPopup.itemGrossValue);
      discountValueCtrl.text = _s(headerPopup.itemDiscount);
      netValueCtrl.text = _s(headerPopup.itemNetValue);

      // Update header tab model
      if (purchaseOrderModel?.headerTab != null) {
        purchaseOrderModel!.headerTab!.grossValue =
            _s(headerPopup.itemGrossValue);
        purchaseOrderModel!.headerTab!.discountValue =
            _s(headerPopup.itemDiscount);
        purchaseOrderModel!.headerTab!.netValue = _s(headerPopup.itemNetValue);
      }
    } else {
      // Fallback to header_tab values if header_net_val_popup is not available
      print('🔍 Using fallback header values from header_tab');
      grossValueCtrl.text = _s(h['gross_value']);
      discountValueCtrl.text = _s(h['discount_value']);
      netValueCtrl.text = _s(h['net_value']);

      // Update header tab model with values from API
      if (purchaseOrderModel?.headerTab != null) {
        purchaseOrderModel!.headerTab!.grossValue = _s(h['gross_value']);
        purchaseOrderModel!.headerTab!.discountValue = _s(h['discount_value']);
        purchaseOrderModel!.headerTab!.netValue = _s(h['net_value']);
      }
    }

    // Debug: Print terms data from API

    doc_id = h['doc_loc_id'] ?? 0;
    supp_id = h['supplier_id'] ?? 0;
    currency_id = h['currency_id'] ?? 0;
    paymentTermId = h['payment_term_id'] ?? 0;
    modeOfShipId = h['mode_of_shipment_id'] ?? 0;
    modePaymentId = h['mode_of_payment_id'] ?? 0;
    chargeTypeId = h['charge_type_id'] ?? 0;
    chargeToId = h['charge_to_id'] ?? 0;
    shipToStoreId = h['ship_to_store_loc_id'] ?? 0;
    purchaseTypeId = h['purchase_type_id'] ?? 0;
    pettyCashId = h['petty_cash_id'] ?? 0;
    buyerId = h['buyer_id'] ?? 0;
    _updateRemarkQuillFromText();

    if (!_isDisposed) notifyListeners();
  }

  String _s(dynamic v) {
    final result = v == null ? '' : v.toString();
    if (v != null && result.isEmpty) {
      print(
          '🔍 _s() function: Input was not null but result is empty. Input: "$v", Type: ${v.runtimeType}');
    }
    if (v != null && v.toString().toLowerCase().contains('status')) {
      print('🔍 _s() function processing status: Input="$v", Result="$result"');
    }
    return result;
  }

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
    print("Debug - searchField called with fieldName: '$fieldName'");
    String searchType = '';

    switch (fieldName) {
      case 'Doc. Loc.*':
        searchType = 'Location';
        break;
      case 'Supplier*':
        searchType = 'Supplier';
        break;
      case 'Supplier Code':
        searchType = 'SUPPLIER_CODE';
        break;
      case 'Supplier Type':
        searchType = 'SUPPLIER_TYPE';
        break;
      // case 'Currency*':
      //   searchType = 'Currency';

      //   break;
      // case 'Payment Term*':
      //   searchType = 'PAYMENT_TERM';
      //   break;
      // case 'Mode of Shipment*':
      //   searchType = 'MODE_OF_SHIPMENT';
      //   break;
      // case 'Mode of Payment*':
      //   searchType = 'MODE_OF_PAYMENT';
      //   break;
      case 'Charge Type*':
        searchType = 'CHARGE_TYPE';
        break;
      case 'Charge To*':
        searchType = 'CHARGE_TO';
        break;
      case 'Ship to Store Loc*':
        searchType = 'STORE_LOCATION';
        break;
      // case 'Purchase Type*':
      //   searchType = 'PURCHASE_TYPE';
      //   break;
      case 'Petty Cash No*':
        searchType = 'PETTY_CASH_NO';
        break;
      case 'Buyer ID*':
        searchType = 'BUYER_ID';
        break;
      // case 'Delivery Term*':
      //   searchType = 'DELIVERY_TERM';
      //   break;
      default:
        searchType = '';
    }

    print("Debug - searchType set to: '$searchType'");

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
        // case 'Doc. Loc.*':
        //   docLocCodeCtrl.text = result.code ?? '';
        //   docLocDescCtrl.text = result.desc ?? '';
        //   doc_id = result.id ?? doc_id;
        //   purchaseOrderModel?.headerTab?.docLocId = doc_id;

        //   break;
        case 'Supplier*':
          supplierHeaderCodeCtrl.text = result.code ?? '';
          supplierHeaderDescCtrl.text = result.desc ?? '';

          supp_id = result.id ?? 0;
          break;
        case 'Supplier Code':
          // Handle supplier code search result - this case is handled by callSupplierCodeSearch method
          // No need to handle here as it's a separate flow
          break;
        // case 'Currency*':
        //   currencyCodeCtrl.text = result.code ?? '';
        //   currencyDescCtrl.text = result.desc ?? '';
        //   currency_id = result.id ?? currency_id; // update local variable
        //   purchaseOrderModel?.headerTab?.currencyId = currency_id;

        //   break;
        // case 'Payment Term*':
        //   paymentTermCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
        //   paymentTermId = result.id ?? 0;
        //   break;
        // case 'Mode of Shipment*':
        //   modeShipmentCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
        //   modeOfShipId = result.id ?? 0;
        //   break;
        // case 'Mode of Payment*':
        //   modePaymentCtrl.text = '${result.code ?? ''} - ${result.desc ?? ''}';
        //   modePaymentId = result.id ?? 0;
        //   break;
        case 'Charge Type*':
          chargeTypeCodeCtrl.text = result.code ?? '';
          chargeTypeDescCtrl.text = result.desc ?? '';
          chargeTypeId = result.id ?? chargeTypeId; // update local variable
          purchaseOrderModel?.headerTab?.chargeTypeId = chargeTypeId;
          chargeTypeCode = result.code ?? '';

          if (purchaseOrderModel?.itemDetailsTab != null) {
            for (final item in purchaseOrderModel!.itemDetailsTab!) {
              item.chargeTypeId = chargeTypeId;
              item.chargeTypeCode = result.code ?? '';
              item.chargeTypeName = result.desc ?? '';
            }
          }
          break;
        case 'Charge To*':
          chargeToCodeCtrl.text = result.code ?? '';
          chargeToDescCtrl.text = result.desc ?? '';
          chargeToId = result.id ?? 0;
          purchaseOrderModel?.headerTab?.chargeToId = chargeToId;

          if (purchaseOrderModel?.itemDetailsTab != null) {
            for (final item in purchaseOrderModel!.itemDetailsTab!) {
              item.chargeToId = chargeToId;
              item.chargeToCode = result.code ?? '';
              item.chargeToName = result.desc ?? '';
            }
          }
          break;
        case 'Supplier Type':
          supplierType.text = result.code ?? '';
          supplierTypeDesc.text = result.desc ?? '';
          supplierTypeId = result.id ?? 0;
          break;
        case 'Address Code':
          supplierAddress.text = result.code ?? '';
          supplierAddressId = result.id ?? 0;
          break;
        case 'Address Description':
          supplierAddressDesc.text = result.desc ?? '';
          break;
        case 'Ship to Store Loc*':
          shipToStoreCodeCtrl.text = result.code ?? '';
          shipToStoreDescCtrl.text = result.desc ?? '';
          shipToStoreId = result.id ?? 0;
          break;
        // case 'Purchase Type*':
        //   purchaseTypeCodeCtrl.text = result.code ?? '';
        //   purchaseTypeDescCtrl.text = result.desc ?? '';
        //   purchaseTypeId = result.id ?? 0;
        //   break;
        case 'Petty Cash No*':
          pettyCashCodeCtrl.text = result.code ?? '';
          pettyCashDescCtrl.text = result.desc ?? '';
          pettyCashId = result.id ?? 0;
          break;
        case 'Buyer ID*':
          buyerCodeCtrl.text = result.code ?? '';
          buyerDescCtrl.text = result.desc ?? '';
          buyerId = result.id ?? buyerId; // update local variable
          purchaseOrderModel?.headerTab?.buyerId = buyerId; // update model
          chargeTypeCode = result.code ?? '';
          break;
        // case 'Delivery Term*':
        //   deliveryTermCodeCtrl.text = result.code ?? '';
        //   deliveryTermDescCtrl.text = result.desc ?? '';
        //   deliveryTermId = result.id ?? 0;
        //   break;
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

  /// Get filtered reference PR list (excluding already added items)
  List<ReferencePR> getFilteredReferencePRList() {
    if (referencePRModel.referencePR == null) return [];

    // Get all priLineIds that are already in item details
    Set<int> addedPriLineIds = {};
    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (var item in purchaseOrderModel!.itemDetailsTab!) {
        if (item.refItemMappId != null) {
          addedPriLineIds.add(item.refItemMappId!);
        }
      }
    }

    // Filter out reference PR items that are already added
    return referencePRModel.referencePR!.where((pr) {
      return !addedPriLineIds.contains(pr.priLineId);
    }).toList();
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

          // Calculate the next serial number for reference PR items
          int nextSrNo = 1;
          if (purchaseOrderModel?.itemDetailsTab != null &&
              purchaseOrderModel!.itemDetailsTab!.isNotEmpty) {
            // Find the highest srNo and add 1
            int maxSrNo = purchaseOrderModel!.itemDetailsTab!
                .map((item) => item.srNo ?? 0)
                .reduce((a, b) => a > b ? a : b);
            nextSrNo = maxSrNo + 1;
          }
          newItem.srNo = nextSrNo;

          // Initialize controllers for the new item
          newItem.discountController =
              TextEditingController(text: newItem.discountPer ?? '0');
          newItem.discountValueController =
              TextEditingController(text: newItem.discountVal ?? '0');
          newItem.quantityController =
              TextEditingController(text: newItem.quantity ?? '');
          newItem.unitPriceController =
              TextEditingController(text: newItem.unitPrice ?? '');
          newItem.grossValueController =
              TextEditingController(text: newItem.grossValue ?? '0.00');
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

          // Initialize tax popup as empty list, don't add empty entries
          newItem.taxPopup ??= [];

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

  // ===================== Supplier Code Search Flow =====================
  void callSupplierCodeSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSupplierCodePagination(
          url: ApiUrl.baseUrl! + ApiUrl.getSupplierCodeSearchList,
          searchType: '',
          searchKeyWord: '',
          txnType: 'PO',
          crSuppId: ceateSupplierTypeId.toString(),
        ),
      ),
    ).then((value) {
      if (value != null && value is supplier_type.SearchList) {
        // Handle supplier type search result
        ceateSupplierTypeId = value.id ?? 0;
        supplierType.text = value.code ?? '';
        supplierTypeDesc.text = value.name ?? '';
        // Note: This is for supplier type, not supplier code, so we don't update supp_id here

        // Update supplier validation data if available
        if (value.supplierValidation != null &&
            value.supplierValidation!.isNotEmpty) {
          selectedSupplierValidation = value.supplierValidation;

          // Initialize dynamic validation controllers
          _initializeDynamicValidationControllers();

          print('Supplier validation data: ${value.supplierValidation}');
        } else {
          // Clear validation data if no validation fields
          selectedSupplierValidation = [];
          _clearDynamicValidationControllers();
        }

        notifyListeners();
      }
    });
  }

  // ===================== Supplier Address Search Flow =====================
  void callSupplierAddressSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSupplierCodePagination(
          url: ApiUrl.baseUrl! + ApiUrl.getSupplierAdddressSearchList,
          searchType: '',
          searchKeyWord: '',
          txnType: '',
        ),
      ),
    ).then((value) {
      if (value != null && value is supplier_type.SearchList) {
        // Handle supplier address search result
        supplierAddressId = value.id ?? 0;
        supplierAddress.text = value.code ?? '';
        supplierAddressDesc.text = value.desc ?? '';
        supplierAddress2.text = value.name ?? '';

        // Update supplier validation data if available
        if (value.supplierValidation != null &&
            value.supplierValidation!.isNotEmpty) {
          // You can process supplier validation data here if needed
          print(
              'Supplier address validation data: ${value.supplierValidation}');
        }

        notifyListeners();
      }
    });
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
    } else if (type == 4) {
      // Tax popup search - handled directly in header1Search callback
      // No need to call again here
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
            if (item.grossValueController != null) {
              item.grossValueController!.text = item.grossValue ?? '0.00';
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

  // ===================== Tax Popup Search Flow =====================
  void callItemTaxSearch(
      BuildContext context, int parentIndex, int taxIndex, int type) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        parentIndex < 0 ||
        parentIndex >= purchaseOrderModel!.itemDetailsTab!.length) {
      return;
    }

    // Check if net value is empty or 0 before opening tax popup
    final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];
    String? netValue = itemDetails.netValue;

    // Allow tax popup to open for all items - no validation needed

    if (type == 1) {
      // Tax Code search
      callTaxPopupCommonSearch(context, parentIndex, taxIndex, 'CODE');
    }
    print('=== TAX SEARCH DEBUG END ===');
  }

  void callTaxPopupCommonSearch(
      BuildContext context, int parentIndex, int taxIndex, String searchType) {
    String url = ApiUrl.getTaxSearchList;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSupplierPagination(
          url: ApiUrl.baseUrl! + url,
          searchType: searchType,
          searchKeyWord: '',
          txnType: 'PO',
        ),
      ),
    ).then((value) {
      if (value != null && value is tax_model.SearchList) {
        final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];

        itemDetails.taxPopup ??= [];
        // Only add tax entries when user actually selects a tax, not empty ones
        if (itemDetails.taxPopup!.length <= taxIndex) {
          // Create a new tax entry only when needed
          itemDetails.taxPopup!.add(TaxPopup(
            srNo: taxIndex + 1,
            taxLineId: 0,
            taxId: 0,
            taxCode: '',
            currencyId: 2, // Default currency
            currencyCode: 'SAR',
            discountPercent: '0',
            discountValue: '0',
            discountLcvalue: '0',
            taxRemark: '',
            taxBasis: '',
          ));
        }

        final taxPopup = itemDetails.taxPopup![taxIndex];

        taxPopup.taxCode = value.code ?? '';
        taxPopup.discountPercent = value.percent ?? '0';

        taxPopup.taxBasis = value.basis ?? '';
        taxPopup.taxId = value.id;

        // Calculate tax amounts based on line item net value
        _calculateTaxAmounts(parentIndex, taxIndex);

        taxPopup.taxPopUpPercentController?.text =
            taxPopup.discountPercent ?? '';
        taxPopup.taxPopUpRemarksController?.text = taxPopup.taxRemark ?? '';

        notifyListeners();
      }
    });
  }

  // Calculate tax amounts based on line item net value
  void _calculateTaxAmounts(int parentIndex, int taxIndex) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        parentIndex < 0 ||
        parentIndex >= purchaseOrderModel!.itemDetailsTab!.length ||
        taxIndex < 0 ||
        taxIndex >=
            purchaseOrderModel!.itemDetailsTab![parentIndex].taxPopup!.length) {
      return;
    }

    final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];
    final taxPopup = itemDetails.taxPopup![taxIndex];

    // Get the line item net value
    double netValue = 0.0;
    try {
      netValue = double.parse(itemDetails.netValue ?? '0');
    } catch (e) {
      netValue = 0.0;
    }

    // Get the tax percentage
    double taxPercent = 0.0;
    try {
      taxPercent = double.parse(taxPopup.discountPercent ?? '0');
    } catch (e) {
      taxPercent = 0.0;
    }

    // Calculate tax amount
    double taxAmount = (netValue * taxPercent) / 100;

    // For LC Amount, we'll use the same calculation for now
    // You can modify this if there's a different exchange rate logic
    double lcAmount = taxAmount;

    // Update the tax popup with calculated values
    taxPopup.discountValue = taxAmount.toStringAsFixed(2);
    taxPopup.discountLcvalue = lcAmount.toStringAsFixed(2);
  }

  /// Save terms data to header tab
  void saveTermsData() {
    if (purchaseOrderModel?.headerTab != null) {
      purchaseOrderModel!.headerTab!.terms = termsCtrl.text;

      notifyListeners();
    }
  }

  /// Calculate and update header totals
  void calculateHeaderTotals() {
    if (purchaseOrderModel?.headerTab == null) return;

    final headerTab = purchaseOrderModel!.headerTab!;

    // Calculate totals from line items
    double totalGrossValue = 0.0;
    double totalDiscountValue = 0.0;
    double totalNetValue = 0.0;

    if (purchaseOrderModel?.itemDetailsTab != null) {
      for (final item in purchaseOrderModel!.itemDetailsTab!) {
        try {
          totalGrossValue += double.tryParse(item.grossValue ?? '0') ?? 0.0;
          totalDiscountValue += double.tryParse(item.discountVal ?? '0') ?? 0.0;
          totalNetValue += double.tryParse(item.netValue ?? '0') ?? 0.0;
        } catch (e) {
          print('Error parsing item values: $e');
        }
      }
    }

    // Update header values
    headerTab.grossValue = totalGrossValue.toStringAsFixed(2);
    headerTab.discountValue = totalDiscountValue.toStringAsFixed(2);
    headerTab.netValue = totalNetValue.toStringAsFixed(2);

    // Update controllers
    grossValueCtrl.text = headerTab.grossValue ?? '0.00';
    discountValueCtrl.text = headerTab.discountValue ?? '0.00';
    netValueCtrl.text = headerTab.netValue ?? '0.00';

    notifyListeners();
  }

  /// Ensure all line items have at least one empty tax popup entry
  void _ensureAllLineItemsHaveTaxPopup() {
    if (purchaseOrderModel?.itemDetailsTab == null) return;

    for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
      final itemDetails = purchaseOrderModel!.itemDetailsTab![i];
      // Only initialize as empty list, don't add empty entries
      itemDetails.taxPopup ??= [];
      print(
          'Ensured tax popup list exists for line item ${i + 1} (${itemDetails.taxPopup!.length} entries)');
    }
  }

  /// Save all tax popup data for all line items
  void _saveAllTaxPopupData() {
    if (purchaseOrderModel?.itemDetailsTab == null) {
      return;
    }

    print(
        'Processing ${purchaseOrderModel!.itemDetailsTab!.length} line items');
    for (int i = 0; i < purchaseOrderModel!.itemDetailsTab!.length; i++) {
      final itemDetails = purchaseOrderModel!.itemDetailsTab![i];
      final taxPopupList = itemDetails.taxPopup;

      // If tax popup is null or empty, set it to empty list to avoid backend errors
      if (taxPopupList == null || taxPopupList.isEmpty) {
        itemDetails.taxPopup = [];
        continue;
      }

      // Check if tax popup has any valid data (not just empty entries)
      bool hasValidData = false;
      for (var popup in taxPopupList) {
        // Check if any meaningful data is filled
        bool hasTaxCode = popup.taxCode != null &&
            popup.taxCode!.isNotEmpty &&
            popup.taxCode != "";
        bool hasTaxId = popup.taxId != null && popup.taxId! > 0;
        bool hasPercent =
            popup.taxPopUpPercentController?.text.isNotEmpty == true &&
                popup.taxPopUpPercentController!.text != "0" &&
                popup.taxPopUpPercentController!.text != "";
        bool hasValue = popup.discountValue != null &&
            popup.discountValue!.isNotEmpty &&
            popup.discountValue != "0" &&
            popup.discountValue != "";
        bool hasRemarks =
            popup.taxPopUpRemarksController?.text.isNotEmpty == true;

        if (hasTaxCode || hasTaxId || hasPercent || hasValue || hasRemarks) {
          hasValidData = true;
          break;
        }
      }

      // If no valid data, set to empty list
      if (!hasValidData) {
        print('Item $i: No valid tax data found, setting to empty list');
        itemDetails.taxPopup = [];
        continue;
      } else {
        print('Item $i: Valid tax data found, processing...');
      }

      // Save tax popup data directly from controllers to model fields
      for (var popup in taxPopupList) {
        popup.taxCode = popup.taxCode ?? '';
        popup.taxId = popup.taxId ?? 0;
        popup.discountPercent = popup.taxPopUpPercentController?.text ?? '';
        popup.discountValue = popup.discountValue ?? '';
        popup.discountLcvalue = popup.discountLcvalue ?? '';
        popup.taxRemark = popup.taxPopUpRemarksController?.text ?? '';
        popup.taxBasis = popup.taxBasis ?? '';
        popup.currencyCode = popup.currencyCode ?? '';
        popup.currencyId = popup.currencyId ?? 0;
      }
    }
    print('=== _saveAllTaxPopupData END ===');
  }

  // Save tax popup data to line item
  void saveTaxPopupData(BuildContext context, int parentIndex) {
    if (purchaseOrderModel?.itemDetailsTab == null ||
        parentIndex < 0 ||
        parentIndex >= purchaseOrderModel!.itemDetailsTab!.length) {
      AppUtils.showToastRedBg(context, 'Invalid line item');
      return;
    }

    final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];
    final taxPopupList = itemDetails.taxPopup;

    if (taxPopupList == null || taxPopupList.isEmpty) {
      AppUtils.showToastRedBg(context, 'No tax data to save');
      return;
    }

    // Save tax popup data directly from controllers to model fields
    for (var popup in taxPopupList) {
      popup.taxCode = popup.taxCode ?? '';
      popup.taxId = popup.taxId ?? 0;
      popup.discountPercent = popup.taxPopUpPercentController?.text ?? '';
      popup.discountValue = popup.discountValue ?? '';
      popup.discountLcvalue = popup.discountLcvalue ?? '';
      popup.taxRemark = popup.taxPopUpRemarksController?.text ?? '';
      popup.taxBasis = popup.taxBasis ?? '';
      popup.currencyCode = popup.currencyCode ?? '';
      popup.currencyId = popup.currencyId ?? 0;
    }

    // Show success message
    AppUtils.showToastGreenBg(context, 'Tax data saved successfully');

    // Close the popup
    Navigator.pop(context);

    // Notify listeners to update UI
    notifyListeners();
  }

  // ===================== Dynamic Validation Helper Methods =====================

  /// Initialize dynamic validation controllers based on selected supplier type
  void _initializeDynamicValidationControllers() {
    if (selectedSupplierValidation == null) return;

    // Clear existing controllers
    _clearDynamicValidationControllers();

    // Initialize new controllers for each validation field
    for (var validation in selectedSupplierValidation!) {
      String fieldKey = validation.fieldCode ?? validation.fieldName ?? '';
      if (fieldKey.isNotEmpty) {
        // Initialize selection state (default to true if mandatory)
        dynamicValidationSelected[fieldKey] = validation.defaultTf == 1;

        // Initialize number controller
        dynamicValidationNumbers[fieldKey] = TextEditingController();

        // Initialize expiry controller for all validation fields
        dynamicValidationExpiry[fieldKey] = TextEditingController();
      }
    }
  }

  /// Clear all dynamic validation controllers
  void _clearDynamicValidationControllers() {
    // Dispose existing controllers
    for (var controller in dynamicValidationNumbers.values) {
      controller.dispose();
    }
    for (var controller in dynamicValidationExpiry.values) {
      controller.dispose();
    }

    // Clear maps
    dynamicValidationSelected.clear();
    dynamicValidationNumbers.clear();
    dynamicValidationExpiry.clear();
  }

  /// Dispose fallback validation controllers
  void _disposeFallbackValidationControllers() {
    fallbackValidationType.dispose();
    fallbackValidationNumber.dispose();
    fallbackValidationExpiry.dispose();
  }

  /// Update dynamic validation selection
  void updateDynamicValidationSelection(String fieldKey, bool value) {
    dynamicValidationSelected[fieldKey] = value;
    notifyListeners();
  }

  /// Update fallback validation selection
  void updateFallbackValidationSelection(bool value) {
    fallbackValidationSelected = value;
    notifyListeners();
  }

  /// Update fallback validation type
  void updateFallbackValidationType(String type) {
    fallbackValidationType.text = type;
    notifyListeners();
  }

  // ===================== Supplier Validation Type Search API =====================

  /// Call CreateSupplierValidationTypeSearch API to get validation types
  void callSupplierValidationTypeSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSupplierCodePagination(
          url: ApiUrl.baseUrl! + ApiUrl.createSupplierValidationTypeSearch,
          searchType: '',
          searchKeyWord: '',
          txnType: 'PO',
          crSuppId: ceateSupplierTypeId.toString(),
        ),
      ),
    ).then((value) {
      if (value != null && value is supplier_type.SearchList) {
        // Handle validation type search result
        fallbackValidationType.text = value.name ?? '';

        // Store the validation type ID for API call
        fallbackValidationTypeId = value.id ?? 0;

        // Update the validation type field with selected value
        notifyListeners();
      }
    });
  }

  /// Create Supplier Directly - Call CreateSupplierFromPo API
  Future<void> createSupplierDirectly(BuildContext context) async {
    try {
      // Show loading indicator
      AppUtils.customLoader(context);

      // Prepare all data from UI controllers
      prepareAllDataForSave();

      // Prepare data for API
      Map<String, String> data = {
        'company_id': '2',
        'user_id': Global.empData!.userId.toString(),
        'po_detail_all_data': jsonEncode(purchaseOrderModel),
      };

      String url = ApiUrl.baseUrl! + ApiUrl.createSupplier;

      await _myRepo.postApi(url, data).then((response) {
        Navigator.pop(context); // Hide loader

        if (response != null && response['error'] == false) {
          // Show success message
          AppUtils.showToastGreenBg(context,
              response['error_description'] ?? 'Supplier created successfully');

          // Clear all supplier controllers
          clearSupplierControllers();

          // Close the popup
          Navigator.pop(context);

          // Ensure all line items have at least one empty tax popup entry
          _ensureAllLineItemsHaveTaxPopup();

          // Notify listeners to update UI
          notifyListeners();
        } else {
          AppUtils.showToastRedBg(context,
              response['error_description'] ?? 'Failed to create supplier');
        }
      });
    } catch (e) {
      Navigator.pop(context); // Hide loader
      AppUtils.showToastRedBg(context, 'Error creating supplier: $e');
    }
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
    _clearDynamicValidationControllers();
    _disposeFallbackValidationControllers();

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
    supplierCode.dispose();
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
    discountCtrl.removeListener(_onDiscountControllerChanged);
    valueCtrl.removeListener(_onValueControllerChanged);

    currencyCodeCtrl.dispose();
    currencyDescCtrl.dispose();
    exchangeRateCtrl.dispose();
    discountCtrl.dispose();
    valueCtrl.dispose();
    grossValueCtrl.dispose();
    discountValueCtrl.dispose();
    netValueCtrl.dispose();
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
    termsCtrl.dispose();
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
    supplierCode.clear();
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
    try {
      remarkQuillController.clear();
      // Ensure selection is reset after clearing
      remarkQuillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.local,
      );
    } catch (e) {
      print('Error clearing Quill controller: $e');
      // Reset the document if clearing fails
      remarkQuillController.document = quill.Document();
    }
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

  /// Tax Popup Methods

  /// Select/Deselect individual tax item
  void onTaxPopupSelected(int parentIndex, int index) {
    final tax =
        purchaseOrderModel!.itemDetailsTab![parentIndex].taxPopup![index];

    // Ensure null safety
    tax.isSelected = !tax.isSelected;

    notifyListeners();
  }

  TaxPopup onTaxPopupAddRow(int index) {
    var taxPopupLine = TaxPopup();
    taxPopupLine.srNo = 0;
    taxPopupLine.taxLineId = 0;
    taxPopupLine.taxId = 0;
    taxPopupLine.taxCode = '';
    taxPopupLine.currencyId = 0;
    taxPopupLine.currencyCode = '';
    taxPopupLine.discountPercent = '';
    taxPopupLine.discountValue = '';
    taxPopupLine.discountLcvalue = '';
    taxPopupLine.taxRemark = '';
    taxPopupLine.taxBasis = '';
    taxPopupLine.taxPopUpPercentController = TextEditingController(text: '');
    taxPopupLine.taxPopUpRemarksController = TextEditingController(text: '');

    purchaseOrderModel?.itemDetailsTab![index].taxPopup?.add(taxPopupLine);
    notifyListeners();
    return taxPopupLine;
  }

  ///  Add a new empty Item Line
  void addItemDetailsLine() {
    print('=== ADDING NEW LINE ITEM ===');

    try {
      final currentDate = DateTime.now();
      final formattedDate =
          DateFormat('dd-MMM-yyyy', 'en_US').format(currentDate);

      // Calculate the next serial number
      int nextSrNo = 1;
      if (purchaseOrderModel?.itemDetailsTab != null &&
          purchaseOrderModel!.itemDetailsTab!.isNotEmpty) {
        // Find the highest srNo and add 1
        int maxSrNo = purchaseOrderModel!.itemDetailsTab!
            .map((item) => item.srNo ?? 0)
            .reduce((a, b) => a > b ? a : b);
        nextSrNo = maxSrNo + 1;
      } else {
        print('No existing items. Using srNo: $nextSrNo');
      }

      var newItem = ItemDetailsTab(
        srNo: nextSrNo,
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
        chargeTypeId: chargeTypeId,
        chargeTypeCode:
            chargeTypeCodeCtrl.text.isNotEmpty ? chargeTypeCodeCtrl.text : '',
        chargeTypeName:
            chargeTypeDescCtrl.text.isNotEmpty ? chargeTypeDescCtrl.text : '',
        chargeToId: chargeToId,
        chargeToCode:
            chargeToCodeCtrl.text.isNotEmpty ? chargeToCodeCtrl.text : '',
        chargeToName:
            chargeToDescCtrl.text.isNotEmpty ? chargeToDescCtrl.text : '',
        needByDt: formattedDate,
        etaDate: formattedDate,
        glCode: '',
        glDesc: '',
        noteToReceiver: '',
        isSelected: false,
        isOpen: false,
        taxPopup: [], // Initialize with empty list - only add entries when user opens tax popup
        // Add controllers if your model supports
        quantityController: TextEditingController(text: '1'),
        unitPriceController: TextEditingController(),
        discountController: TextEditingController(text: '0'),
        discountValueController: TextEditingController(text: '0'),
        noteToReceiverController: TextEditingController(),
      );

      purchaseOrderModel?.itemDetailsTab ??= [];
      purchaseOrderModel!.itemDetailsTab!.add(newItem);

      // Debug: Verify the item was actually added
      if (purchaseOrderModel!.itemDetailsTab!.isNotEmpty) {
        final lastItem = purchaseOrderModel!.itemDetailsTab!.last;
      }

      if (!_isDisposed) notifyListeners();
    } catch (e, stackTrace) {
      // Re-throw the error so it can be handled by the calling code
      rethrow;
    }
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

  void toggleTaxPopupOpen(int parentIndex, int taxIndex) {
    if (purchaseOrderModel?.itemDetailsTab != null &&
        parentIndex >= 0 &&
        parentIndex < purchaseOrderModel!.itemDetailsTab!.length) {
      final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];
      if (itemDetails.taxPopup != null &&
          taxIndex >= 0 &&
          taxIndex < itemDetails.taxPopup!.length) {
        itemDetails.taxPopup![taxIndex].isOpen =
            !itemDetails.taxPopup![taxIndex].isOpen;
        notifyListeners();
      }
    }
  }

  // Date Formate
  String formatDateForBackend(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "";
    try {
      // Case 1: Already in backend format (08-Sep-2025)
      final parsed = DateFormat("dd-MMM-yyyy").parse(dateStr);
      return DateFormat("dd-MMM-yyyy").format(parsed);
    } catch (_) {
      try {
        // Case 2: Flutter often gives yyyy-MM-dd (2025-09-08)
        final parsed = DateFormat("yyyy-MM-dd").parse(dateStr);
        return DateFormat("dd-MMM-yyyy").format(parsed);
      } catch (_) {
        // Fallback → send as is
        return dateStr;
      }
    }
  }

  void updateTaxPopupControllers(int parentIndex, int taxIndex) {
    if (purchaseOrderModel?.itemDetailsTab != null &&
        parentIndex >= 0 &&
        parentIndex < purchaseOrderModel!.itemDetailsTab!.length) {
      final itemDetails = purchaseOrderModel!.itemDetailsTab![parentIndex];
      if (itemDetails.taxPopup != null &&
          taxIndex >= 0 &&
          taxIndex < itemDetails.taxPopup!.length) {
        final taxPopup = itemDetails.taxPopup![taxIndex];
        // Update controller values to match the data
        taxPopup.taxPopUpPercentController?.text =
            taxPopup.discountPercent ?? '';
        taxPopup.taxPopUpRemarksController?.text = taxPopup.taxRemark ?? '';
        notifyListeners();
      }
    }
  }

  void headerAttachment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonAttachment(
          txnType: Global.subTxnType,
          docNo: docNo,
          tab: '',
          //  purchaseOrderModel!.headerAttachmentLst![0].tab,
          uniqueVal: purchaseOrderModel?.uniqueVal ?? '72801757444041',

          headerId: myHeaderId == -1 ? '0' : myHeaderId.toString(),
          lineId: '', //for header it is empty
        ),
      ),
    ).then((value) {
      if (value != null) {
        // headerAttachmentLength = value[0];
        if (Global.headerAttachmentList.isNotEmpty) {
          purchaseOrderModel!.headerAttachmentLst = value[1];
        }
        notifyListeners();
      }
    });
  }
}
