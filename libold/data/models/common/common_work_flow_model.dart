class ApprvlLvlStatus {
  int? workflowLevel;
  String? workflowType;
  List<WorkflowData>? workflowData;

  ApprvlLvlStatus({this.workflowLevel, this.workflowType, this.workflowData});

  ApprvlLvlStatus.fromJson(Map<String, dynamic> json) {
    workflowLevel = json['workflow_level'];
    workflowType = json['workflow_type'];
    if (json['workflow_data'] != null) {
      workflowData = <WorkflowData>[];
      json['workflow_data'].forEach((v) {
        workflowData!.add(WorkflowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workflow_level'] = workflowLevel;
    data['workflow_type'] = workflowType;
    if (workflowData != null) {
      data['workflow_data'] =
          workflowData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkflowData {
  String? actionDate;
  String? action;
  String? actionTakenByEmpCode;
  String? actionTakenByEmpName;
  String? designation;
  String? project;
  String? division;
  String? department;
  String? remark;
  String? userImg;
  String? userMobile;
  String? extNo;
  String? attachment;

  WorkflowData(
      {this.actionDate,
        this.action,
        this.actionTakenByEmpCode,
        this.actionTakenByEmpName,
        this.designation,
        this.project,
        this.division,
        this.department,
        this.remark,
        this.userImg,
        this.userMobile,
        this.extNo,
        this.attachment});

  WorkflowData.fromJson(Map<String, dynamic> json) {
    actionDate = json['action_date'];
    action = json['action'];
    actionTakenByEmpCode = json['action_taken_by_emp_code'];
    actionTakenByEmpName = json['action_taken_by_emp_name'];
    designation = json['designation'];
    project = json['project'];
    division = json['division'];
    department = json['department'];
    remark = json['remark'];
    userImg = json['user_img'];
    userMobile = json['user_mobile'];
    extNo = json['ext_no'];
    attachment = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action_date'] = actionDate;
    data['action'] = action;
    data['action_taken_by_emp_code'] = actionTakenByEmpCode;
    data['action_taken_by_emp_name'] = actionTakenByEmpName;
    data['designation'] = designation;
    data['project'] = project;
    data['division'] = division;
    data['department'] = department;
    data['remark'] = remark;
    data['user_img'] = userImg;
    data['user_mobile'] = userMobile;
    data['ext_no'] = extNo;
    data['attachment'] = attachment;
    return data;
  }
}


class WorkFlowIcons {
  String? name;
  String? icon;
  bool? isApiLoading = false;

  WorkFlowIcons({name, icon,isApiLoading});

  WorkFlowIcons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}