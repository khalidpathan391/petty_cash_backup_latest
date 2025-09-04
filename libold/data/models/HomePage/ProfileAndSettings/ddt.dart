class EmployeeDTDModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Data? data;

  EmployeeDTDModel(
      {this.error, this.errorCode, this.errorDescription, this.data});

  EmployeeDTDModel.fromJson(Map<String, dynamic> json) {
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
  String? empName;
  String? empNo;
  String? licenceType;
  String? permitNumber;
  String? actualDt;
  String? empIqamaNo;
  String? empComLogo;
  String? empPhoto;
  String? emergency;
  String? greenLogo;
  String? drivingIssDt;
  String? drivingExpDt;
  String? manualVehicle;
  int? etdEmpId;
  String? etdEmpCode;
  String? etdEmpDesc;
  int? hseEmpId;
  String? hseEmpCode;
  String? hseEmpDesc;

  Data(
      {this.empName,
      this.empNo,
      this.licenceType,
      this.permitNumber,
      this.actualDt,
      this.empIqamaNo,
      this.empComLogo,
      this.empPhoto,
      this.emergency,
      this.greenLogo,
      this.drivingIssDt,
      this.drivingExpDt,
      this.manualVehicle,
      this.etdEmpId,
      this.etdEmpCode,
      this.etdEmpDesc,
      this.hseEmpId,
      this.hseEmpCode,
      this.hseEmpDesc});

  Data.fromJson(Map<String, dynamic> json) {
    empName = json['emp_name'];
    empNo = json['emp_no'];
    licenceType = json['licence_type'];
    permitNumber = json['permit_number'];
    actualDt = json['actual_dt'];
    empIqamaNo = json['emp_iqama_no'];
    empComLogo = json['emp_com_logo'];
    empPhoto = json['emp_photo'];
    emergency = json['emergency'];
    greenLogo = json['green_logo'];
    drivingIssDt = json['driving_iss_dt'];
    drivingExpDt = json['driving_exp_dt'];
    manualVehicle = json['manual_vehicle'];
    etdEmpId = json['etd_emp_id'];
    etdEmpCode = json['etd_emp_code'];
    etdEmpDesc = json['etd_emp_desc'];
    hseEmpId = json['hse_emp_id'];
    hseEmpCode = json['hse_emp_code'];
    hseEmpDesc = json['hse_emp_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_name'] = this.empName;
    data['emp_no'] = this.empNo;
    data['licence_type'] = this.licenceType;
    data['permit_number'] = this.permitNumber;
    data['actual_dt'] = this.actualDt;
    data['emp_iqama_no'] = this.empIqamaNo;
    data['emp_com_logo'] = this.empComLogo;
    data['emp_photo'] = this.empPhoto;
    data['emergency'] = this.emergency;
    data['green_logo'] = this.greenLogo;
    data['driving_iss_dt'] = this.drivingIssDt;
    data['driving_exp_dt'] = this.drivingExpDt;
    data['manual_vehicle'] = this.manualVehicle;
    data['etd_emp_id'] = this.etdEmpId;
    data['etd_emp_code'] = this.etdEmpCode;
    data['etd_emp_desc'] = this.etdEmpDesc;
    data['hse_emp_id'] = this.hseEmpId;
    data['hse_emp_code'] = this.hseEmpCode;
    data['hse_emp_desc'] = this.hseEmpDesc;
    return data;
  }
}
