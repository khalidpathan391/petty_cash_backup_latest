class AuthenticationModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  EmpData? empData;

  AuthenticationModel({error, errorCode, errorDescription, idKeyReqData});

  AuthenticationModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    empData =
        json['emp_data'] != null ? EmpData.fromJson(json['emp_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (empData != null) {
      data['emp_data'] = empData!.toJson();
    }
    return data;
  }
}

class EmpData {
  int? userId;
  int? companyId;
  int? empId;
  String? empCode;
  String? empName;
  int? jobId;
  String? jobCode;
  String? jobDesc;
  int? projId;
  String? projCode;
  String? projDesc;
  int? divisionId;
  String? divisionCode;
  String? divisionDesc;
  int? deptId;
  String? deptCode;
  String? deptDesc;
  int? id;
  String? key;
  int? media;
  String? fileName;

  //locally created variable not in api
  bool? isLoggedIn;

  String? companyName;
  String? companyWebsite;
  String? compAddress1;
  String? compAddress2;
  String? compAddress3;
  String? compAddressCode;
  String? countryCode;
  String? countryName;
  int? designationId;
  String? designationCode;
  String? designationDesc;
  String? firstName;
  String? lastName;
  String? contactMobile;
  String? contactPhone;
  String? extension;
  String? mobilePersonal;
  String? mobileOfficial;
  String? phonePersonal;
  String? whatsapp;
  String? likedin;
  String? instagram;
  String? facebook;
  String? x;
  String? note;

  EmpData({
    userId,
    companyId,
    empId,
    empCode,
    empName,
    jobId,
    jobCode,
    jobDesc,
    projId,
    projCode,
    projDesc,
    divisionId,
    divisionCode,
    divisionDesc,
    deptId,
    deptCode,
    deptDesc,
    id,
    key,
    fileName,
    media,
    isLoggedIn,
    companyName,
    companyWebsite,
    compAddress1,
    compAddress2,
    compAddress3,
    compAddressCode,
    countryCode,
    countryName,
    designationId,
    designationCode,
    designationDesc,
    firstName,
    lastName,
    contactMobile,
    contactPhone,
    extension,
    mobilePersonal,
    mobileOfficial,
    phonePersonal,
    whatsapp,
    likedin,
    instagram,
    facebook,
    x,
    note,
  });

  EmpData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    companyId = json['company_id'];
    empId = json['emp_id'];
    empCode = json['emp_code'];
    empName = json['emp_name'];
    jobId = json['job_id'];
    jobCode = json['job_code'];
    jobDesc = json['job_desc'];
    projId = json['proj_id'];
    projCode = json['proj_code'];
    projDesc = json['proj_desc'];
    divisionId = json['division_id'];
    divisionCode = json['division_code'];
    divisionDesc = json['division_desc'];
    deptId = json['dept_id'];
    deptCode = json['dept_code'];
    deptDesc = json['dept_desc'];
    id = json['id'];
    key = json['key'];
    media = json['media'];
    fileName = json['file_name'];
    isLoggedIn = json['is_login'];

    companyName = json['company_name'];
    companyWebsite = json['company_website'];
    compAddress1 = json['comp_address1'];
    compAddress2 = json['comp_address2'];
    compAddress3 = json['comp_address3'];
    compAddressCode = json['comp_address_code'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    designationId = json['designation_id'];
    designationCode = json['designation_code'];
    designationDesc = json['designation_desc'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactMobile = json['contact_mobile'];
    contactPhone = json['contact_phone'];
    extension = json['extension'];
    mobilePersonal = json['mobile_personal'];
    mobileOfficial = json['mobile_official'];
    phonePersonal = json['phone_personal'];
    whatsapp = json['whatsapp'];
    likedin = json['likedin'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    x = json['x'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['emp_id'] = empId;
    data['emp_code'] = empCode;
    data['emp_name'] = empName;
    data['job_id'] = jobId;
    data['job_code'] = jobCode;
    data['job_desc'] = jobDesc;
    data['proj_id'] = projId;
    data['proj_code'] = projCode;
    data['proj_desc'] = projDesc;
    data['division_id'] = divisionId;
    data['division_code'] = divisionCode;
    data['division_desc'] = divisionDesc;
    data['dept_id'] = deptId;
    data['dept_code'] = deptCode;
    data['dept_desc'] = deptDesc;
    data['id'] = id;
    data['key'] = key;
    data['media'] = media;
    data['file_name'] = fileName;
    data['is_login'] = isLoggedIn;

    data['company_name'] = companyName;
    data['company_website'] = companyWebsite;
    data['comp_address1'] = compAddress1;
    data['comp_address2'] = compAddress2;
    data['comp_address3'] = compAddress3;
    data['comp_address_code'] = compAddressCode;
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    data['designation_id'] = designationId;
    data['designation_code'] = designationCode;
    data['designation_desc'] = designationDesc;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['contact_mobile'] = contactMobile;
    data['contact_phone'] = contactPhone;
    data['extension'] = extension;
    data['mobile_personal'] = mobilePersonal;
    data['mobile_official'] = mobileOfficial;
    data['phone_personal'] = phonePersonal;
    data['whatsapp'] = whatsapp;
    data['likedin'] = likedin;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['x'] = x;
    data['note'] = note;
    return data;
  }
}
