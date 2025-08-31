class DashBoardTabModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<NotificationTabList>? notificationTabList;

  DashBoardTabModel(
      {error,
        errorCode,
        errorDescription,
        notificationTabList});

  DashBoardTabModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['notification_tab_list'] != null) {
      notificationTabList = <NotificationTabList>[];
      json['notification_tab_list'].forEach((v) {
        notificationTabList!.add( NotificationTabList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (notificationTabList != null) {
      data['notification_tab_list'] =
          notificationTabList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationTabList {
  String? tabDataType;
  String? tabVal;
  String? tabName;
  String? tabDataCount;
  String? fTabDataCount;
  // my added variable
  bool? isSelected = false;

  NotificationTabList(
      {tabDataType,
        tabVal,
        tabName,
        tabDataCount,
        fTabDataCount,
        isSelected,
      });

  NotificationTabList.fromJson(Map<String, dynamic> json) {
    tabDataType = json['tab_data_type'];
    tabVal = json['tab_val'];
    tabName = json['tab_name'];
    tabDataCount = json['tab_data_count'];
    fTabDataCount = json['f_tab_data_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['tab_data_type'] = tabDataType;
    data['tab_val'] = tabVal;
    data['tab_name'] = tabName;
    data['tab_data_count'] = tabDataCount;
    data['f_tab_data_count'] = fTabDataCount;
    return data;
  }
}
