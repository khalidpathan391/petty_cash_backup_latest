// class CommonListingData {
//   bool? error;
//   int? errorCode;
//   String? errorDescription;
//   Listing? listing;

//   CommonListingData({error, errorCode, errorDescription, listing});

//   CommonListingData.fromJson(Map<String, dynamic> json) {
//     error = json['error'];
//     errorCode = json['error_code'];
//     errorDescription = json['error_description'];
//     listing =
//         json['listing'] != null ? Listing.fromJson(json['listing']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['error'] = error;
//     data['error_code'] = errorCode;
//     data['error_description'] = errorDescription;
//     if (listing != null) {
//       data['listing'] = listing!.toJson();
//     }
//     return data;
//   }
// }

// class Listing {
//   int? noOfRecords;
//   int? listingLength;
//   List<QueryList>? queryList;

//   Listing({noOfRecords, listingLength, queryList});

//   Listing.fromJson(Map<String, dynamic> json) {
//     noOfRecords = json['no_of_records'];
//     listingLength = json['listing_length'];
//     if (json['query_list'] != null) {
//       queryList = <QueryList>[];
//       json['query_list'].forEach((v) {
//         queryList!.add(new QueryList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['no_of_records'] = noOfRecords;
//     data['listing_length'] = listingLength;
//     if (queryList != null) {
//       data['query_list'] = queryList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class QueryList {
//   String? key1;
//   String? key2;
//   String? key3;
//   String? urldocNo;
//   String? key4;
//   String? key5;
//   String? key6;
//   String? key7;
//   String? key8;
//   String? key9;
//   String? key10;
//   String? key11;
//   String? key12;
//   String? key13;
//   String? key14;
//   String? key15;
//   String? key16;
//   String? key17;
//   String? key18;
//   String? key19;
//   String? key20;

//   QueryList(
//       {key1,
//       key2,
//       key3,
//       urldocNo,
//       key4,
//       key5,
//       key6,
//       key7,
//       key8,
//       key9,
//       key10,
//       key11,
//       key12,
//       key13,
//       key14,
//       key15,
//       key16,
//       key17,
//       key18,
//       key19,
//       key20});

//   QueryList.fromJson(Map<String, dynamic> json) {
//     key1 = json['key_1'];
//     key2 = json['key_2'];
//     key3 = json['key_3'];
//     urldocNo = json['urldoc_no'];
//     key4 = json['key_4'];
//     key5 = json['key_5'];
//     key6 = json['key_6'];
//     key7 = json['key_7'];
//     key8 = json['key_8'];
//     key9 = json['key_9'];
//     key10 = json['key_10'];
//     key11 = json['key_11'];
//     key12 = json['key_12'];
//     key13 = json['key_13'];
//     key14 = json['key_14'];
//     key15 = json['key_15'];
//     key16 = json['key_16'];
//     key17 = json['key_17'];
//     key18 = json['key_18'];
//     key19 = json['key_19'];
//     key20 = json['key_20'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['key_1'] = key1;
//     data['key_2'] = key2;
//     data['key_3'] = key3;
//     data['urldoc_no'] = urldocNo;
//     data['key_4'] = key4;
//     data['key_5'] = key5;
//     data['key_6'] = key6;
//     data['key_7'] = key7;
//     data['key_8'] = key8;
//     data['key_9'] = key9;
//     data['key_10'] = key10;
//     data['key_11'] = key11;
//     data['key_12'] = key12;
//     data['key_13'] = key13;
//     data['key_14'] = key14;
//     data['key_15'] = key15;
//     data['key_16'] = key16;
//     data['key_17'] = key17;
//     data['key_18'] = key18;
//     data['key_19'] = key19;
//     data['key_20'] = key20;
//     return data;
//   }
// }

//  i have commented above code 3 july

class CommonListingData {
  bool? error;
  int? errorCode;
  String? errorDescription;
  Listing? listing;

  CommonListingData(
      {this.error, this.errorCode, this.errorDescription, this.listing});

  CommonListingData.fromJson(Map<String, dynamic> json) {
    error = json['error'] as bool?;
    errorCode = json['error_code'] as int?;
    errorDescription = json['error_description'] as String?;
    listing =
        json['listing'] != null ? Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (listing != null) {
      data['listing'] = listing!.toJson();
    }
    return data;
  }
}

class Listing {
  int? noOfRecords;
  int? listingLength;
  List<QueryList>? queryList;

  Listing({this.noOfRecords, this.listingLength, this.queryList});

  Listing.fromJson(Map<String, dynamic> json) {
    noOfRecords = json['no_of_records'] as int?;
    listingLength = json['listing_length'] as int?;
    if (json['query_list'] != null) {
      queryList = <QueryList>[];
      json['query_list'].forEach((v) {
        queryList!.add(QueryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_of_records'] = noOfRecords;
    data['listing_length'] = listingLength;
    if (queryList != null) {
      data['query_list'] = queryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QueryList {
  String? key1;
  String? key2;
  String? key3;
  String? urldocNo;
  String? key4;
  String? key5;
  String? key6;
  String? key7;
  String? key8;
  String? key9;
  String? key10;
  String? key11;
  String? key12;
  String? key13;
  String? key14;
  String? key15;
  String? key16;
  String? key17;
  String? key18;
  String? key19;
  String? key20;

  QueryList({
    this.key1,
    this.key2,
    this.key3,
    this.urldocNo,
    this.key4,
    this.key5,
    this.key6,
    this.key7,
    this.key8,
    this.key9,
    this.key10,
    this.key11,
    this.key12,
    this.key13,
    this.key14,
    this.key15,
    this.key16,
    this.key17,
    this.key18,
    this.key19,
    this.key20,
  });

  QueryList.fromJson(Map<String, dynamic> json) {
    key1 = json['key_1']?.toString();
    key2 = json['key_2']?.toString();
    key3 = json['key_3']?.toString();
    urldocNo = json['urldoc_no']?.toString();
    key4 = json['key_4']?.toString();
    key5 = json['key_5']?.toString();
    key6 = json['key_6']?.toString();
    key7 = json['key_7']?.toString();
    key8 = json['key_8']?.toString();
    key9 = json['key_9']?.toString();
    key10 = json['key_10']?.toString();
    key11 = json['key_11']?.toString();
    key12 = json['key_12']?.toString();
    key13 = json['key_13']?.toString();
    key14 = json['key_14']?.toString();
    key15 = json['key_15']?.toString();
    key16 = json['key_16']?.toString();
    key17 = json['key_17']?.toString();
    key18 = json['key_18']?.toString();
    key19 = json['key_19']?.toString();
    key20 = json['key_20']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_1'] = key1;
    data['key_2'] = key2;
    data['key_3'] = key3;
    data['urldoc_no'] = urldocNo;
    data['key_4'] = key4;
    data['key_5'] = key5;
    data['key_6'] = key6;
    data['key_7'] = key7;
    data['key_8'] = key8;
    data['key_9'] = key9;
    data['key_10'] = key10;
    data['key_11'] = key11;
    data['key_12'] = key12;
    data['key_13'] = key13;
    data['key_14'] = key14;
    data['key_15'] = key15;
    data['key_16'] = key16;
    data['key_17'] = key17;
    data['key_18'] = key18;
    data['key_19'] = key19;
    data['key_20'] = key20;
    return data;
  }
}
