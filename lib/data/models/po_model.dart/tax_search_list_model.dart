// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TaxPopupSearchListModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Data? data;

  TaxPopupSearchListModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  TaxPopupSearchListModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? code;
  String? desc;
  String? basis;
  String? percent;
  int? isRecover;
  String? name;
  String? value;
  String? kLabel;
  String? forCode;
  int? mandatoryTf;
  int? editableTf;
  int? expiryTf;
  int? defaultTf;
  String? minimum;
  String? maximum;
  SearchList(
      {this.id,
      this.code,
      this.desc,
      this.basis,
      this.percent,
      this.isRecover,
      this.name,
      this.value,
      this.kLabel,
      this.forCode,
      this.mandatoryTf,
      this.editableTf,
      this.expiryTf,
      this.defaultTf,
      this.minimum,
      this.maximum});

  SearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    desc = json['desc'];
    basis = json['basis'];
    percent = json['percent'];
    isRecover = json['is_recover'];

    name = json['name'];
    value = json['value'];
    kLabel = json['k_label'];
    forCode = json['for_code'];
    mandatoryTf = json['mandatory_tf'];
    editableTf = json['editable_tf'];
    expiryTf = json['expiry_tf'];
    defaultTf = json['default_tf'];
    minimum = json['minimum'];
    maximum = json['maximum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['desc'] = this.desc;
    data['basis'] = this.basis;
    data['percent'] = this.percent;
    data['is_recover'] = this.isRecover;

    data['name'] = this.name;
    data['value'] = this.value;
    data['k_label'] = this.kLabel;
    data['for_code'] = this.forCode;
    data['mandatory_tf'] = this.mandatoryTf;
    data['editable_tf'] = this.editableTf;
    data['expiry_tf'] = this.expiryTf;
    data['default_tf'] = this.defaultTf;
    data['minimum'] = this.minimum;
    data['maximum'] = this.maximum;
    return data;
  }
}
