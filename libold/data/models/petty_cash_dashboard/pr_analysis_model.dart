// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PRAnalysis {
  List<PrHeadList>? prHeadList;
  List<PrItemList>? prItemList;

  PRAnalysis({this.prHeadList, this.prItemList});

  PRAnalysis.fromJson(Map<String, dynamic> json) {
    if (json['pr_head_list'] != null) {
      prHeadList = <PrHeadList>[];
      json['pr_head_list'].forEach((v) {
        prHeadList!.add(new PrHeadList.fromJson(v));
      });
    }
    if (json['pr_item_list'] != null) {
      prItemList = <PrItemList>[];
      json['pr_item_list'].forEach((v) {
        prItemList!.add(new PrItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prHeadList != null) {
      data['pr_head_list'] = this.prHeadList!.map((v) => v.toJson()).toList();
    }
    if (this.prItemList != null) {
      data['pr_item_list'] = this.prItemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrHeadList {
  int? srNo;
  int? prHeaderId;
  String? prDocDate;
  String? prDocType;
  String? prDocNo;
  int? prChargeTypeId;
  String? prChargeTypeCode;
  String? prChargeTypeDesc;
  String? prChargeToId;
  String? prChargeToCode;
  String? prChargeToDesc;
  String? prStoreLocId;
  String? prStoreLocCode;
  String? prStoreLocDesc;
  String? prNeedByDate;
  String? prRemarks;

  PrHeadList(
      {this.srNo,
      this.prHeaderId,
      this.prDocDate,
      this.prDocType,
      this.prDocNo,
      this.prChargeTypeId,
      this.prChargeTypeCode,
      this.prChargeTypeDesc,
      this.prChargeToId,
      this.prChargeToCode,
      this.prChargeToDesc,
      this.prStoreLocId,
      this.prStoreLocCode,
      this.prStoreLocDesc,
      this.prNeedByDate,
      this.prRemarks});

  PrHeadList.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    prHeaderId = json['pr_header_id'];
    prDocDate = json['pr_doc_date'];
    prDocType = json['pr_doc_type'];
    prDocNo = json['pr_doc_no'];
    prChargeTypeId = json['pr_charge_type_id'];
    prChargeTypeCode = json['pr_charge_type_code'];
    prChargeTypeDesc = json['pr_charge_type_desc'];
    prChargeToId = json['pr_charge_to_id'];
    prChargeToCode = json['pr_charge_to_code'];
    prChargeToDesc = json['pr_charge_to_desc'];
    prStoreLocId = json['pr_store_loc_id'];
    prStoreLocCode = json['pr_store_loc_code'];
    prStoreLocDesc = json['pr_store_loc_desc'];
    prNeedByDate = json['pr_need_by_date'];
    prRemarks = json['pr_remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['pr_header_id'] = this.prHeaderId;
    data['pr_doc_date'] = this.prDocDate;
    data['pr_doc_type'] = this.prDocType;
    data['pr_doc_no'] = this.prDocNo;
    data['pr_charge_type_id'] = this.prChargeTypeId;
    data['pr_charge_type_code'] = this.prChargeTypeCode;
    data['pr_charge_type_desc'] = this.prChargeTypeDesc;
    data['pr_charge_to_id'] = this.prChargeToId;
    data['pr_charge_to_code'] = this.prChargeToCode;
    data['pr_charge_to_desc'] = this.prChargeToDesc;
    data['pr_store_loc_id'] = this.prStoreLocId;
    data['pr_store_loc_code'] = this.prStoreLocCode;
    data['pr_store_loc_desc'] = this.prStoreLocDesc;
    data['pr_need_by_date'] = this.prNeedByDate;
    data['pr_remarks'] = this.prRemarks;
    return data;
  }
}

class PrItemList {
  int? srNo;
  int? prHeaderId;
  int? priLineId;
  int? priItemId;
  String? priItemCode;
  String? priItemDesc;
  int? priUomId;
  String? priUomCode;
  String? priUomDesc;
  String? priItemQty;
  String? priAssignedDate;
  String? priNoteToBuyer;
  List<PriMnfrPopup>? priMnfrPopup;
  List<PriSupplierPopup>? priSupplierPopup;

  PrItemList(
      {this.srNo,
      this.prHeaderId,
      this.priLineId,
      this.priItemId,
      this.priItemCode,
      this.priItemDesc,
      this.priUomId,
      this.priUomCode,
      this.priUomDesc,
      this.priItemQty,
      this.priAssignedDate,
      this.priNoteToBuyer,
      this.priMnfrPopup,
      this.priSupplierPopup});

  PrItemList.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    prHeaderId = json['pr_header_id'];
    priLineId = json['pri_line_id'];
    priItemId = json['pri_item_id'];
    priItemCode = json['pri_item_code'];
    priItemDesc = json['pri_item_desc'];
    priUomId = json['pri_uom_id'];
    priUomCode = json['pri_uom_code'];
    priUomDesc = json['pri_uom_desc'];
    priItemQty = json['pri_item_qty'];
    priAssignedDate = json['pri_assigned_date'];
    priNoteToBuyer = json['pri_note_to_buyer'];
    if (json['pri_mnfr_popup'] != null) {
      priMnfrPopup = <PriMnfrPopup>[];
      json['pri_mnfr_popup'].forEach((v) {
        priMnfrPopup!.add(new PriMnfrPopup.fromJson(v));
      });
    }
    if (json['pri_supplier_popup'] != null) {
      priSupplierPopup = <PriSupplierPopup>[];
      json['pri_supplier_popup'].forEach((v) {
        priSupplierPopup!.add(new PriSupplierPopup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['pr_header_id'] = this.prHeaderId;
    data['pri_line_id'] = this.priLineId;
    data['pri_item_id'] = this.priItemId;
    data['pri_item_code'] = this.priItemCode;
    data['pri_item_desc'] = this.priItemDesc;
    data['pri_uom_id'] = this.priUomId;
    data['pri_uom_code'] = this.priUomCode;
    data['pri_uom_desc'] = this.priUomDesc;
    data['pri_item_qty'] = this.priItemQty;
    data['pri_assigned_date'] = this.priAssignedDate;
    data['pri_note_to_buyer'] = this.priNoteToBuyer;
    if (this.priMnfrPopup != null) {
      data['pri_mnfr_popup'] =
          this.priMnfrPopup!.map((v) => v.toJson()).toList();
    }
    if (this.priSupplierPopup != null) {
      data['pri_supplier_popup'] =
          this.priSupplierPopup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriMnfrPopup {
  int? srNo;
  int? priLineId;
  int? mnfrLineId;
  int? mnfrCodeId;
  String? mnfrCodeCode;
  String? mnfrCodeDesc;
  String? mnfrPartNo;
  int? mnfrCountryId;
  String? mnfrCountryCode;
  String? mnfrCountryDesc;

  PriMnfrPopup(
      {this.srNo,
      this.priLineId,
      this.mnfrLineId,
      this.mnfrCodeId,
      this.mnfrCodeCode,
      this.mnfrCodeDesc,
      this.mnfrPartNo,
      this.mnfrCountryId,
      this.mnfrCountryCode,
      this.mnfrCountryDesc});

  PriMnfrPopup.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    priLineId = json['pri_line_id'];
    mnfrLineId = json['mnfr_line_id'];
    mnfrCodeId = json['mnfr_code_id'];
    mnfrCodeCode = json['mnfr_code_code'];
    mnfrCodeDesc = json['mnfr_code_desc'];
    mnfrPartNo = json['mnfr_part_no'];
    mnfrCountryId = json['mnfr_country_id'];
    mnfrCountryCode = json['mnfr_country_code'];
    mnfrCountryDesc = json['mnfr_country_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['pri_line_id'] = this.priLineId;
    data['mnfr_line_id'] = this.mnfrLineId;
    data['mnfr_code_id'] = this.mnfrCodeId;
    data['mnfr_code_code'] = this.mnfrCodeCode;
    data['mnfr_code_desc'] = this.mnfrCodeDesc;
    data['mnfr_part_no'] = this.mnfrPartNo;
    data['mnfr_country_id'] = this.mnfrCountryId;
    data['mnfr_country_code'] = this.mnfrCountryCode;
    data['mnfr_country_desc'] = this.mnfrCountryDesc;
    return data;
  }
}

class PriSupplierPopup {
  int? srNo;
  int? priLineId;
  int? suppLineId;
  int? suppCodeId;
  String? suppCodeCode;
  String? suppCodeName;

  PriSupplierPopup(
      {this.srNo,
      this.priLineId,
      this.suppLineId,
      this.suppCodeId,
      this.suppCodeCode,
      this.suppCodeName});

  PriSupplierPopup.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    priLineId = json['pri_line_id'];
    suppLineId = json['supp_line_id'];
    suppCodeId = json['supp_code_id'];
    suppCodeCode = json['supp_code_code'];
    suppCodeName = json['supp_code_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr_no'] = this.srNo;
    data['pri_line_id'] = this.priLineId;
    data['supp_line_id'] = this.suppLineId;
    data['supp_code_id'] = this.suppCodeId;
    data['supp_code_code'] = this.suppCodeCode;
    data['supp_code_name'] = this.suppCodeName;
    return data;
  }
}
