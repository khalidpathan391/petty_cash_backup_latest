// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class UserDataMain {
  bool? error;
  int? errorCode;
  UserData? userData;
  String? message;

  UserDataMain({this.error, this.errorCode, this.userData, this.message});

  UserDataMain.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = error;
    data['error_code'] = errorCode;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class UserData {
  int? userId;
  String? userName;
  String? email;
  String? password;
  String? mobileNo;
  int? activity;
  String? dob;
  String? gender;
  String? profileImg;
  String? notes;
  int? userType;

  UserData({
    this.userId,
    this.userName,
    this.email,
    this.password,
    this.mobileNo,
    this.activity,
    this.dob,
    this.gender,
    this.profileImg,
    this.notes,
    this.userType,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobileNo'];
    activity = json['activity'];
    dob = json['dob'];
    gender = json['gender'];
    profileImg = json['profileImg'];
    notes = json['notes'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['mobileNo'] = mobileNo;
    data['activity'] = activity;
    data['dob'] = dob;
    data['gender'] = gender;
    data['profileImg'] = profileImg;
    data['notes'] = notes;
    data['userType'] = userType;
    return data;
  }
}
