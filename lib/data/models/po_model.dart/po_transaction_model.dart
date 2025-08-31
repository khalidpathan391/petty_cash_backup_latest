// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PurchaseOrderModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  int? menuId;
  String? uniqueVal;
  int? headerId;
  HeaderTab? headerTab;
  List<Null>? headerAttachmentLst;
  List<Null>? createSupplier;
  List<Null>? referencePR;
  List<HeaderNetValPopup>? headerNetValPopup;
  List<ItemDetailsTab>? itemDetailsTab;
  List<Null>? apprvlLvlStatus;
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
    // if (json['header_attachment_lst'] != null) {
    //   headerAttachmentLst = <Null>[];
    //   json['header_attachment_lst'].forEach((v) {
    //     headerAttachmentLst!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['create_supplier'] != null) {
    //   createSupplier = <Null>[];
    //   json['create_supplier'].forEach((v) {
    //     createSupplier!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['Reference_PR'] != null) {
    //   referencePR = <Null>[];
    //   json['Reference_PR'].forEach((v) {
    //     referencePR!.add(new Null.fromJson(v));
    //   });
    // }
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
    // if (json['apprvl_lvl_status'] != null) {
    //   apprvlLvlStatus = <Null>[];
    //   json['apprvl_lvl_status'].forEach((v) {
    //     apprvlLvlStatus!.add(new Null.fromJson(v));
    //   });
    // }
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
    // if (this.headerAttachmentLst != null) {
    //   data['header_attachment_lst'] =
    //       this.headerAttachmentLst!.map((v) => v.toJson()).toList();
    // }
    // if (this.createSupplier != null) {
    //   data['create_supplier'] =
    //       this.createSupplier!.map((v) => v.toJson()).toList();
    // }
    // if (this.referencePR != null) {
    //   data['Reference_PR'] = this.referencePR!.map((v) => v.toJson()).toList();
    // }
    if (this.headerNetValPopup != null) {
      data['header_net_val_popup'] =
          this.headerNetValPopup!.map((v) => v.toJson()).toList();
    }
    if (this.itemDetailsTab != null) {
      data['item_details_tab'] =
          this.itemDetailsTab!.map((v) => v.toJson()).toList();
    }
    // if (this.apprvlLvlStatus != null) {
    //   data['apprvl_lvl_status'] =
    //       this.apprvlLvlStatus!.map((v) => v.toJson()).toList();
    // }
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
      this.headerTermPopup});

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
  List<TaxPopup>? taxPopup;
  List<Null>? itemLineAttachment;

  ItemDetailsTab(
      {this.srNo,
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
      this.taxPopup,
      this.itemLineAttachment});

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
    if (json['tax_popup'] != null) {
      taxPopup = <TaxPopup>[];
      json['tax_popup'].forEach((v) {
        taxPopup!.add(new TaxPopup.fromJson(v));
      });
    }
    // if (json['item_line_attachment'] != null) {
    //   itemLineAttachment = <Null>[];
    //   json['item_line_attachment'].forEach((v) {
    //     itemLineAttachment!.add(new Null.fromJson(v));
    //   });
    // }
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
    if (this.taxPopup != null) {
      data['tax_popup'] = this.taxPopup!.map((v) => v.toJson()).toList();
    }
    // if (this.itemLineAttachment != null) {
    //   data['item_line_attachment'] =
    //       this.itemLineAttachment!.map((v) => v.toJson()).toList();
    // }
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
      this.taxBasis});

  TaxPopup.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    taxLineId = json['tax_line_id'];
    taxId = json['tax_id'];
    taxCode = json['tax_code'];
    currencyId = json['currency_id'];
    currencyCode = json['currency_code'];
    discountPercent = json['discount_percent'];
    discountValue = json['discount_value'];
    discountLcvalue = json['discount_lcvalue'];
    taxRemark = json['tax_remark'];
    taxBasis = json['tax_basis'];
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

class WorkFlowIcons {
  String? name;
  String? icon;

  WorkFlowIcons({this.name, this.icon});

  WorkFlowIcons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
