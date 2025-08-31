import 'package:petty_cash/global.dart';

class HseSorCommonSearchingModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Data? data;

  HseSorCommonSearchingModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  HseSorCommonSearchingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
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
    List<SearchList> parsedSearchList = [];

    totalRecords = json['total_records'];
    pageLimit = json['page_limit'];
    if (json['search_list'] != null) {
      json['search_list'].forEach((v) {
        switch (Global.commonSearchType) {
          case SearchListType.defaultType:
            parsedSearchList.add(SearchListDefault.fromJson(v));
            break;
          case SearchListType.visaRequestApplyFor:
            parsedSearchList.add(SearchListVRApplyFor.fromJson(v));
            break;
          case SearchListType.visaRequestEmpData:
            parsedSearchList.add(SearchListVREmployee.fromJson(v));
            break;
          case SearchListType.fiEmpData:
            parsedSearchList.add(SearchListFIEmployee.fromJson(v));
            break;
          // Add more cases for other types
          default:
            throw Exception('Unknown SearchList type');
        }
      });
    }
    searchList = parsedSearchList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_records'] = totalRecords;
    data['page_limit'] = pageLimit;

    if (searchList != null) {
      List<Map<String, dynamic>> serializedSearchList = [];

      for (var element in searchList!) {
        switch (Global.commonSearchType) {
          case SearchListType.defaultType:
            if (element is SearchListDefault) {
              serializedSearchList.add(element.toJson());
            }
            break;
          case SearchListType.visaRequestApplyFor:
            if (element is SearchListVRApplyFor) {
              serializedSearchList.add(element.toJson());
            }
            break;
          case SearchListType.visaRequestEmpData:
            if (element is SearchListVREmployee) {
              serializedSearchList.add(element.toJson());
            }
            break;
          // Add more cases for other types
          default:
            throw Exception('Unknown SearchList type');
        }
      }

      data['search_list'] = serializedSearchList;
    }
    return data;
  }
}

abstract class SearchList {
  bool isSelected = false;
  // Common properties
  int? srNo;
  int? userId;
  int? id;
  String? code;
  String? desc;

  // Constructor
  SearchList({this.srNo, this.userId, this.id, this.code, this.desc});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['user_id'] = userId;
    data['id'] = id;
    data['code'] = code;
    data['desc'] = desc;
    return data;
  }

  void fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    userId = json['user_id'];
    id = json['id'];
    code = json['code'];
    desc = json['desc'];
  }
}

class SearchListDefault extends SearchList {
  int? jobId;
  String? jobCode;
  String? jobDesc;
  String? mobileMin;
  String? mobileMax;
  String? exchangeRate;
  String? plateNo;
  String? gfaData;
  String? encryptedData;
  int? empId;
  String? empCode;
  String? empName;

  SearchListDefault({
    int? srNo,
    int? userId,
    int? id,
    String? code,
    String? desc,
    this.jobId,
    this.jobCode,
    this.jobDesc,
    this.mobileMin,
    this.mobileMax,
    this.exchangeRate,
    this.plateNo,
    this.gfaData,
    this.encryptedData,
    this.empId,
    this.empCode,
    this.empName,
  }) : super(
            srNo: srNo,
            userId: userId,
            id: id,
            code: code,
            desc: desc); // Call to the base class constructor

  SearchListDefault.fromJson(Map<String, dynamic> json) : super() {
    super.fromJson(
        json); // Call to the base class method to handle common properties
    jobId = json['job_id'];
    jobCode = json['job_code'];
    jobDesc = json['job_desc'];
    mobileMin = json['mobile_min'];
    mobileMax = json['mobile_max'];
    exchangeRate = json['exchange_rate'];
    plateNo = json['plate_no'];
    gfaData = json['gfa_data'];
    encryptedData = json['encrypted_data'];
    empId = json['emp_id'];
    empCode = json['emp_code'];
    empName = json['emp_name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Get common properties
    data.addAll({
      'job_id': jobId,
      'job_code': jobCode,
      'job_desc': jobDesc,
      'mobile_min': mobileMin,
      'mobile_max': mobileMax,
      'exchange_rate': exchangeRate,
      'plate_no': plateNo,
      'gfa_data': gfaData,
      'encrypted_data': encryptedData,
      'emp_id': empId,
      'emp_code': empCode,
      'emp_name': empName,
    });
    return data;
  }
}

class SearchListVRApplyFor extends SearchList {
  String? label;
  String? value;
  String? adText01;
  int? visaTypeHS;
  int? msgApi;
  String? durInDaysEdit;

  SearchListVRApplyFor({
    int? srNo,
    this.label,
    String? desc,
    String? code,
    this.value,
    int? id,
    this.adText01,
    this.visaTypeHS,
    this.msgApi,
    int? userId,
    this.durInDaysEdit,
  }) : super(
            srNo: srNo,
            userId: userId,
            id: id,
            code: code,
            desc: desc); // Call to the base class constructor

  SearchListVRApplyFor.fromJson(Map<String, dynamic> json) : super() {
    super.fromJson(
        json); // Call to the base class method to handle common properties
    label = json['label'];
    value = json['value'];
    id = json['id'];
    adText01 = json['ad_text_01'];
    visaTypeHS = json['visa_type_h_s'];
    msgApi = json['msg_api'];
    durInDaysEdit = json['dur_in_days_edit'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Get common properties
    data.addAll({
      'label': label,
      'value': value,
      'ad_text_01': adText01,
      'visa_type_h_s': visaTypeHS,
      'msg_api': msgApi,
      'dur_in_days_edit': durInDaysEdit,
    });
    return data;
  }
}

class SearchListVREmployee extends SearchList {
  String? name;
  int? designationId;
  String? designationCode;
  String? designationDesc;
  int? costCenterId;
  String? costCenterCode;
  String? costCenterDesc;
  int? locationId;
  String? locationCode;
  String? location;
  int? divisionId;
  String? divisionCode;
  String? divisionDesc;
  int? religionId;
  bool? familyStatus;
  int? empFamilyStatusId;
  String? empFamilyStatusCode;
  String? empFamilyStatusDesc;
  int? passportId;
  String? passportNumber;
  int? iqamaId;
  String? iqamaNumber;
  String? iqamaExpDate;
  String? showval;

  SearchListVREmployee({
    int? srNo,
    int? id,
    String? code,
    this.name,
    this.designationId,
    this.designationCode,
    this.designationDesc,
    this.costCenterId,
    this.costCenterCode,
    this.costCenterDesc,
    this.locationId,
    this.locationCode,
    this.location,
    this.divisionId,
    this.divisionCode,
    this.divisionDesc,
    this.religionId,
    this.familyStatus,
    this.empFamilyStatusId,
    this.empFamilyStatusCode,
    this.empFamilyStatusDesc,
    this.passportId,
    this.passportNumber,
    this.iqamaId,
    this.iqamaNumber,
    this.iqamaExpDate,
    this.showval,
    int? userId,
  }) : super(
            srNo: srNo,
            userId: userId,
            id: id,
            code: code); // Call to the base class constructor

  SearchListVREmployee.fromJson(Map<String, dynamic> json) : super() {
    super.fromJson(
        json); // Call to the base class method to handle common properties
    name = json['name'];
    designationId = json['designation_id'];
    designationCode = json['designation_code'];
    designationDesc = json['designation_desc'];
    costCenterId = json['cost_center_id'];
    costCenterCode = json['cost_center_code'];
    costCenterDesc = json['cost_center_desc'];
    locationId = json['location_id'];
    locationCode = json['location_code'];
    location = json['location'];
    divisionId = json['division_id'];
    divisionCode = json['division_code'];
    divisionDesc = json['division_desc'];
    religionId = json['religion_id'];
    familyStatus = json['family_status'];
    empFamilyStatusId = json['emp_family_status_id'];
    empFamilyStatusCode = json['emp_family_status_code'];
    empFamilyStatusDesc = json['emp_family_status_desc'];
    passportId = json['passport_id'];
    passportNumber = json['passport_number'];
    iqamaId = json['iqama_id'];
    iqamaNumber = json['iqama_number'];
    iqamaExpDate = json['iqama_exp_date'];
    showval = json['showval'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Get common properties
    data.addAll({
      'name': name,
      'designation_id': designationId,
      'designation_code': designationCode,
      'designation_desc': designationDesc,
      'cost_center_id': costCenterId,
      'cost_center_code': costCenterCode,
      'cost_center_desc': costCenterDesc,
      'location_id': locationId,
      'location_code': locationCode,
      'location': location,
      'division_id': divisionId,
      'division_code': divisionCode,
      'division_desc': divisionDesc,
      'religion_id': religionId,
      'family_status': familyStatus,
      'emp_family_status_id': empFamilyStatusId,
      'emp_family_status_code': empFamilyStatusCode,
      'emp_family_status_desc': empFamilyStatusDesc,
      'passport_id': passportId,
      'passport_number': passportNumber,
      'iqama_id': iqamaId,
      'iqama_number': iqamaNumber,
      'iqama_exp_date': iqamaExpDate,
      'showval': showval,
    });
    return data;
  }
}

class SearchListFIEmployee extends SearchList {
  String? name;
  int? designationId;
  String? designationCode;
  String? designationDesc;
  int? projectId;
  String? projectCode;
  String? projectDesc;
  int? locationId;
  String? locationCode;
  String? locationDesc;
  int? divisionId;
  String? divisionCode;
  String? divisionDesc;
  int? departmentId;
  String? departmentCode;
  String? departmentDesc;
  int? materialStsId;
  String? materialStsCode;
  String? materialStsDesc;
  int? familyStsId;
  String? familyStsCode;
  String? familyStsDesc;

  SearchListFIEmployee({
    int? srNo,
    int? id,
    String? code,
    String? desc,
    this.name,
    this.designationId,
    this.designationCode,
    this.designationDesc,
    this.projectId,
    this.projectCode,
    this.projectDesc,
    this.locationId,
    this.locationCode,
    this.locationDesc,
    this.divisionId,
    this.divisionCode,
    this.divisionDesc,
    this.departmentId,
    this.departmentCode,
    this.departmentDesc,
    this.materialStsId,
    this.materialStsCode,
    this.materialStsDesc,
    this.familyStsId,
    this.familyStsCode,
    this.familyStsDesc,
    int? userId,
  }) : super(srNo: srNo, userId: userId, id: id, code: code, desc: desc);

  SearchListFIEmployee.fromJson(Map<String, dynamic> json) : super() {
    super.fromJson(json);
    name = json['name'];
    designationId = json['designation_id'];
    designationCode = json['designation_code'];
    designationDesc = json['designation_desc'];
    projectId = json['project_id'];
    projectCode = json['project_code'];
    projectDesc = json['project_desc'];
    locationId = json['location_id'];
    locationCode = json['location_code'];
    locationDesc = json['location_desc'];
    divisionId = json['division_id'];
    divisionCode = json['division_code'];
    divisionDesc = json['division_desc'];
    departmentId = json['department_id'];
    departmentCode = json['department_code'];
    departmentDesc = json['department_desc'];
    materialStsId = json['material_sts_id'];
    materialStsCode = json['material_sts_code'];
    materialStsDesc = json['material_sts_desc'];
    familyStsId = json['family_sts_id'];
    familyStsCode = json['family_sts_code'];
    familyStsDesc = json['family_sts_desc'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'name': name,
      'designation_id': designationId,
      'designation_code': designationCode,
      'designation_desc': designationDesc,
      'project_id': projectId,
      'project_code': projectCode,
      'project_desc': projectDesc,
      'location_id': locationId,
      'location_code': locationCode,
      'location_desc': locationDesc,
      'division_id': divisionId,
      'division_code': divisionCode,
      'division_desc': divisionDesc,
      'department_id': departmentId,
      'department_code': departmentCode,
      'department_desc': departmentDesc,
      'material_sts_id': materialStsId,
      'material_sts_code': materialStsCode,
      'material_sts_desc': materialStsDesc,
      'family_sts_id': familyStsId,
      'family_sts_code': familyStsCode,
      'family_sts_desc': familyStsDesc,
    });
    return data;
  }
}
