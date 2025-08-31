// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class GrnAnalysis {
  List<GrnList>? grnList;

  GrnAnalysis({this.grnList});

  GrnAnalysis.fromJson(Map<String, dynamic> json) {
    if (json['grn_list'] != null) {
      grnList = <GrnList>[];
      json['grn_list'].forEach((v) {
        grnList!.add(GrnList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (grnList != null) {
      data['grn_list'] = grnList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrnList {
  int? srNo;
  int? grnHeaderId;
  String? grnDocDate;
  String? grnDocNo;
  String? grnRefPoDocNo;
  String? grnReceivingLoc;
  String? grnPettyCashNo;
  String? pendingWith;
  String? pendingSince;
  List<GrnItem>? items;

  GrnList({
    this.srNo,
    this.grnHeaderId,
    this.grnDocDate,
    this.grnDocNo,
    this.grnRefPoDocNo,
    this.grnReceivingLoc,
    this.grnPettyCashNo,
    this.pendingWith,
    this.pendingSince,
    this.items,
  });

  GrnList.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    grnHeaderId = json['grn_header_id'];
    grnDocDate = json['grn_doc_date'];
    grnDocNo = json['grn_doc_no'];
    grnRefPoDocNo = json['grn_ref_po_doc_no'];
    grnReceivingLoc = json['grn_receiving_loc'];
    grnPettyCashNo = json['grn_petty_cash_no'];
    pendingWith = json['pending_with'];
    pendingSince = json['pending_since'];
    if (json['items'] != null) {
      items = <GrnItem>[];
      json['items'].forEach((v) {
        items!.add(GrnItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['grn_header_id'] = grnHeaderId;
    data['grn_doc_date'] = grnDocDate;
    data['grn_doc_no'] = grnDocNo;
    data['grn_ref_po_doc_no'] = grnRefPoDocNo;
    data['grn_receiving_loc'] = grnReceivingLoc;
    data['grn_petty_cash_no'] = grnPettyCashNo;
    data['pending_with'] = pendingWith;
    data['pending_since'] = pendingSince;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrnItem {
  int? srNo;
  int? grnItemId;
  String? grnItemCode;
  String? grnItemDesc;
  int? grnUomId;
  String? grnUomCode;
  String? grnUomDesc;
  String? receivedQty;

  GrnItem({
    this.srNo,
    this.grnItemId,
    this.grnItemCode,
    this.grnItemDesc,
    this.grnUomId,
    this.grnUomCode,
    this.grnUomDesc,
    this.receivedQty,
  });

  GrnItem.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    grnItemId = json['grn_item_id'];
    grnItemCode = json['grn_item_code'];
    grnItemDesc = json['grn_item_desc'];
    grnUomId = json['grn_uom_id'];
    grnUomCode = json['grn_uom_code'];
    grnUomDesc = json['grn_uom_desc'];
    receivedQty = json['received_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['grn_item_id'] = grnItemId;
    data['grn_item_code'] = grnItemCode;
    data['grn_item_desc'] = grnItemDesc;
    data['grn_uom_id'] = grnUomId;
    data['grn_uom_code'] = grnUomCode;
    data['grn_uom_desc'] = grnUomDesc;
    data['received_qty'] = receivedQty;
    return data;
  }
}
