// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PurchaserequestReferenceModel {
  List<ReferencePR>? referencePR;

  PurchaserequestReferenceModel({this.referencePR});

  PurchaserequestReferenceModel.fromJson(Map<String, dynamic> json) {
    if (json['reference_PR'] != null) {
      referencePR = <ReferencePR>[];
      json['reference_PR'].forEach((v) {
        referencePR!.add(new ReferencePR.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.referencePR != null) {
      data['reference_PR'] = this.referencePR!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReferencePR {
  int? srNo;
  int? prHeaderId;
  String? prDocType;
  String? prDocNo;
  int? priLineId;
  int? priItemId;
  String? priItemCode;
  String? priItemDesc;
  int? priUomId;
  String? priUomCode;
  String? priUomDesc;
  String? priItemQty;
  String? priNoteToBuyer;
  List<PriMnfrPopup>? priMnfrPopup;
  List<PriSupplierPopup>? priSupplierPopup;

  ReferencePR(
      {this.srNo,
      this.prHeaderId,
      this.prDocType,
      this.prDocNo,
      this.priLineId,
      this.priItemId,
      this.priItemCode,
      this.priItemDesc,
      this.priUomId,
      this.priUomCode,
      this.priUomDesc,
      this.priItemQty,
      this.priNoteToBuyer,
      this.priMnfrPopup,
      this.priSupplierPopup});

  ReferencePR.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    prHeaderId = json['pr_header_id'];
    prDocType = json['pr_doc_type'];
    prDocNo = json['pr_doc_no'];
    priLineId = json['pri_line_id'];
    priItemId = json['pri_item_id'];
    priItemCode = json['pri_item_code'];
    priItemDesc = json['pri_item_desc'];
    priUomId = json['pri_uom_id'];
    priUomCode = json['pri_uom_code'];
    priUomDesc = json['pri_uom_desc'];
    priItemQty = json['pri_item_qty'];
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
    data['pr_doc_type'] = this.prDocType;
    data['pr_doc_no'] = this.prDocNo;
    data['pri_line_id'] = this.priLineId;
    data['pri_item_id'] = this.priItemId;
    data['pri_item_code'] = this.priItemCode;
    data['pri_item_desc'] = this.priItemDesc;
    data['pri_uom_id'] = this.priUomId;
    data['pri_uom_code'] = this.priUomCode;
    data['pri_uom_desc'] = this.priUomDesc;
    data['pri_item_qty'] = this.priItemQty;
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
