class DashBoardConditionalModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<CommonSearchList>? commonSearchList;

  DashBoardConditionalModel(
      {error,
        errorCode,
        errorDescription,
        commonSearchList});

  DashBoardConditionalModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['common_search_list'] != null) {
      commonSearchList = <CommonSearchList>[];
      json['common_search_list'].forEach((v) {
        commonSearchList!.add(CommonSearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (commonSearchList != null) {
      data['common_search_list'] =
          commonSearchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonSearchList {
  int? id;
  String? code;
  String? desc;
  String? value;
  String? showvalue;
  //my added
  String? showval;
  String? description;

  CommonSearchList({id, code, desc, value, showvalue,
    //my added
    showval,
    description,
  });

  CommonSearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    desc = json['desc'];
    value = json['value'];
    showvalue = json['showvalue'];
    //myadded
    showval = json['showval'];
    description = json['description'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['desc'] = desc;
    data['value'] = value;
    data['showvalue'] = showvalue;
    //my added
    data['showval'] = showval;
    data['description'] = description;
    return data;
  }
}
