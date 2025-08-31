class PoListingModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<Listing>? listing;
  int? noOfRecords;

  PoListingModel(
      {this.error,
      this.errorCode,
      this.errorDescription,
      this.listing,
      this.noOfRecords});

  PoListingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['listing'] != null) {
      listing = <Listing>[];
      json['listing'].forEach((v) {
        listing!.add(new Listing.fromJson(v));
      });
    }
    noOfRecords = json['no_of_records'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['error_description'] = this.errorDescription;
    if (this.listing != null) {
      data['listing'] = this.listing!.map((v) => v.toJson()).toList();
    }
    data['no_of_records'] = this.noOfRecords;
    return data;
  }
}

class Listing {
  int? id;
  String? docDt;
  String? txnCode;
  String? reference;
  String? status;
  String? crByCode;
  String? crUidByName;
  String? crDate;

  Listing(
      {this.id,
      this.docDt,
      this.txnCode,
      this.reference,
      this.status,
      this.crByCode,
      this.crUidByName,
      this.crDate});

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docDt = json['doc_dt'];
    txnCode = json['txn_code'];
    reference = json['reference'];
    status = json['status'];
    crByCode = json['cr_by_code'];
    crUidByName = json['cr_uid_by_name'];
    crDate = json['cr_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_dt'] = this.docDt;
    data['txn_code'] = this.txnCode;
    data['reference'] = this.reference;
    data['status'] = this.status;
    data['cr_by_code'] = this.crByCode;
    data['cr_uid_by_name'] = this.crUidByName;
    data['cr_date'] = this.crDate;
    return data;
  }
}
