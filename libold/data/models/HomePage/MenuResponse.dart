class MenuResponse {
  bool error;
  int errorCode;
  String errorDescription;
  List<Menu> menu;

  MenuResponse({
    required this.error,
    required this.errorCode,
    required this.errorDescription,
    required this.menu,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      error: json['error'],
      errorCode: json['error_code'],
      errorDescription: json['error_description'],
      menu: List<Menu>.from(json['menu'].map((x) => Menu.fromJson(x))),
    );
  }
}

class Menu {
  int id;
  String title;
  String url;
  int parentId;
  String txnType;
  String txnCode;
  String parameter;
  String userId;
  int companyId;
  int displayMobileApp;
  int pageTypeId;
  String pageTypeCode;
  String pageTypeDesc;
  String menuIcon;
  List<Menu> child;
  bool isShowing;
  String filterTypeVal;
  String filterTypeCode;

  Menu({
    required this.id,
    required this.title,
    required this.url,
    required this.parentId,
    required this.txnType,
    required this.txnCode,
    required this.parameter,
    required this.userId,
    required this.companyId,
    required this.displayMobileApp,
    required this.pageTypeId,
    required this.pageTypeCode,
    required this.pageTypeDesc,
    required this.menuIcon,
    required this.child,
    required this.isShowing,
    required this.filterTypeVal,
    required this.filterTypeCode,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      parentId: json['parentId'],
      txnType: json['txn_type'],
      txnCode: json['txn_code'],
      parameter: json['parameter'],
      userId: json['user_id'],
      companyId: json['company_id'],
      displayMobileApp: json['display_mobile_app'],
      pageTypeId: json['page_type_id'],
      pageTypeCode: json['page_type_code'],
      pageTypeDesc: json['page_type_desc'],
      menuIcon: json['menu_icon'],
      isShowing: false,
      filterTypeVal: '',
      filterTypeCode: '',
      child: List<Menu>.from(json['child'].map((x) => Menu.fromJson(x))),
    );
  }
}