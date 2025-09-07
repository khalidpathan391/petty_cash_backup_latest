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
  int? addressId;
  String? addressCode;
  String? address1;
  String? address2;
  String? address3;
  String? pinCode;
  String? poBox;
  String? phoneNo;
  String? mobileNo;
  String? faxNo;
  String? city;
  String? state;
  String? country;
  String? addLink;
  String? countryCode;
  String? showval;
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
      this.addressId,
      this.addressCode,
      this.address1,
      this.address2,
      this.address3,
      this.pinCode,
      this.poBox,
      this.phoneNo,
      this.mobileNo,
      this.faxNo,
      this.city,
      this.state,
      this.country,
      this.addLink,
      this.countryCode,
      this.showval,
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
    addressId = json['address_id'];
    addressCode = json['address_code'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    pinCode = json['pin_code'];
    poBox = json['po_box'];
    phoneNo = json['phone_no'];
    mobileNo = json['mobile_no'];
    faxNo = json['fax_no'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addLink = json['add_link'];
    countryCode = json['country_code'];
    showval = json['showval'];
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
    data['address_id'] = this.addressId;
    data['address_code'] = this.addressCode;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['pin_code'] = this.pinCode;
    data['po_box'] = this.poBox;
    data['phone_no'] = this.phoneNo;
    data['mobile_no'] = this.mobileNo;
    data['fax_no'] = this.faxNo;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['add_link'] = this.addLink;
    data['country_code'] = this.countryCode;
    data['showval'] = this.showval;
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
