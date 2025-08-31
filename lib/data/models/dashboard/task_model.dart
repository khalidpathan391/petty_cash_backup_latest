// task_model.dart
import 'package:flutter/material.dart';

class TaskModel {
  final String time;
  final String status;
  final String title;
  final String timeRange;
  final Color statusColor;

  TaskModel({
    required this.time,
    required this.status,
    required this.title,
    required this.timeRange,
    required this.statusColor,
  });
}
