class PagesTabList {
  String? fieldName;
  int? fieldValId;
  String? fieldValCodeDesc;
  String? fieldType;
  int? isHideShow;

  PagesTabList({
    this.fieldName,
    this.fieldValId,
    this.fieldValCodeDesc,
    this.fieldType,
    this.isHideShow,
  });

  PagesTabList.fromJson(Map<String, dynamic> json) {
    fieldName = json['field_name'];
    fieldValId = json['field_val_id'];
    fieldValCodeDesc = json['field_val_code_desc'];
    fieldType = json['field_type'];
    isHideShow = json['is_hide_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_name'] = fieldName;
    data['field_val_id'] = fieldValId;
    data['field_val_code_desc'] = fieldValCodeDesc;
    data['field_type'] = fieldType;
    data['is_hide_show'] = isHideShow;
    return data;
  }
}

class AttachmentsDetails {
  String? tabName;
  String? tabVal;

  AttachmentsDetails({tabName, tabVal});

  AttachmentsDetails.fromJson(Map<String, dynamic> json) {
    tabName = json['tab_name'];
    tabVal = json['tab_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tab_name'] = tabName;
    data['tab_val'] = tabVal;
    return data;
  }
}

class HeaderAttchLst {
  String? docAttachCode;
  int? docAttachId;
  String? docAttachName;
  String? docAttachUrl;
  String? docType;
  int? docTypeId;
  String? docTitle;
  int type = 0;
  String url = '';
  String? lineId;

  HeaderAttchLst(
      {this.docAttachCode,
      this.docAttachId,
      this.docAttachName,
      this.docAttachUrl,
      this.docType,
      this.docTypeId,
      this.docTitle,
      type,
      url,
      this.lineId});

  HeaderAttchLst.fromJson(Map<String, dynamic> json) {
    docAttachCode = json['doc_attach_code'];
    docAttachId = json['doc_attach_id'];
    docAttachName = json['doc_attach_name'];
    docAttachUrl = json['doc_attach_url'];
    docType = json['doc_type'];
    docTypeId = json['doc_type_id'];
    docTitle = json['doc_title'];
    lineId = json['line_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doc_attach_code'] = docAttachCode;
    data['doc_attach_id'] = docAttachId;
    data['doc_attach_name'] = docAttachName;
    data['doc_attach_url'] = docAttachUrl;
    data['doc_type'] = docType;
    data['doc_type_id'] = docTypeId;
    data['doc_title'] = docTitle;
    data['line_id'] = lineId;
    return data;
  }
}

//For Line Attachments
// class LineItemAttachment {
//   String? docAttachCode;
//   int? docAttachId;
//   String? docAttachName;
//   String? docAttachUrl;
//   String? docType;
//   int? docTypeId;
//   String? docTitle;
//
//   LineItemAttachment(
//       {this.docAttachCode,
//         this.docAttachId,
//         this.docAttachName,
//         this.docAttachUrl,
//         this.docType,
//         this.docTypeId,
//         this.docTitle});
//
//   LineItemAttachment.fromJson(Map<String, dynamic> json) {
//     docAttachCode = json['doc_attach_code'];
//     docAttachId = json['doc_attach_id'];
//     docAttachName = json['doc_attach_name'];
//     docAttachUrl = json['doc_attach_url'];
//     docType = json['doc_type'];
//     docTypeId = json['doc_type_id'];
//     docTitle = json['doc_title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['doc_attach_code'] = docAttachCode;
//     data['doc_attach_id'] = docAttachId;
//     data['doc_attach_name'] = docAttachName;
//     data['doc_attach_url'] = docAttachUrl;
//     data['doc_type'] = docType;
//     data['doc_type_id'] = docTypeId;
//     data['doc_title'] = docTitle;
//     return data;
//   }
// }

class ValHeaderBtns {
  String? fieldName;
  String? fieldValCodeDesc;
  String? fieldType;
  String? fieldUrl;
  int? fieldHeaderId;
  String? fieldTxnType;

  ValHeaderBtns(
      {this.fieldName,
      this.fieldValCodeDesc,
      this.fieldType,
      this.fieldUrl,
      this.fieldHeaderId,
      this.fieldTxnType});

  ValHeaderBtns.fromJson(Map<String, dynamic> json) {
    fieldName = json['field_name'];
    fieldValCodeDesc = json['field_val_code_desc'];
    fieldType = json['field_type'];
    fieldUrl = json['field_url'];
    fieldHeaderId = json['field_header_id'];
    fieldTxnType = json['field_txn_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_name'] = fieldName;
    data['field_val_code_desc'] = fieldValCodeDesc;
    data['field_type'] = fieldType;
    data['field_url'] = fieldUrl;
    data['field_header_id'] = fieldHeaderId;
    data['field_txn_type'] = fieldTxnType;
    return data;
  }
}

class HeaderLogLst {
  int? srNo;
  String? fromDept;
  String? toDept;
  String? actionDate;
  String? actionByCode;
  String? actionByName;
  String? remarks;

  HeaderLogLst(
      {this.srNo,
      this.fromDept,
      this.toDept,
      this.actionDate,
      this.actionByCode,
      this.actionByName,
      this.remarks});

  HeaderLogLst.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    fromDept = json['from_dept'];
    toDept = json['to_dept'];
    actionDate = json['action_date'];
    actionByCode = json['action_by_code'];
    actionByName = json['action_by_name'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['from_dept'] = fromDept;
    data['to_dept'] = toDept;
    data['action_date'] = actionDate;
    data['action_by_code'] = actionByCode;
    data['action_by_name'] = actionByName;
    data['remarks'] = remarks;
    return data;
  }
}

class TxnDocDtSetupCondition {
  int? docBackDaysAlo;
  int? docFtrDaysAlo;

  TxnDocDtSetupCondition({this.docBackDaysAlo, this.docFtrDaysAlo});

  TxnDocDtSetupCondition.fromJson(Map<String, dynamic> json) {
    docBackDaysAlo = json['doc_back_days_alo'];
    docFtrDaysAlo = json['doc_ftr_days_alo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['doc_back_days_alo'] = this.docBackDaysAlo;
    data['doc_ftr_days_alo'] = this.docFtrDaysAlo;
    return data;
  }
}
