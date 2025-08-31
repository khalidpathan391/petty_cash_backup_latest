import 'package:flutter/material.dart';

class TaskStatusModel {
  final String title;
  final String taskCount;
  final IconData icon;
  final Color bgColor;

  TaskStatusModel({
    required this.title,
    required this.taskCount,
    required this.icon,
    required this.bgColor,
  });
}
