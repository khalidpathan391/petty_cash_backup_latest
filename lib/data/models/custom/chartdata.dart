// ignore_for_file: unused_import, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartData {
  //For x and y axis
  String? x;

  int? y;
  double? yy;
  Color myColor;
  //For specific purpose
  String? xy;
  bool? isVisible;
  //For Stacked Bar Graph
  final int? closed;
  final int? inProcess;
  final int? overdue;
  //For Percentage showing
  final String xPercentage;
  final String yPercentage;
  //Child List
  List<ChildChartData> chartList;
  // any Type
  final dynamic anyType;

  //Make Constructor to concat x and y
  ChartData({
    this.x,
    this.y = 0,
    this.yy = 0.0,
    this.myColor = Colors.black,
    this.isVisible = true,
    this.closed = 0,
    this.inProcess = 0,
    this.overdue = 0,
    this.xPercentage = "0%",
    this.yPercentage = "0%",
    required this.chartList,
    this.anyType = '',
  }) {
    xy = '$x - $y';
  }
}

class ChildChartData {
  String? typeId;
  String? type;
  String? docType;
  bool? isSelected;
  String? anyDataPath;
  TextEditingController? controller = TextEditingController();
  List<ChartList>? typeList;
  List<ChartList1>? typeList1;
  List<ChartList2>? typeList2;
  ChildChartData({
    this.typeId,
    this.type,
    this.docType,
    this.typeList,
    this.typeList1,
    this.typeList2,
    this.isSelected = false,
    this.anyDataPath,
    this.controller,
  });
}

class ChartList {
  final String? name;
  final String? val;
  final String? type;
  final bool? mandatory;
  ChartList({
    this.name,
    this.val,
    this.type,
    this.mandatory = false,
  });
}

class ChartList1 {
  final String? n1;
  ChartList1({
    this.n1,
  });
}

class ChartList2 {
  final String? n2;
  ChartList2({
    this.n2,
  });
}
