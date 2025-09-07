// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ItemDetailsModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Data? data;

  ItemDetailsModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['error_description'] = this.errorDescription;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalRecords;
  int? pageLimit;
  List<SearchList>? searchList;

  Data({this.totalRecords, this.pageLimit, this.searchList});

  Data.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    pageLimit = json['page_limit'];
    if (json['search_list'] != null) {
      searchList = <SearchList>[];
      json['search_list'].forEach((v) {
        searchList!.add(new SearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_records'] = this.totalRecords;
    data['page_limit'] = this.pageLimit;
    if (this.searchList != null) {
      data['search_list'] = this.searchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchList {
  int? itemId;
  String? itemCode;
  String? itemName;
  String? itemDescription;
  String? itemLongDescription;
  String? stdRate;
  bool? itemDimension;
  int? stockTf;
  String? additionalInfoCode;
  int? itemClassificationId;
  String? medicineType;
  String? itemIsBatch;
  bool? itemIsSerial;
  int? itemCalibration;
  String? traceBy;
  String? isInspection;
  bool? itemLocatorTf;
  int? itemLooseQty;
  int? baseLooseQty;
  int? uomId;
  String? uomCode;
  bool? uomDimensional;
  int? glCodeId;
  String? glCode;
  String? glDesc;
  String? descChangeAllow;
  int? id;
  String? code;
  String? desc;
  String? basis;
  String? percent;
  int? isRecover;

  SearchList({
    this.itemId,
    this.itemCode,
    this.itemName,
    this.itemDescription,
    this.itemLongDescription,
    this.stdRate,
    this.itemDimension,
    this.stockTf,
    this.additionalInfoCode,
    this.itemClassificationId,
    this.medicineType,
    this.itemIsBatch,
    this.itemIsSerial,
    this.itemCalibration,
    this.traceBy,
    this.isInspection,
    this.itemLocatorTf,
    this.itemLooseQty,
    this.baseLooseQty,
    this.uomId,
    this.uomCode,
    this.uomDimensional,
    this.glCodeId,
    this.glCode,
    this.glDesc,
    this.descChangeAllow,
    this.id,
    this.code,
    this.desc,
    this.basis,
    this.percent,
    this.isRecover,
  });

  SearchList.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemCode = json['item_code'];
    itemName = json['item_name'];
    itemDescription = json['item_description'];
    itemLongDescription = json['item_long_description'];
    stdRate = json['std_rate'];
    itemDimension = json['item_dimension'];
    stockTf = json['stock_tf'];
    additionalInfoCode = json['additional_info_code'];
    itemClassificationId = json['item_classification_id'];
    medicineType = json['medicine_type'];
    itemIsBatch = json['item_is_batch'];
    itemIsSerial = json['item_is_serial'];
    itemCalibration = json['item_calibration'];
    traceBy = json['trace_by'];
    isInspection = json['is_inspection'];
    itemLocatorTf = json['item_locator_tf'];
    itemLooseQty = json['item_loose_qty'];
    baseLooseQty = json['base_loose_qty'];
    uomId = json['uom_id'];
    uomCode = json['uom_code'];
    uomDimensional = json['uom_dimensional'];
    glCodeId = json['gl_code_id'];
    glCode = json['gl_code'];
    glDesc = json['gl_desc'];
    descChangeAllow = json['desc_change_allow'];
    id = json['id'];
    code = json['code'];
    desc = json['desc'];
    basis = json['basis'];
    percent = json['percent'];
    isRecover = json['is_recover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_code'] = this.itemCode;
    data['item_name'] = this.itemName;
    data['item_description'] = this.itemDescription;
    data['item_long_description'] = this.itemLongDescription;
    data['std_rate'] = this.stdRate;
    data['item_dimension'] = this.itemDimension;
    data['stock_tf'] = this.stockTf;
    data['additional_info_code'] = this.additionalInfoCode;
    data['item_classification_id'] = this.itemClassificationId;
    data['medicine_type'] = this.medicineType;
    data['item_is_batch'] = this.itemIsBatch;
    data['item_is_serial'] = this.itemIsSerial;
    data['item_calibration'] = this.itemCalibration;
    data['trace_by'] = this.traceBy;
    data['is_inspection'] = this.isInspection;
    data['item_locator_tf'] = this.itemLocatorTf;
    data['item_loose_qty'] = this.itemLooseQty;
    data['base_loose_qty'] = this.baseLooseQty;
    data['uom_id'] = this.uomId;
    data['uom_code'] = this.uomCode;
    data['uom_dimensional'] = this.uomDimensional;
    data['gl_code_id'] = this.glCodeId;
    data['gl_code'] = this.glCode;
    data['gl_desc'] = this.glDesc;
    data['desc_change_allow'] = this.descChangeAllow;
    data['id'] = this.id;
    data['code'] = this.code;
    data['desc'] = this.desc;
    data['basis'] = this.basis;
    data['percent'] = this.percent;
    data['is_recover'] = this.isRecover;
    return data;
  }
}
