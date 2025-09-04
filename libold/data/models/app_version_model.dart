class AppVersionModel {
  int? id;
  int? deviceType;
  String? versionCode;
  int? isMandatory;
  bool? error;
  int? errorCode;
  String? errorDescription;

  AppVersionModel(
      {this.id,
        this.deviceType,
        this.versionCode,
        this.isMandatory,
        this.error,
        this.errorCode,
        this.errorDescription});

  AppVersionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceType = json['device_type'];
    versionCode = json['version_code'];
    isMandatory = json['is_mandatory'];
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['device_type'] = deviceType;
    data['version_code'] = versionCode;
    data['is_mandatory'] = isMandatory;
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    return data;
  }
}
