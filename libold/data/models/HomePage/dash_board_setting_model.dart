import 'package:flutter/material.dart';

class DashBoardSettingModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<Priority>? priority;
  bool? enableDisableCheckBox;

  DashBoardSettingModel(
      {error,
        errorCode,
        errorDescription,
        priority,
        enableDisableCheckBox});

  DashBoardSettingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['priority'] != null) {
      priority = <Priority>[];
      json['priority'].forEach((v) {
        priority!.add(Priority.fromJson(v));
      });
    }
    enableDisableCheckBox = json['enable_disable_check_box'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (priority != null) {
      data['priority'] = priority!.map((v) => v.toJson()).toList();
    }
    data['enable_disable_check_box'] = enableDisableCheckBox;
    return data;
  }
}

class Priority {
  int? lineId;
  int? priorityId;
  String? priorityName;
  String? color;
  int? min;
  int? max;
  //my Added
  TextEditingController? minController = TextEditingController();
  TextEditingController? maxController = TextEditingController();

  Priority(
      {lineId,
        priorityId,
        priorityName,
        color,
        min,
        max,
        minController,
        maxController,
      });

  Priority.fromJson(Map<String, dynamic> json) {
    lineId = json['line_id'];
    priorityId = json['priority_id'];
    priorityName = json['priority_name'];
    color = json['color'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line_id'] = lineId;
    data['priority_id'] = priorityId;
    data['priority_name'] = priorityName;
    data['color'] = color;
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}
