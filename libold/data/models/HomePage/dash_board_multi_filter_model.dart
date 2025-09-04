class DashBoardMultiFilterModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<RulesList>? rulesList;

  DashBoardMultiFilterModel(
      {error, errorCode, errorDescription, rulesList});

  DashBoardMultiFilterModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['rules_list'] != null) {
      rulesList = <RulesList>[];
      json['rules_list'].forEach((v) {
        rulesList!.add(RulesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (rulesList != null) {
      data['rules_list'] = rulesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RulesList {
  int? srNo;
  int? ruleId;
  String? ruleName;
  String? ruleType;
  String? ruleCondition;
  String? conditionData;
  //my added
  bool? isSelected = false;

  RulesList(
      {srNo,
        ruleId,
        ruleName,
        ruleType,
        ruleCondition,
        conditionData,
        isSelected,
      });

  RulesList.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    ruleId = json['rule_id'];
    ruleName = json['rule_name'];
    ruleType = json['rule_type'];
    ruleCondition = json['rule_condition'];
    conditionData = json['condition_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['rule_id'] = ruleId;
    data['rule_name'] = ruleName;
    data['rule_type'] = ruleType;
    data['rule_condition'] = ruleCondition;
    data['condition_data'] = conditionData;
    return data;
  }
}
