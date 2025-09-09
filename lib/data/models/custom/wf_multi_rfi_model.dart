import 'package:flutter/material.dart';

class MultiRFI {
  List<MultiRFILine>? lineData;

  MultiRFI(this.lineData);
}

class MultiRFILine {
  String? empId;
  String? empCode;
  String? empName;
  String? empDesignation;
  TextEditingController? controller;
  bool? isRequired;
  bool? isSelected;
  bool? isOpen;

  MultiRFILine({
    this.empId,
    this.empCode,
    this.empName,
    this.empDesignation,
    this.controller,
    this.isRequired,
    this.isSelected,
    this.isOpen,
  });
}
