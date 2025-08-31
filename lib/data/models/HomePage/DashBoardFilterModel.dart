import 'package:flutter/cupertino.dart';

class DashBoardFilterModel {
  bool? error;
  int? errorCode;
  String? errorDescription;
  List<SortTypeList>? sortTypeList;
  List<FilterDataLst>? filterDataLst;

  DashBoardFilterModel(
      {error,
        errorCode,
        errorDescription,
        sortTypeList,
        filterDataLst});

  DashBoardFilterModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    errorDescription = json['error_description'];
    if (json['sort_type_list'] != null) {
      sortTypeList = <SortTypeList>[];
      json['sort_type_list'].forEach((v) {
        sortTypeList!.add(SortTypeList.fromJson(v));
      });
    }
    if (json['filter_data_lst'] != null) {
      filterDataLst = <FilterDataLst>[];
      json['filter_data_lst'].forEach((v) {
        filterDataLst!.add(FilterDataLst.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorCode;
    data['error_description'] = errorDescription;
    if (sortTypeList != null) {
      data['sort_type_list'] =
          sortTypeList!.map((v) => v.toJson()).toList();
    }
    if (filterDataLst != null) {
      data['filter_data_lst'] =
          filterDataLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SortTypeList {
  int? id;
  String? code;
  String? ascType;
  String? descType;
  String? ascValue;
  String? descValue;
  bool? isAscSelected;
  bool? isDescSelected;
  bool? isChecked;

  SortTypeList(
      {id,
        code,
        ascType,
        descType,
        ascValue,
        descValue,
        isAscSelected,
        isDescSelected,
        isChecked});

  SortTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    ascType = json['asc_type'];
    descType = json['desc_type'];
    ascValue = json['asc_value'];
    descValue = json['desc_value'];
    isAscSelected = json['is_asc_selected'];
    isDescSelected = json['is_desc_selected'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['asc_type'] = ascType;
    data['desc_type'] = descType;
    data['asc_value'] = ascValue;
    data['desc_value'] = descValue;
    data['is_asc_selected'] = isAscSelected;
    data['is_desc_selected'] = isDescSelected;
    data['is_checked'] = isChecked;
    return data;
  }
}

class FilterDataLst {
  int? filterTypePk;
  String? filterTypeCode;
  String? filterTypeName;
  String? filterTypeDescription;
  String? filterByDate;
  String? filterByValue;
  List<FilterTypeLst>? filterTypeLst;
  // my added
  TextEditingController? myController = TextEditingController();

  FilterDataLst(
      {filterTypePk,
        filterTypeCode,
        filterTypeName,
        filterTypeDescription,
        filterByDate,
        filterByValue,
        filterTypeLst,
        myController
      });

  FilterDataLst.fromJson(Map<String, dynamic> json) {
    filterTypePk = json['filter_type_pk'];
    filterTypeCode = json['filter_type_code'];
    filterTypeName = json['filter_type_name'];
    filterTypeDescription = json['filter_type_description'];
    filterByDate = json['filter_by_date'];
    filterByValue = json['filter_by_value'];
    if (json['filter_type_lst'] != null) {
      filterTypeLst = <FilterTypeLst>[];
      json['filter_type_lst'].forEach((v) {
        filterTypeLst!.add(FilterTypeLst.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filter_type_pk'] = filterTypePk;
    data['filter_type_code'] = filterTypeCode;
    data['filter_type_name'] = filterTypeName;
    data['filter_type_description'] = filterTypeDescription;
    data['filter_by_date'] = filterByDate;
    data['filter_by_value'] = filterByValue;
    if (filterTypeLst != null) {
      data['filter_type_lst'] =
          filterTypeLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterTypeLst {
  int? id;
  String? code;
  String? name;
  String? description;
  bool? isSelected;
  String? betweenVal;
  // my added
  TextEditingController? betweenController = TextEditingController();

  FilterTypeLst(
      {id,
        code,
        name,
        description,
        isSelected,
        betweenVal,
        betweenController,
      });

  FilterTypeLst.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    isSelected = json['is_selected'];
    betweenVal = json['between_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['is_selected'] = isSelected;
    data['between_val'] = betweenVal;
    return data;
  }
}
