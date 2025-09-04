class DashBoardUpdateModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  RunRules? runRules;

  DashBoardUpdateModel(
      {error, errorCode, errorDescription, runRules});

  DashBoardUpdateModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    runRules = json['run_rules'] != null
        ? RunRules.fromJson(json['run_rules'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (runRules != null) {
      data['run_rules'] = runRules!.toJson();
    }
    return data;
  }
}

class RunRules {
  String? lineRuleId;
  String? ruleName;
  int? selectRuleToRunId;
  String? selectRuleToRun;
  int? conditionId;
  String? conditionCode;
  String? subjectCode;
  List<int>? txnsId;
  List<String>? txnsCode;
  List<int>? userId;
  List<String>? userCode;
  List<int>? notificationTypeId;
  List<String>? notificationTypeCode;

  RunRules(
      {lineRuleId,
        ruleName,
        selectRuleToRunId,
        selectRuleToRun,
        conditionId,
        conditionCode,
        subjectCode,
        txnsId,
        txnsCode,
        userId,
        userCode,
        notificationTypeId,
        notificationTypeCode});

  RunRules.fromJson(Map<String, dynamic> json) {
    lineRuleId = json['line_rule_id'];
    ruleName = json['rule_name'];
    selectRuleToRunId = json['select_rule_to_run_id'];
    selectRuleToRun = json['select_rule_to_run'];
    conditionId = json['condition_id'];
    conditionCode = json['condition_code'];
    subjectCode = json['subject_code'];
    txnsId = json['txns_id'].cast<int>();
    txnsCode = json['txns_code'].cast<String>();
    userId = json['user_id'].cast<int>();
    userCode = json['user_code'].cast<String>();
    notificationTypeId = json['notification_type_id'].cast<int>();
    notificationTypeCode = json['notification_type_code'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line_rule_id'] = lineRuleId;
    data['rule_name'] = ruleName;
    data['select_rule_to_run_id'] = selectRuleToRunId;
    data['select_rule_to_run'] = selectRuleToRun;
    data['condition_id'] = conditionId;
    data['condition_code'] = conditionCode;
    data['subject_code'] = subjectCode;
    data['txns_id'] = txnsId;
    data['txns_code'] = txnsCode;
    data['user_id'] = userId;
    data['user_code'] = userCode;
    data['notification_type_id'] = notificationTypeId;
    data['notification_type_code'] = notificationTypeCode;
    return data;
  }
}
