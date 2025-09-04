class DashBoardModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<ModulesLst>? modulesLst;
  List<CompanyLst>? companyLst;
  List<NotificationLst>? notificationLst;
  int? totalData;
  bool? isForceFullyUpdate;

  DashBoardModel(
      {this.error,
        this.errorCode,
        this.errorDescription,
        this.modulesLst,
        this.companyLst,
        this.notificationLst,
        this.totalData,
        this.isForceFullyUpdate});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['modules_lst'] != null) {
      modulesLst = <ModulesLst>[];
      json['modules_lst'].forEach((v) {
        modulesLst!.add(new ModulesLst.fromJson(v));
      });
    }
    if (json['company_lst'] != null) {
      companyLst = <CompanyLst>[];
      json['company_lst'].forEach((v) {
        companyLst!.add(new CompanyLst.fromJson(v));
      });
    }
    if (json['notification_lst'] != null) {
      notificationLst = <NotificationLst>[];
      json['notification_lst'].forEach((v) {
        notificationLst!.add(new NotificationLst.fromJson(v));
      });
    }
    totalData = json['total_data'];
    isForceFullyUpdate = json['is_force_fully_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['error_description'] = this.errorDescription;
    if (this.modulesLst != null) {
      data['modules_lst'] = this.modulesLst!.map((v) => v.toJson()).toList();
    }
    if (this.companyLst != null) {
      data['company_lst'] = this.companyLst!.map((v) => v.toJson()).toList();
    }
    if (this.notificationLst != null) {
      data['notification_lst'] =
          this.notificationLst!.map((v) => v.toJson()).toList();
    }
    data['total_data'] = this.totalData;
    data['is_force_fully_update'] = this.isForceFullyUpdate;
    return data;
  }
}

class ModulesLst {
  int? moduleId;
  String? moduleCode;
  String? moduleDesc;
  String? moduleIcon;

  ModulesLst(
      {this.moduleId, this.moduleCode, this.moduleDesc, this.moduleIcon});

  ModulesLst.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleCode = json['module_code'];
    moduleDesc = json['module_desc'];
    moduleIcon = json['module_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
    data['module_code'] = this.moduleCode;
    data['module_desc'] = this.moduleDesc;
    data['module_icon'] = this.moduleIcon;
    return data;
  }
}

class CompanyLst {
  int? compId;
  String? compCode;
  String? compName;
  String? compLogo;
  int? defaultComp;
  int? compNotification;
  String? compShortName;

  CompanyLst(
      {this.compId,
        this.compCode,
        this.compName,
        this.compLogo,
        this.defaultComp,
        this.compNotification,
        this.compShortName});

  CompanyLst.fromJson(Map<String, dynamic> json) {
    compId = json['comp_id'];
    compCode = json['comp_code'];
    compName = json['comp_name'];
    compLogo = json['comp_logo'];
    defaultComp = json['default_comp'];
    compNotification = json['comp_notification'];
    compShortName = json['comp_short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comp_id'] = this.compId;
    data['comp_code'] = this.compCode;
    data['comp_name'] = this.compName;
    data['comp_logo'] = this.compLogo;
    data['default_comp'] = this.defaultComp;
    data['comp_notification'] = this.compNotification;
    data['comp_short_name'] = this.compShortName;
    return data;
  }
}

class NotificationLst {
  int? enId;
  int? transactionId;
  String? enTxnCode;
  String? enTxnFor;
  String? enSubject;
  String? userName;
  String? fullName;
  String? enRaisedBy;
  String? enRedirectUrl;
  String? enNtfId;
  String? fileName;
  int? media;
  int? isSeen;
  int? notificationStatus;
  String? approvalStatus;
  String? colorCode;
  String? humanAgo;
  String? enCrDt;
  String? enStatus;
  int? totalDays;
  int? acceptVisible;

  NotificationLst(
      {this.enId,
        this.transactionId,
        this.enTxnCode,
        this.enTxnFor,
        this.enSubject,
        this.userName,
        this.fullName,
        this.enRaisedBy,
        this.enRedirectUrl,
        this.enNtfId,
        this.fileName,
        this.media,
        this.isSeen,
        this.notificationStatus,
        this.approvalStatus,
        this.colorCode,
        this.humanAgo,
        this.enCrDt,
        this.enStatus,
        this.totalDays,
        this.acceptVisible});

  NotificationLst.fromJson(Map<String, dynamic> json) {
    enId = json['en_id'];
    transactionId = json['transaction_id'];
    enTxnCode = json['en_txn_code'];
    enTxnFor = json['en_txn_for'];
    enSubject = json['en_subject'];
    userName = json['user_name'];
    fullName = json['full_name'];
    enRaisedBy = json['en_raised_by'];
    enRedirectUrl = json['en_redirect_url'];
    enNtfId = json['en_ntf_id'];
    fileName = json['file_name'];
    media = json['media'];
    isSeen = json['is_seen'];
    notificationStatus = json['notification_status'];
    approvalStatus = json['approval_status'];
    colorCode = json['color_code'];
    humanAgo = json['human_ago'];
    enCrDt = json['en_cr_dt'];
    enStatus = json['en_status'];
    totalDays = json['total_days'];
    acceptVisible = json['accept_visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en_id'] = this.enId;
    data['transaction_id'] = this.transactionId;
    data['en_txn_code'] = this.enTxnCode;
    data['en_txn_for'] = this.enTxnFor;
    data['en_subject'] = this.enSubject;
    data['user_name'] = this.userName;
    data['full_name'] = this.fullName;
    data['en_raised_by'] = this.enRaisedBy;
    data['en_redirect_url'] = this.enRedirectUrl;
    data['en_ntf_id'] = this.enNtfId;
    data['file_name'] = this.fileName;
    data['media'] = this.media;
    data['is_seen'] = this.isSeen;
    data['notification_status'] = this.notificationStatus;
    data['approval_status'] = this.approvalStatus;
    data['color_code'] = this.colorCode;
    data['human_ago'] = this.humanAgo;
    data['en_cr_dt'] = this.enCrDt;
    data['en_status'] = this.enStatus;
    data['total_days'] = this.totalDays;
    data['accept_visible'] = this.acceptVisible;
    return data;
  }
}
