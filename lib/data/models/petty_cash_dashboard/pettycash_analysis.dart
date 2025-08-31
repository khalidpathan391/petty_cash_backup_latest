// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PettyCashAnalysis {
  List<PettyCashAccounts>? pettyCashAccounts;

  PettyCashAnalysis({this.pettyCashAccounts});

  PettyCashAnalysis.fromJson(Map<String, dynamic> json) {
    if (json['petty_cash_accounts'] != null) {
      pettyCashAccounts = <PettyCashAccounts>[];
      json['petty_cash_accounts'].forEach((v) {
        pettyCashAccounts!.add(new PettyCashAccounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pettyCashAccounts != null) {
      data['petty_cash_accounts'] =
          this.pettyCashAccounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PettyCashAccounts {
  String? pettyCashCode;
  String? pettyCashDescription;
  String? pettyCashLimit;
  String? disbursementLimit;
  String? pettyCashBalance;
  String? effectiveStartDate;
  String? effectiveEndDate;
  Info? info;

  PettyCashAccounts(
      {this.pettyCashCode,
      this.pettyCashDescription,
      this.pettyCashLimit,
      this.disbursementLimit,
      this.pettyCashBalance,
      this.effectiveStartDate,
      this.effectiveEndDate,
      this.info});

  PettyCashAccounts.fromJson(Map<String, dynamic> json) {
    pettyCashCode = json['petty_cash_code'];
    pettyCashDescription = json['petty_cash_description'];
    pettyCashLimit = json['petty_cash_limit'];
    disbursementLimit = json['disbursement_limit'];
    pettyCashBalance = json['petty_cash_balance'];
    effectiveStartDate = json['effective_start_date'];
    effectiveEndDate = json['effective_end_date'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['petty_cash_code'] = this.pettyCashCode;
    data['petty_cash_description'] = this.pettyCashDescription;
    data['petty_cash_limit'] = this.pettyCashLimit;
    data['disbursement_limit'] = this.disbursementLimit;
    data['petty_cash_balance'] = this.pettyCashBalance;
    data['effective_start_date'] = this.effectiveStartDate;
    data['effective_end_date'] = this.effectiveEndDate;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  int? totalPoCount;
  String? totalPoValue;
  List<PendingGrns>? pendingGrns;
  ApprovedPostedGrns? approvedPostedGrns;

  Info(
      {this.totalPoCount,
      this.totalPoValue,
      this.pendingGrns,
      this.approvedPostedGrns});

  Info.fromJson(Map<String, dynamic> json) {
    totalPoCount = json['total_po_count'];
    totalPoValue = json['total_po_value'];
    if (json['pending_grns'] != null) {
      pendingGrns = <PendingGrns>[];
      json['pending_grns'].forEach((v) {
        pendingGrns!.add(new PendingGrns.fromJson(v));
      });
    }
    approvedPostedGrns = json['approved_posted_grns'] != null
        ? new ApprovedPostedGrns.fromJson(json['approved_posted_grns'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_po_count'] = this.totalPoCount;
    data['total_po_value'] = this.totalPoValue;
    if (this.pendingGrns != null) {
      data['pending_grns'] = this.pendingGrns!.map((v) => v.toJson()).toList();
    }
    if (this.approvedPostedGrns != null) {
      data['approved_posted_grns'] = this.approvedPostedGrns!.toJson();
    }
    return data;
  }
}

class PendingGrns {
  String? grnNo;
  String? grnDate;
  String? value;

  PendingGrns({this.grnNo, this.grnDate, this.value});

  PendingGrns.fromJson(Map<String, dynamic> json) {
    grnNo = json['grn_no'];
    grnDate = json['grn_date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grn_no'] = this.grnNo;
    data['grn_date'] = this.grnDate;
    data['value'] = this.value;
    return data;
  }
}

class ApprovedPostedGrns {
  int? count;
  String? totalValue;

  ApprovedPostedGrns({this.count, this.totalValue});

  ApprovedPostedGrns.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalValue = json['total_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total_value'] = this.totalValue;
    return data;
  }
}
