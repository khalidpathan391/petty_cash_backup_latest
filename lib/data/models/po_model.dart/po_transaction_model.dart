// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/common/common_work_flow_model.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';

class PurchaseOrderModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  int? menuId;
  String? uniqueVal;
  int? headerId;
  HeaderTab? headerTab;
  List<HeaderAttchLst>? headerAttachmentLst;
  List<CreateSupplier>? createSupplier;
  List<PurchaserequestReferenceModel>? referencePR;
  List<HeaderNetValPopup>? headerNetValPopup;
  List<ItemDetailsTab>? itemDetailsTab;
  List<ApprvlLvlStatus>? apprvlLvlStatus;
  String? workFlowPendingUser;
  String? wfSubject;
  int? parentNotificationType;
  int? childNotificationType;
  String? rfiRemarks;
  bool? isInitiated;
  List<WorkFlowIcons>? workFlowIcons;

  PurchaseOrderModel(
      {this.error,
      this.errorCode,
      this.errorDescription,
      this.menuId,
      this.uniqueVal,
      this.headerId,
      this.headerTab,
      this.headerAttachmentLst,
      this.createSupplier,
      this.referencePR,
      this.headerNetValPopup,
      this.itemDetailsTab,
      this.apprvlLvlStatus,
      this.workFlowPendingUser,
      this.wfSubject,
      this.parentNotificationType,
      this.childNotificationType,
      this.rfiRemarks,
      this.isInitiated,
      this.workFlowIcons});

  PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    menuId = json['menu_id'];
    uniqueVal = json['unique_val'];
    headerId = json['header_id'];
    headerTab = json['header_tab'] != null
        ? new HeaderTab.fromJson(json['header_tab'])
        : null;
    if (json['header_attachment_lst'] != null) {
      headerAttachmentLst = <HeaderAttchLst>[];
      json['header_attachment_lst'].forEach((v) {
        headerAttachmentLst!.add(new HeaderAttchLst.fromJson(v));
      });
    }
    if (json['create_supplier'] != null) {
      createSupplier = <CreateSupplier>[];
      json['create_supplier'].forEach((v) {
        createSupplier!.add(new CreateSupplier.fromJson(v));
      });
    }
    if (json['Reference_PR'] != null) {
      referencePR = <PurchaserequestReferenceModel>[];
      json['Reference_PR'].forEach((v) {
        referencePR!.add(new PurchaserequestReferenceModel.fromJson(v));
      });
    }
    if (json['header_net_val_popup'] != null) {
      headerNetValPopup = <HeaderNetValPopup>[];
      json['header_net_val_popup'].forEach((v) {
        headerNetValPopup!.add(new HeaderNetValPopup.fromJson(v));
      });
    }
    if (json['item_details_tab'] != null) {
      itemDetailsTab = <ItemDetailsTab>[];
      json['item_details_tab'].forEach((v) {
        itemDetailsTab!.add(new ItemDetailsTab.fromJson(v));
      });
    }
    if (json['apprvl_lvl_status'] != null) {
      apprvlLvlStatus = <ApprvlLvlStatus>[];
      json['apprvl_lvl_status'].forEach((v) {
        apprvlLvlStatus!.add(new ApprvlLvlStatus.fromJson(v));
      });
    }
    workFlowPendingUser = json['work_flow_pending_user'];
    wfSubject = json['wf_subject'];
    parentNotificationType = json['parent_notification_type'];
    childNotificationType = json['child_notification_type'];
    rfiRemarks = json['rfi_remarks'];
    isInitiated = json['is_initiated'];
    if (json['work_flow_icons'] != null) {
      workFlowIcons = <WorkFlowIcons>[];
      json['work_flow_icons'].forEach((v) {
        workFlowIcons!.add(new WorkFlowIcons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['error_description'] = this.errorDescription;
    data['menu_id'] = this.menuId;
    data['unique_val'] = this.uniqueVal;
    data['header_id'] = this.headerId;
    if (this.headerTab != null) {
      data['header_tab'] = this.headerTab!.toJson();
    }
    if (this.headerAttachmentLst != null) {
      data['header_attachment_lst'] =
          this.headerAttachmentLst!.map((v) => v.toJson()).toList();
    }
    if (this.createSupplier != null) {
      data['create_supplier'] =
          this.createSupplier!.map((v) => v.toJson()).toList();
    }
    if (this.referencePR != null) {
      data['Reference_PR'] = this.referencePR!.map((v) => v.toJson()).toList();
    }
    if (this.headerNetValPopup != null) {
      data['header_net_val_popup'] =
          this.headerNetValPopup!.map((v) => v.toJson()).toList();
    }
    if (this.itemDetailsTab != null) {
      data['item_details_tab'] =
          this.itemDetailsTab!.map((v) => v.toJson()).toList();
    }
    if (this.apprvlLvlStatus != null) {
      data['apprvl_lvl_status'] =
          this.apprvlLvlStatus!.map((v) => v.toJson()).toList();
    }
    data['work_flow_pending_user'] = this.workFlowPendingUser;
    data['wf_subject'] = this.wfSubject;
    data['parent_notification_type'] = this.parentNotificationType;
    data['child_notification_type'] = this.childNotificationType;
    data['rfi_remarks'] = this.rfiRemarks;
    data['is_initiated'] = this.isInitiated;
    if (this.workFlowIcons != null) {
      data['work_flow_icons'] =
          this.workFlowIcons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HeaderTab {
  String? docDate;
  int? docLocId;
  String? docLocCode;
  String? docLocDesc;
  String? txnType;
  String? txnNo;
  String? reference;
  String? referenceDesc;
  String? refDocCode;
  String? refDocNo;
  int? refDocId;
  int? statusId;
  String? statusCode;
  String? statusDescription;
  int? supplierId;
  String? supplierCode;
  String? supplierName;
  String? supplierOfferNo;
  String? supplierOfferDate;
  int? currencyId;
  String? currencyCode;
  String? currencyDescription;
  String? exchangeRate;
  String? discount;
  String? value;
  String? grossValue;
  String? discountValue;
  String? netValue;
  int? paymentTermId;
  String? paymentTermCode;
  String? paymentTermDesc;
  int? modeOfShipmentId;
  String? modeOfShipmentCode;
  String? modeOfShipmentDesc;
  int? modeOfPaymentId;
  String? modeOfPaymentCode;
  String? modeOfPaymentDesc;
  int? chargeTypeId;
  String? chargeTypeCode;
  String? chargeTypeDescription;
  int? chargeToId;
  String? chargeToCode;
  String? chargeToDescription;
  int? shipToStoreLocId;
  String? shipToStoreLocCode;
  String? shipToStoreLocDescription;
  int? purchaseTypeId;
  String? purchaseTypeCode;
  String? purchaseTypeDesc;
  int? pettyCashId;
  String? pettyCashCode;
  String? pettyCashDesc;
  int? buyerId;
  String? buyerCode;
  String? buyerDesc;
  String? headerEta;
  int? deliveryTermId;
  String? deliveryTermCode;
  String? deliveryTermDesc;
  String? needByDate;
  String? remark;
  String? headerTermPopup;

  // Terms data
  String? terms;

  // Supplier Creation data
  String? supplierDesc;
  String? supplierType;
  String? supplierTypeDesc;
  String? supplierAddress;
  String? supplierAddressDesc;
  String? supplierAddress2;

  // Validation data
  bool? crNoSelected;
  String? crNoNumber;
  String? crNoExpiry;
  bool? zakatSelected;
  String? zakatNumber;
  String? zakatExpiry;
  bool? vatSelected;
  String? vatNumber;
  String? vatExpiry;

  // Dynamic Validation data
  Map<String, bool>? dynamicValidationSelected;
  Map<String, String>? dynamicValidationNumbers;
  Map<String, String>? dynamicValidationExpiry;

  // Fallback Validation data
  bool? fallbackValidationSelected;
  String? fallbackValidationType;
  String? fallbackValidationNumber;
  String? fallbackValidationExpiry;

  HeaderTab(
      {this.docDate,
      this.docLocId,
      this.docLocCode,
      this.docLocDesc,
      this.txnType,
      this.txnNo,
      this.reference,
      this.referenceDesc,
      this.refDocCode,
      this.refDocNo,
      this.refDocId,
      this.statusId,
      this.statusCode,
      this.statusDescription,
      this.supplierId,
      this.supplierCode,
      this.supplierName,
      this.supplierOfferNo,
      this.supplierOfferDate,
      this.currencyId,
      this.currencyCode,
      this.currencyDescription,
      this.exchangeRate,
      this.discount,
      this.value,
      this.paymentTermId,
      this.paymentTermCode,
      this.paymentTermDesc,
      this.modeOfShipmentId,
      this.modeOfShipmentCode,
      this.modeOfShipmentDesc,
      this.modeOfPaymentId,
      this.modeOfPaymentCode,
      this.modeOfPaymentDesc,
      this.chargeTypeId,
      this.chargeTypeCode,
      this.chargeTypeDescription,
      this.chargeToId,
      this.chargeToCode,
      this.chargeToDescription,
      this.shipToStoreLocId,
      this.shipToStoreLocCode,
      this.shipToStoreLocDescription,
      this.purchaseTypeId,
      this.purchaseTypeCode,
      this.purchaseTypeDesc,
      this.pettyCashId,
      this.pettyCashCode,
      this.pettyCashDesc,
      this.buyerId,
      this.buyerCode,
      this.buyerDesc,
      this.headerEta,
      this.deliveryTermId,
      this.deliveryTermCode,
      this.deliveryTermDesc,
      this.needByDate,
      this.remark,
      this.headerTermPopup,
      this.terms,
      this.supplierDesc,
      this.supplierType,
      this.supplierTypeDesc,
      this.supplierAddress,
      this.supplierAddressDesc,
      this.supplierAddress2,
      this.crNoSelected,
      this.crNoNumber,
      this.crNoExpiry,
      this.zakatSelected,
      this.zakatNumber,
      this.zakatExpiry,
      this.vatSelected,
      this.vatNumber,
      this.vatExpiry,
      this.dynamicValidationSelected,
      this.dynamicValidationNumbers,
      this.dynamicValidationExpiry,
      this.fallbackValidationSelected,
      this.fallbackValidationType,
      this.fallbackValidationNumber,
      this.fallbackValidationExpiry});

  HeaderTab.fromJson(Map<String, dynamic> json) {
    docDate = json['doc_date'];
    docLocId = json['doc_loc_id'];
    docLocCode = json['doc_loc_code'];
    docLocDesc = json['doc_loc_desc'];
    txnType = json['txn_type'];
    txnNo = json['txn_no'];
    reference = json['reference'];
    referenceDesc = json['reference_desc'];
    refDocCode = json['ref_doc_code'];
    refDocNo = json['ref_doc_no'];
    refDocId = json['ref_doc_id'];
    statusId = json['status_id'];
    statusCode = json['status_code'];
    statusDescription = json['status_description'];
    supplierId = json['supplier_id'];
    supplierCode = json['supplier_code'];
    supplierName = json['supplier_name'];
    supplierOfferNo = json['supplier_offer_no'];
    supplierOfferDate = json['supplier_offer_date'];
    currencyId = json['currency_id'];
    currencyCode = json['currency_code'];
    currencyDescription = json['currency_description'];
    exchangeRate = json['exchange_rate'];
    discount = json['discount'];
    value = json['value'];
    paymentTermId = json['payment_term_id'];
    paymentTermCode = json['payment_term_code'];
    paymentTermDesc = json['payment_term_desc'];
    modeOfShipmentId = json['mode_of_shipment_id'];
    modeOfShipmentCode = json['mode_of_shipment_code'];
    modeOfShipmentDesc = json['mode_of_shipment_desc'];
    modeOfPaymentId = json['mode_of_payment_id'];
    modeOfPaymentCode = json['mode_of_payment_code'];
    modeOfPaymentDesc = json['mode_of_payment_desc'];
    chargeTypeId = json['charge_type_id'];
    chargeTypeCode = json['charge_type_code'];
    chargeTypeDescription = json['charge_type_description'];
    chargeToId = json['charge_to_id'];
    chargeToCode = json['charge_to_code'];
    chargeToDescription = json['charge_to_description'];
    shipToStoreLocId = json['ship_to_store_loc_id'];
    shipToStoreLocCode = json['ship_to_store_loc_code'];
    shipToStoreLocDescription = json['ship_to_store_loc_description'];
    purchaseTypeId = json['purchase_type_id'];
    purchaseTypeCode = json['purchase_type_code'];
    purchaseTypeDesc = json['purchase_type_desc'];
    pettyCashId = json['petty_cash_id'];
    pettyCashCode = json['petty_cash_code'];
    pettyCashDesc = json['petty_cash_desc'];
    buyerId = json['buyer_id'];
    buyerCode = json['buyer_code'];
    buyerDesc = json['buyer_desc'];
    headerEta = json['header_eta'];
    deliveryTermId = json['delivery_term_id'];
    deliveryTermCode = json['delivery_term_code'];
    deliveryTermDesc = json['delivery_term_desc'];
    needByDate = json['need_by_date'];
    remark = json['remark'];
    headerTermPopup = json['header_term_popup'];

    // Terms data
    terms = json['terms'];

    // Supplier Creation data
    supplierDesc = json['supplier_desc'];
    supplierType = json['supplier_type'];
    supplierTypeDesc = json['supplier_type_desc'];
    supplierAddress = json['supplier_address'];
    supplierAddressDesc = json['supplier_address_desc'];
    supplierAddress2 = json['supplier_address2'];

    // Validation data
    crNoSelected = json['cr_no_selected'];
    crNoNumber = json['cr_no_number'];
    crNoExpiry = json['cr_no_expiry'];
    zakatSelected = json['zakat_selected'];
    zakatNumber = json['zakat_number'];
    zakatExpiry = json['zakat_expiry'];
    vatSelected = json['vat_selected'];
    vatNumber = json['vat_number'];
    vatExpiry = json['vat_expiry'];

    // Dynamic Validation data
    dynamicValidationSelected = json['dynamic_validation_selected'] != null
        ? Map<String, bool>.from(json['dynamic_validation_selected'])
        : null;
    dynamicValidationNumbers = json['dynamic_validation_numbers'] != null
        ? Map<String, String>.from(json['dynamic_validation_numbers'])
        : null;
    dynamicValidationExpiry = json['dynamic_validation_expiry'] != null
        ? Map<String, String>.from(json['dynamic_validation_expiry'])
        : null;

    // Fallback Validation data
    fallbackValidationSelected = json['fallback_validation_selected'];
    fallbackValidationType = json['fallback_validation_type'];
    fallbackValidationNumber = json['fallback_validation_number'];
    fallbackValidationExpiry = json['fallback_validation_expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_date'] = this.docDate;
    data['doc_loc_id'] = this.docLocId;
    data['doc_loc_code'] = this.docLocCode;
    data['doc_loc_desc'] = this.docLocDesc;
    data['txn_type'] = this.txnType;
    data['txn_no'] = this.txnNo;
    data['reference'] = this.reference;
    data['reference_desc'] = this.referenceDesc;
    data['ref_doc_code'] = this.refDocCode;
    data['ref_doc_no'] = this.refDocNo;
    data['ref_doc_id'] = this.refDocId;
    data['status_id'] = this.statusId;
    data['status_code'] = this.statusCode;
    data['status_description'] = this.statusDescription;
    data['supplier_id'] = this.supplierId;
    data['supplier_code'] = this.supplierCode;
    data['supplier_name'] = this.supplierName;
    data['supplier_offer_no'] = this.supplierOfferNo;
    data['supplier_offer_date'] = this.supplierOfferDate;
    data['currency_id'] = this.currencyId;
    data['currency_code'] = this.currencyCode;
    data['currency_description'] = this.currencyDescription;
    data['exchange_rate'] = this.exchangeRate;
    data['discount'] = this.discount;
    data['value'] = this.value;
    data['gross_value'] = this.grossValue;
    data['discount_value'] = this.discountValue;
    data['net_value'] = this.netValue;
    data['payment_term_id'] = this.paymentTermId;
    data['payment_term_code'] = this.paymentTermCode;
    data['payment_term_desc'] = this.paymentTermDesc;
    data['mode_of_shipment_id'] = this.modeOfShipmentId;
    data['mode_of_shipment_code'] = this.modeOfShipmentCode;
    data['mode_of_shipment_desc'] = this.modeOfShipmentDesc;
    data['mode_of_payment_id'] = this.modeOfPaymentId;
    data['mode_of_payment_code'] = this.modeOfPaymentCode;
    data['mode_of_payment_desc'] = this.modeOfPaymentDesc;
    data['charge_type_id'] = this.chargeTypeId;
    data['charge_type_code'] = this.chargeTypeCode;
    data['charge_type_description'] = this.chargeTypeDescription;
    data['charge_to_id'] = this.chargeToId;
    data['charge_to_code'] = this.chargeToCode;
    data['charge_to_description'] = this.chargeToDescription;
    data['ship_to_store_loc_id'] = this.shipToStoreLocId;
    data['ship_to_store_loc_code'] = this.shipToStoreLocCode;
    data['ship_to_store_loc_description'] = this.shipToStoreLocDescription;
    data['purchase_type_id'] = this.purchaseTypeId;
    data['purchase_type_code'] = this.purchaseTypeCode;
    data['purchase_type_desc'] = this.purchaseTypeDesc;
    data['petty_cash_id'] = this.pettyCashId;
    data['petty_cash_code'] = this.pettyCashCode;
    data['petty_cash_desc'] = this.pettyCashDesc;
    data['buyer_id'] = this.buyerId;
    data['buyer_code'] = this.buyerCode;
    data['buyer_desc'] = this.buyerDesc;
    data['header_eta'] = this.headerEta;
    data['delivery_term_id'] = this.deliveryTermId;
    data['delivery_term_code'] = this.deliveryTermCode;
    data['delivery_term_desc'] = this.deliveryTermDesc;
    data['need_by_date'] = this.needByDate;
    data['remark'] = this.remark;
    data['header_term_popup'] = this.headerTermPopup;

    // Terms data
    data['terms'] = this.terms;

    // Supplier Creation data
    data['supplier_desc'] = this.supplierDesc;
    data['supplier_type'] = this.supplierType;
    data['supplier_type_desc'] = this.supplierTypeDesc;
    data['supplier_address'] = this.supplierAddress;
    data['supplier_address_desc'] = this.supplierAddressDesc;
    data['supplier_address2'] = this.supplierAddress2;

    // Validation data
    data['cr_no_selected'] = this.crNoSelected;
    data['cr_no_number'] = this.crNoNumber;
    data['cr_no_expiry'] = this.crNoExpiry;
    data['zakat_selected'] = this.zakatSelected;
    data['zakat_number'] = this.zakatNumber;
    data['zakat_expiry'] = this.zakatExpiry;
    data['vat_selected'] = this.vatSelected;
    data['vat_number'] = this.vatNumber;
    data['vat_expiry'] = this.vatExpiry;

    // Dynamic Validation data
    data['dynamic_validation_selected'] = this.dynamicValidationSelected;
    data['dynamic_validation_numbers'] = this.dynamicValidationNumbers;
    data['dynamic_validation_expiry'] = this.dynamicValidationExpiry;

    // Fallback Validation data
    data['fallback_validation_selected'] = this.fallbackValidationSelected;
    data['fallback_validation_type'] = this.fallbackValidationType;
    data['fallback_validation_number'] = this.fallbackValidationNumber;
    data['fallback_validation_expiry'] = this.fallbackValidationExpiry;

    return data;
  }
}

class CreateSupplier {
  String? crSuppCode;
  String? crSuppDesc;
  int? crSuppTypeId;
  String? crSuppTypeCode;
  String? crSuppTypeDesc;
  int? crSuppAddressId;
  String? crSuppAddressCode;
  String? crSuppAddressDesc;
  List<SuppValidation>? suppValidation;

  CreateSupplier(
      {this.crSuppCode,
      this.crSuppDesc,
      this.crSuppTypeId,
      this.crSuppTypeCode,
      this.crSuppTypeDesc,
      this.crSuppAddressId,
      this.crSuppAddressCode,
      this.crSuppAddressDesc,
      this.suppValidation});

  CreateSupplier.fromJson(Map<String, dynamic> json) {
    crSuppCode = json['cr_supp_code'];
    crSuppDesc = json['cr_supp_desc'];
    crSuppTypeId = json['cr_supp_type_id'];
    crSuppTypeCode = json['cr_supp_type_code'];
    crSuppTypeDesc = json['cr_supp_type_desc'];
    crSuppAddressId = json['cr_supp_address_id'];
    crSuppAddressCode = json['cr_supp_address_code'];
    crSuppAddressDesc = json['cr_supp_address_desc'];
    if (json['supp_validation'] != null) {
      suppValidation = <SuppValidation>[];
      json['supp_validation'].forEach((v) {
        suppValidation!.add(new SuppValidation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cr_supp_code'] = this.crSuppCode;
    data['cr_supp_desc'] = this.crSuppDesc;
    data['cr_supp_type_id'] = this.crSuppTypeId;
    data['cr_supp_type_code'] = this.crSuppTypeCode;
    data['cr_supp_type_desc'] = this.crSuppTypeDesc;
    data['cr_supp_address_id'] = this.crSuppAddressId;
    data['cr_supp_address_code'] = this.crSuppAddressCode;
    data['cr_supp_address_desc'] = this.crSuppAddressDesc;
    if (this.suppValidation != null) {
      data['supp_validation'] =
          this.suppValidation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuppValidation {
  int? validationTypeId;
  String? validationTypeName;
  String? validationNumber;
  String? validationExpyDate;

  SuppValidation(
      {this.validationTypeId,
      this.validationTypeName,
      this.validationNumber,
      this.validationExpyDate});

  SuppValidation.fromJson(Map<String, dynamic> json) {
    validationTypeId = json['validation_type_id'];
    validationTypeName = json['validation_type_name'];
    validationNumber = json['validation_number'];
    validationExpyDate = json['validation_expy_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['validation_type_id'] = this.validationTypeId;
    data['validation_type_name'] = this.validationTypeName;
    data['validation_number'] = this.validationNumber;
    data['validation_expy_date'] = this.validationExpyDate;
    return data;
  }
}

class HeaderNetValPopup {
  String? itemGrossValue;
  String? itemDiscount;
  String? itemGrossValAfterDis;
  String? itemTaxAddToCost;
  String? itemTaxRecovrable;
  String? itemExpense;
  String? itemNetValue;
  String? headerTaxAddToCost;
  String? headerTaxRecovrable;
  String? headerDiscount;
  String? headerExpense;
  String? headerNetValue;

  HeaderNetValPopup(
      {this.itemGrossValue,
      this.itemDiscount,
      this.itemGrossValAfterDis,
      this.itemTaxAddToCost,
      this.itemTaxRecovrable,
      this.itemExpense,
      this.itemNetValue,
      this.headerTaxAddToCost,
      this.headerTaxRecovrable,
      this.headerDiscount,
      this.headerExpense,
      this.headerNetValue});

  HeaderNetValPopup.fromJson(Map<String, dynamic> json) {
    itemGrossValue = json['item_gross_value'];
    itemDiscount = json['item_discount'];
    itemGrossValAfterDis = json['item_gross_val_after_dis'];
    itemTaxAddToCost = json['item_tax_add_to_cost'];
    itemTaxRecovrable = json['item_tax_recovrable'];
    itemExpense = json['item_expense'];
    itemNetValue = json['item_net_value'];
    headerTaxAddToCost = json['header_tax_add_to_cost'];
    headerTaxRecovrable = json['header_tax_recovrable'];
    headerDiscount = json['header_discount'];
    headerExpense = json['header_expense'];
    headerNetValue = json['header_net_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_gross_value'] = this.itemGrossValue;
    data['item_discount'] = this.itemDiscount;
    data['item_gross_val_after_dis'] = this.itemGrossValAfterDis;
    data['item_tax_add_to_cost'] = this.itemTaxAddToCost;
    data['item_tax_recovrable'] = this.itemTaxRecovrable;
    data['item_expense'] = this.itemExpense;
    data['item_net_value'] = this.itemNetValue;
    data['header_tax_add_to_cost'] = this.headerTaxAddToCost;
    data['header_tax_recovrable'] = this.headerTaxRecovrable;
    data['header_discount'] = this.headerDiscount;
    data['header_expense'] = this.headerExpense;
    data['header_net_value'] = this.headerNetValue;
    return data;
  }
}

class ItemDetailsTab {
  int? srNo;
  int? itemLineId;
  String? txnNo;
  int? refDocId;
  String? refDocNo;
  int? refItemMappId;
  int? itemId;
  String? itemCode;
  String? itemDesc;
  String? infoIcon;
  int? uomId;
  String? uom;
  String? uomDesc;
  String? quantity;
  String? looseQty;
  String? baseQty;
  String? unitPrice;
  String? grossValue;
  String? discountPer;
  String? discountVal;
  String? netValue;
  int? mnfId;
  String? mnfDesc;
  int? chargeTypeId;
  String? chargeTypeCode;
  String? chargeTypeName;
  int? chargeToId;
  String? chargeToCode;
  String? chargeToName;
  String? needByDt;
  String? etaDate;
  int? glId;
  String? glCode;
  String? glDesc;
  String? noteToReceiver;
  String? taxAmount;
  String? taxLcAmount;
  String? taxCodes;
  String? taxRemarks;
  List<TaxPopup>? taxPopup;
  List<LineItemAttachment>? itemLineAttachment;
  bool? isOpen;
  bool? isSelected;
  TextEditingController? quantityController;
  TextEditingController? unitPriceController;
  TextEditingController? grossValueController;
  TextEditingController? discountController;
  TextEditingController? discountValueController;
  TextEditingController? noteToReceiverController;

  ItemDetailsTab({
    this.srNo,
    this.itemLineId,
    this.txnNo,
    this.refDocId,
    this.refDocNo,
    this.refItemMappId,
    this.itemId,
    this.itemCode,
    this.itemDesc,
    this.infoIcon,
    this.uomId,
    this.uom,
    this.uomDesc,
    this.quantity,
    this.looseQty,
    this.baseQty,
    this.unitPrice,
    this.grossValue,
    this.discountPer,
    this.discountVal,
    this.netValue,
    this.mnfId,
    this.mnfDesc,
    this.chargeTypeId,
    this.chargeTypeCode,
    this.chargeTypeName,
    this.chargeToId,
    this.chargeToCode,
    this.chargeToName,
    this.needByDt,
    this.etaDate,
    this.glId,
    this.glCode,
    this.glDesc,
    this.noteToReceiver,
    this.taxAmount,
    this.taxLcAmount,
    this.taxCodes,
    this.taxRemarks,
    this.taxPopup,
    this.itemLineAttachment,
    this.isOpen,
    this.isSelected,
    TextEditingController? quantityController,
    TextEditingController? unitPriceController,
    TextEditingController? grossValueController,
    TextEditingController? discountController,
    TextEditingController? discountValueController,
    TextEditingController? noteToReceiverController,
  })  : quantityController = quantityController ?? TextEditingController(),
        unitPriceController = unitPriceController ?? TextEditingController(),
        grossValueController = grossValueController ?? TextEditingController(),
        discountController = discountController ?? TextEditingController(),
        discountValueController =
            discountValueController ?? TextEditingController(),
        noteToReceiverController =
            noteToReceiverController ?? TextEditingController();

  ItemDetailsTab.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    itemLineId = json['item_line_id'];
    txnNo = json['txn_no'];
    refDocId = json['ref_doc_id'];
    refDocNo = json['ref_doc_no'];
    refItemMappId = json['ref_item_mapp_id'];
    itemId = json['item_id'];
    itemCode = json['item_code'];
    itemDesc = json['item_desc'];
    infoIcon = json['info_icon'];
    uomId = json['uom_id'];
    uom = json['uom'];
    uomDesc = json['uom_desc'];
    quantity = json['quantity'];
    looseQty = json['loose_qty'];
    baseQty = json['base_qty'];
    unitPrice = json['unit_price'];
    grossValue = json['gross_value'];
    discountPer = json['discount_per'];
    discountVal = json['discount_val'];
    netValue = json['net_value'];
    mnfId = json['mnf_id'];
    mnfDesc = json['mnf_desc'];
    chargeTypeId = json['charge_type_id'];
    chargeTypeCode = json['charge_type_code'];
    chargeTypeName = json['charge_type_name'];
    chargeToId = json['charge_to_id'];
    chargeToCode = json['charge_to_code'];
    chargeToName = json['charge_to_name'];
    needByDt = json['need_by_dt'];
    etaDate = json['eta_date'];
    glId = json['gl_id'];
    glCode = json['gl_code'];
    glDesc = json['gl_desc'];
    noteToReceiver = json['note_to_receiver'];
    taxAmount = json['tax_amount'];
    taxLcAmount = json['tax_lc_amount'];
    taxCodes = json['tax_codes'];
    taxRemarks = json['tax_remarks'];
    // Always initialize taxPopup as empty list, even if API doesn't return it
    taxPopup = <TaxPopup>[];
    if (json['tax_popup'] != null) {
      json['tax_popup'].forEach((v) {
        taxPopup!.add(new TaxPopup.fromJson(v));
      });
    }
    if (json['item_line_attachment'] != null) {
      itemLineAttachment = <LineItemAttachment>[];
      json['item_line_attachment'].forEach((v) {
        itemLineAttachment!.add(new LineItemAttachment.fromJson(v));
      });
    }
    isOpen = false;
    //  Controllers initialized with existing values
    quantityController = TextEditingController(text: quantity ?? '');
    unitPriceController = TextEditingController(text: unitPrice ?? '');
    grossValueController = TextEditingController(text: grossValue ?? '');
    discountController = TextEditingController(text: discountPer ?? '');
    discountValueController = TextEditingController(text: discountVal ?? '');
    noteToReceiverController =
        TextEditingController(text: noteToReceiver ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['item_line_id'] = this.itemLineId;
    data['txn_no'] = this.txnNo;
    data['ref_doc_id'] = this.refDocId;
    data['ref_doc_no'] = this.refDocNo;
    data['ref_item_mapp_id'] = this.refItemMappId;
    data['item_id'] = this.itemId;
    data['item_code'] = this.itemCode;
    data['item_desc'] = this.itemDesc;
    data['info_icon'] = this.infoIcon;
    data['uom_id'] = this.uomId;
    data['uom'] = this.uom;
    data['uom_desc'] = this.uomDesc;
    data['quantity'] = this.quantity;
    data['loose_qty'] = this.looseQty;
    data['base_qty'] = this.baseQty;
    data['unit_price'] = this.unitPrice;
    data['gross_value'] = this.grossValue;
    data['discount_per'] = this.discountPer;
    data['discount_val'] = this.discountVal;
    data['net_value'] = this.netValue;
    data['mnf_id'] = this.mnfId;
    data['mnf_desc'] = this.mnfDesc;
    data['charge_type_id'] = this.chargeTypeId;
    data['charge_type_code'] = this.chargeTypeCode;
    data['charge_type_name'] = this.chargeTypeName;
    data['charge_to_id'] = this.chargeToId;
    data['charge_to_code'] = this.chargeToCode;
    data['charge_to_name'] = this.chargeToName;
    data['need_by_dt'] = this.needByDt;
    data['eta_date'] = this.etaDate;
    data['gl_id'] = this.glId;
    data['gl_code'] = this.glCode;
    data['gl_desc'] = this.glDesc;
    data['note_to_receiver'] = this.noteToReceiver;
    data['note_to_receiver'] = noteToReceiverController?.text ?? noteToReceiver;
    data['tax_amount'] = this.taxAmount;
    data['tax_lc_amount'] = this.taxLcAmount;
    data['tax_codes'] = this.taxCodes;
    data['tax_remarks'] = this.taxRemarks;
    if (this.taxPopup != null) {
      data['tax_popup'] = this.taxPopup!.map((v) => v.toJson()).toList();
    }
    if (this.itemLineAttachment != null) {
      data['item_line_attachment'] =
          this.itemLineAttachment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxPopup {
  int? srNo;
  int? taxLineId;
  int? taxId;
  String? taxCode;
  int? currencyId;
  String? currencyCode;
  String? discountPercent;
  String? discountValue;
  String? discountLcvalue;
  String? taxRemark;
  String? taxBasis;
  bool isOpen = true;
  bool isSelected = false;

  // TextEditingController fields for UI
  TextEditingController? taxPopUpPercentController;
  TextEditingController? taxPopUpRemarksController;

  TaxPopup(
      {this.srNo,
      this.taxLineId,
      this.taxId,
      this.taxCode,
      this.currencyId,
      this.currencyCode,
      this.discountPercent,
      this.discountValue,
      this.discountLcvalue,
      this.taxRemark,
      this.taxBasis,
      isOpen,
      isSelected}) {
    // Initialize controllers
    taxPopUpPercentController =
        TextEditingController(text: discountPercent ?? '');
    taxPopUpRemarksController = TextEditingController(text: taxRemark ?? '');
  }

  // Default constructor that always initializes controllers
  TaxPopup.empty() {
    taxPopUpPercentController = TextEditingController();
    taxPopUpRemarksController = TextEditingController();
  }

  TaxPopup.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    taxLineId = json['tax_line_id'];
    taxId = json['tax_id'];
    taxCode = json['tax_code'];
    currencyId = json['currency_id'] is String
        ? int.tryParse(json['currency_id'])
        : json['currency_id'];
    currencyCode = json['currency_code'];
    discountPercent = json['discount_percent'];
    discountValue = json['discount_value'];
    discountLcvalue = json['discount_lcvalue'];
    taxRemark = json['tax_remark'];
    taxBasis = json['tax_basis'];

    // Initialize controllers
    taxPopUpPercentController =
        TextEditingController(text: discountPercent ?? '');
    taxPopUpRemarksController = TextEditingController(text: taxRemark ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['tax_line_id'] = this.taxLineId;
    data['tax_id'] = this.taxId;
    data['tax_code'] = this.taxCode;
    data['currency_id'] = this.currencyId;
    data['currency_code'] = this.currencyCode;
    data['discount_percent'] = this.discountPercent;
    data['discount_value'] = this.discountValue;
    data['discount_lcvalue'] = this.discountLcvalue;
    data['tax_remark'] = this.taxRemark;
    data['tax_basis'] = this.taxBasis;
    return data;
  }
}

class HeaderAttchLst {
  String? docAttachCode;
  int? docAttachId;
  String? docAttachName;
  String? docAttachUrl;
  String? docType;
  int? docTypeId;
  String? docTitle;
  int type = 0;
  String url = '';
  String? lineId;

  HeaderAttchLst(
      {this.docAttachCode,
      this.docAttachId,
      this.docAttachName,
      this.docAttachUrl,
      this.docType,
      this.docTypeId,
      this.docTitle,
      type,
      url,
      this.lineId});

  HeaderAttchLst.fromJson(Map<String, dynamic> json) {
    docAttachCode = json['doc_attach_code'];
    docAttachId = json['doc_attach_id'];
    docAttachName = json['doc_attach_name'];
    docAttachUrl = json['doc_attach_url'];
    docType = json['doc_type'];
    docTypeId = json['doc_type_id'];
    docTitle = json['doc_title'];
    lineId = json['line_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doc_attach_code'] = docAttachCode;
    data['doc_attach_id'] = docAttachId;
    data['doc_attach_name'] = docAttachName;
    data['doc_attach_url'] = docAttachUrl;
    data['doc_type'] = docType;
    data['doc_type_id'] = docTypeId;
    data['doc_title'] = docTitle;
    data['line_id'] = lineId;
    return data;
  }
}

class LineItemAttachment {
  String? docAttachCode;
  int? docAttachId;
  String? docAttachName;
  String? docAttachUrl;
  String? lineId;
  String? docType;
  int? docTypeId;
  String? docTitle;

  LineItemAttachment({
    this.docAttachCode,
    this.docAttachId,
    this.docAttachName,
    this.docAttachUrl,
    this.lineId,
    this.docType,
    this.docTypeId,
    this.docTitle,
  });

  // From JSON constructor
  LineItemAttachment.fromJson(Map<String, dynamic> json)
      : docAttachCode = json['doc_attach_code'],
        docAttachId = json['doc_attach_id'],
        docAttachName = json['doc_attach_name'],
        docAttachUrl = json['doc_attach_url'],
        lineId = json['line_id'],
        docType = json['doc_type'],
        docTypeId = json['doc_type_id'],
        docTitle = json['doc_title'];

  // To JSON method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doc_attach_code'] = this.docAttachCode;
    data['doc_attach_id'] = this.docAttachId;
    data['doc_attach_name'] = this.docAttachName;
    data['doc_attach_url'] = this.docAttachUrl;
    data['line_id'] = this.lineId;
    data['doc_type'] = this.docType;
    data['doc_type_id'] = this.docTypeId;
    data['doc_title'] = this.docTitle;
    return data;
  }
}
