class CompanySelectingModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<AllCompData>? allCompData;

  CompanySelectingModel({error, errorCode, errorDescription, allCompData});

  CompanySelectingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['all_comp_data'] != null) {
      allCompData = <AllCompData>[];
      json['all_comp_data'].forEach((v) {
        allCompData!.add(AllCompData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (allCompData != null) {
      data['all_comp_data'] = allCompData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCompData {
  int? compId;
  String? compCode;
  String? compName;
  String? compLogo;
  int? defaultComp;

  AllCompData({compId, compCode, compName, compLogo, defaultComp});

  AllCompData.fromJson(Map<String, dynamic> json) {
    compId = json['comp_id'];
    compCode = json['comp_code'];
    compName = json['comp_name'];
    compLogo = json['comp_logo'];
    defaultComp = json['default_comp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comp_id'] = compId;
    data['comp_code'] = compCode;
    data['comp_name'] = compName;
    data['comp_logo'] = compLogo;
    data['default_comp'] = defaultComp;
    return data;
  }
}
