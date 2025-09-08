// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PoListingModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  PoListingData? data;

  PoListingModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  PoListingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    data =
        json['data'] != null ? new PoListingData.fromJson(json['data']) : null;
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

class PoListingData {
  int? totalRecords;
  int? pageLimit;
  List<SearchList>? searchList;

  PoListingData({this.totalRecords, this.pageLimit, this.searchList});

  PoListingData.fromJson(Map<String, dynamic> json) {
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
  String? docDt;
  String? txnCode;
  String? reference;
  String? status;
  String? crByCode;
  String? crUidByName;
  String? crDate;

  SearchList(
      {this.id,
      this.docDt,
      this.txnCode,
      this.reference,
      this.status,
      this.crByCode,
      this.crUidByName,
      this.crDate});

  SearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docDt = json['doc_dt'];
    txnCode = json['txn_code'];
    reference = json['reference'];
    status = json['status'];
    crByCode = json['cr_by_code'];
    crUidByName = json['cr_uid_by_name'];
    crDate = json['cr_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_dt'] = this.docDt;
    data['txn_code'] = this.txnCode;
    data['reference'] = this.reference;
    data['status'] = this.status;
    data['cr_by_code'] = this.crByCode;
    data['cr_uid_by_name'] = this.crUidByName;
    data['cr_date'] = this.crDate;
    return data;
  }
}
