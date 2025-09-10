import 'package:petty_cash/data/models/common/common_transaction_models.dart';

class AttachmentViewModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<AttachmentLst>? attachmentLst;
  List<HeaderAttchLst>? headerAttchLst;

  AttachmentViewModel({
    this.error,
    this.errorCode,
    this.errorDescription,
    this.attachmentLst,
    this.headerAttchLst,
  });

  AttachmentViewModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['attachment_lst'] != null) {
      attachmentLst = <AttachmentLst>[];
      json['attachment_lst'].forEach((v) {
        attachmentLst!.add(AttachmentLst.fromJson(v));
      });
    }
    if (json['header_attch_lst'] != null) {
      headerAttchLst = <HeaderAttchLst>[];
      json['header_attch_lst'].forEach((v) {
        headerAttchLst!.add(HeaderAttchLst.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (attachmentLst != null) {
      data['attachment_lst'] = attachmentLst!.map((v) => v.toJson()).toList();
    }
    if (headerAttchLst != null) {
      data['header_attch_lst'] =
          headerAttchLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttachmentLst {
  int? attachedId;
  String? txnType;
  String? docNo;
  String? headerId;
  String? lineId;
  int? docTypeId;
  String? docType;
  int? menuId;
  String? docTitle;
  String? fileName;
  String? filePath;
  String? tab;
  String? createdDate;
  String? updatedDate;
  int? createEmpId;
  String? createEmpCode;
  String? createEmpName;
  int? updateEmpId;
  String? updateEmpCode;
  String? updateEmpName;
  int? companyId;
  String? uniqueVal;

  AttachmentLst(
      {this.attachedId,
      this.txnType,
      this.docNo,
      this.headerId,
      this.lineId,
      this.docTypeId,
      this.docType,
      this.menuId,
      this.docTitle,
      this.fileName,
      this.filePath,
      this.tab,
      this.createdDate,
      this.updatedDate,
      this.createEmpId,
      this.createEmpCode,
      this.createEmpName,
      this.updateEmpId,
      this.updateEmpCode,
      this.updateEmpName,
      this.companyId,
      this.uniqueVal});

  AttachmentLst.fromJson(Map<String, dynamic> json) {
    attachedId = json['attached_id'];
    txnType = json['txn_type'];
    docNo = json['doc_no'];
    headerId = json['header_id'];
    lineId = json['line_id'];
    docTypeId = json['doc_type_id'];
    docType = json['doc_type'];
    menuId = json['menu_id'];
    docTitle = json['doc_title'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    tab = json['tab'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    createEmpId = json['create_emp_id'];
    createEmpCode = json['create_emp_code'];
    createEmpName = json['create_emp_name'];
    updateEmpId = json['update_emp_id'];
    updateEmpCode = json['update_emp_code'];
    updateEmpName = json['update_emp_name'];
    companyId = json['company_id'];
    uniqueVal = json['unique_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attached_id'] = attachedId;
    data['txn_type'] = txnType;
    data['doc_no'] = docNo;
    data['header_id'] = headerId;
    data['line_id'] = lineId;
    data['doc_type_id'] = docTypeId;
    data['doc_type'] = docType;
    data['menu_id'] = menuId;
    data['doc_title'] = docTitle;
    data['file_name'] = fileName;
    data['file_path'] = filePath;
    data['tab'] = tab;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    data['create_emp_id'] = createEmpId;
    data['create_emp_code'] = createEmpCode;
    data['create_emp_name'] = createEmpName;
    data['update_emp_id'] = updateEmpId;
    data['update_emp_code'] = updateEmpCode;
    data['update_emp_name'] = updateEmpName;
    data['company_id'] = companyId;
    data['unique_val'] = uniqueVal;
    return data;
  }
}
