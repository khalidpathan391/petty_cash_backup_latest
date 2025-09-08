// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class SupplierTypeModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Data? data;

  SupplierTypeModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  SupplierTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? value;
  String? kLabel;
  int? addressId;
  String? desc;
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

  List<SupplierValidation>? supplierValidation;

  SearchList(
      {this.id,
      this.code,
      this.name,
      this.value,
      this.kLabel,
      this.addressId,
      this.desc,
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
      this.supplierValidation});

  SearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    value = json['value'];
    kLabel = json['k_label'];

    desc = json['desc'];
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
    if (json['supplier_validation'] != null) {
      supplierValidation = <SupplierValidation>[];
      json['supplier_validation'].forEach((v) {
        supplierValidation!.add(new SupplierValidation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['value'] = this.value;
    data['k_label'] = this.kLabel;
    data['address_id'] = this.addressId;

    data['desc'] = this.desc;
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
    if (this.supplierValidation != null) {
      data['supplier_validation'] =
          this.supplierValidation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SupplierValidation {
  int? id;
  int? fieldId;
  String? fieldCode;
  String? fieldName;
  String? forCode;
  int? mandatoryTf;
  int? editableTf;
  int? expiryTf;
  int? defaultTf;
  String? minimum;
  String? maximum;

  SupplierValidation(
      {this.id,
      this.fieldId,
      this.fieldCode,
      this.fieldName,
      this.forCode,
      this.mandatoryTf,
      this.editableTf,
      this.expiryTf,
      this.defaultTf,
      this.minimum,
      this.maximum});

  SupplierValidation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldId = json['field_id'];
    fieldCode = json['field_code'];
    fieldName = json['field_name'];
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
    data['field_id'] = this.fieldId;
    data['field_code'] = this.fieldCode;
    data['field_name'] = this.fieldName;
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
