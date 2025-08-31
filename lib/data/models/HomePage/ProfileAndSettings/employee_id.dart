class EmployeeIDModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<Data>? data;

  EmployeeIDModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  EmployeeIDModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['error_description'] = this.errorDescription;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? empName;
  String? empNo;
  String? empJobTitle;
  String? empNationality;
  String? empBloodG;
  String? empValidity;
  String? hEmpNameBl;
  String? empNameBl;
  String? hEmpJobBl;
  String? empJobBl;
  String? hEmpValidityBl;
  String? empValidityBl;
  String? hEmpNoBl;
  String? empComName;
  String? empComNameBl;
  String? empComAdd1;
  String? empComAdd2;
  String? empComAdd3;
  String? empAddress1Bl;
  String? empAddBuildingNumber;
  String? empAddCity;
  String? empAddDistrict;
  String? empAddDistrict1Bl;
  String? empAddState;
  String? empAddPoBox;
  String? empAddCity1Bl;
  String? empAddState1Bl;
  String? empAddCountry1Bl;
  String? empAddCountryCode;
  String? empAddPoboxBl;
  String? empAddFaxNum;
  String? empIqamaNo;
  String? empComLogo;
  String? empPhoto;
  String? emergencyCoNo;
  String? gosiMedInsAssNo;

  Data(
      {this.empName,
      this.empNo,
      this.empJobTitle,
      this.empNationality,
      this.empBloodG,
      this.empValidity,
      this.hEmpNameBl,
      this.empNameBl,
      this.hEmpJobBl,
      this.empJobBl,
      this.hEmpValidityBl,
      this.empValidityBl,
      this.hEmpNoBl,
      this.empComName,
      this.empComNameBl,
      this.empComAdd1,
      this.empComAdd2,
      this.empComAdd3,
      this.empAddress1Bl,
      this.empAddBuildingNumber,
      this.empAddCity,
      this.empAddDistrict,
      this.empAddDistrict1Bl,
      this.empAddState,
      this.empAddPoBox,
      this.empAddCity1Bl,
      this.empAddState1Bl,
      this.empAddCountry1Bl,
      this.empAddCountryCode,
      this.empAddPoboxBl,
      this.empAddFaxNum,
      this.empIqamaNo,
      this.empComLogo,
      this.empPhoto,
      this.emergencyCoNo,
      this.gosiMedInsAssNo});

  Data.fromJson(Map<String, dynamic> json) {
    empName = json['emp_name'];
    empNo = json['emp_no'];
    empJobTitle = json['emp_job_title'];
    empNationality = json['emp_nationality'];
    empBloodG = json['emp_blood_g'];
    empValidity = json['emp_validity'];
    hEmpNameBl = json['h_emp_name_bl'];
    empNameBl = json['emp_name_bl'];
    hEmpJobBl = json['h_emp_job_bl'];
    empJobBl = json['emp_job_bl'];
    hEmpValidityBl = json['h_emp_validity_bl'];
    empValidityBl = json['emp_validity_bl'];
    hEmpNoBl = json['h_emp_no_bl'];
    empComName = json['emp_com_name'];
    empComNameBl = json['emp_com_name_bl'];
    empComAdd1 = json['emp_com_add1'];
    empComAdd2 = json['emp_com_add2'];
    empComAdd3 = json['emp_com_add3'];
    empAddress1Bl = json['emp_address1_bl'];
    empAddBuildingNumber = json['emp_add_building_number'];
    empAddCity = json['emp_add_city'];
    empAddDistrict = json['emp_add_district'];
    empAddDistrict1Bl = json['emp_add_district1_bl'];
    empAddState = json['emp_add_state'];
    empAddPoBox = json['emp_add_po_box'];
    empAddCity1Bl = json['emp_add_city1_bl'];
    empAddState1Bl = json['emp_add_state1_bl'];
    empAddCountry1Bl = json['emp_add_country1_bl'];
    empAddCountryCode = json['emp_add_country_code'];
    empAddPoboxBl = json['emp_add_pobox_bl'];
    empAddFaxNum = json['emp_add_fax_num'];
    empIqamaNo = json['emp_iqama_no'];
    empComLogo = json['emp_com_logo'];
    empPhoto = json['emp_photo'];
    emergencyCoNo = json['emergency_co_no'];
    gosiMedInsAssNo = json['gosi_med_ins_ass_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_name'] = this.empName;
    data['emp_no'] = this.empNo;
    data['emp_job_title'] = this.empJobTitle;
    data['emp_nationality'] = this.empNationality;
    data['emp_blood_g'] = this.empBloodG;
    data['emp_validity'] = this.empValidity;
    data['h_emp_name_bl'] = this.hEmpNameBl;
    data['emp_name_bl'] = this.empNameBl;
    data['h_emp_job_bl'] = this.hEmpJobBl;
    data['emp_job_bl'] = this.empJobBl;
    data['h_emp_validity_bl'] = this.hEmpValidityBl;
    data['emp_validity_bl'] = this.empValidityBl;
    data['h_emp_no_bl'] = this.hEmpNoBl;
    data['emp_com_name'] = this.empComName;
    data['emp_com_name_bl'] = this.empComNameBl;
    data['emp_com_add1'] = this.empComAdd1;
    data['emp_com_add2'] = this.empComAdd2;
    data['emp_com_add3'] = this.empComAdd3;
    data['emp_address1_bl'] = this.empAddress1Bl;
    data['emp_add_building_number'] = this.empAddBuildingNumber;
    data['emp_add_city'] = this.empAddCity;
    data['emp_add_district'] = this.empAddDistrict;
    data['emp_add_district1_bl'] = this.empAddDistrict1Bl;
    data['emp_add_state'] = this.empAddState;
    data['emp_add_po_box'] = this.empAddPoBox;
    data['emp_add_city1_bl'] = this.empAddCity1Bl;
    data['emp_add_state1_bl'] = this.empAddState1Bl;
    data['emp_add_country1_bl'] = this.empAddCountry1Bl;
    data['emp_add_country_code'] = this.empAddCountryCode;
    data['emp_add_pobox_bl'] = this.empAddPoboxBl;
    data['emp_add_fax_num'] = this.empAddFaxNum;
    data['emp_iqama_no'] = this.empIqamaNo;
    data['emp_com_logo'] = this.empComLogo;
    data['emp_photo'] = this.empPhoto;
    data['emergency_co_no'] = this.emergencyCoNo;
    data['gosi_med_ins_ass_no'] = this.gosiMedInsAssNo;
    return data;
  }
}
