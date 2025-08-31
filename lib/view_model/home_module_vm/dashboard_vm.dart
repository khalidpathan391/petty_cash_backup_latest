import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/dashboard/dashboard_model.dart';
import 'package:petty_cash/data/models/dashboard/task_model.dart';

class DashboardVm extends ChangeNotifier {
  String selectedFilter = 'This Week';

  final List<String> filterOptions = [
    'This Week',
    'Today',
    'Overall',
    'This Month',
  ];

  double percentage = 0.0;

  DashboardVm() {
    calculatePercentage();
  }

  final List<TaskStatusModel> statusCards = [
    TaskStatusModel(
      title: "Ongoing",
      taskCount: "50",
      icon: Icons.timelapse,
      bgColor: Colors.teal.shade300,
    ),
    TaskStatusModel(
      title: "Pending",
      taskCount: "25",
      icon: Icons.pause_circle_filled,
      bgColor: Colors.orange.shade300,
    ),
    TaskStatusModel(
      title: "Completed",
      taskCount: "15",
      icon: Icons.check_circle,
      bgColor: Colors.green.shade300,
    ),
    TaskStatusModel(
      title: "Cancel",
      taskCount: "5",
      icon: Icons.cancel,
      bgColor: Colors.red.shade300,
    ),
  ];

  final List<TaskModel> taskList = [
    TaskModel(
      time: "09:00",
      status: "Ongoing",
      title: "App Design",
      timeRange: "09:20-18:20",
      statusColor: Colors.blue,
    ),
    TaskModel(
      time: "10:00",
      status: "Pending",
      title: "API Integration",
      timeRange: "10:00-12:00",
      statusColor: Colors.orange,
    ),
    TaskModel(
      time: "11:00",
      status: "Completed",
      title: "UI Review",
      timeRange: "Yesterday",
      statusColor: Colors.green,
    ),
    TaskModel(
      time: "14:00",
      status: "Ongoing",
      title: "Client Meeting",
      timeRange: "14:00-15:30",
      statusColor: Colors.blue,
    ),
  ];

  int parseTaskCount(String taskCount) {
    final parsed = int.tryParse(taskCount);
    return parsed ?? 0;
  }

  int getTotalTasks() {
    return statusCards.fold(
        0, (total, item) => total + parseTaskCount(item.taskCount));
  }

  int getCompletedTasks() {
    final completed = statusCards.firstWhere(
      (e) => e.title.toLowerCase() == 'completed',
      orElse: () => TaskStatusModel(
        title: "Completed",
        taskCount: "0",
        icon: Icons.check_circle,
        bgColor: Colors.lightGreenAccent,
      ),
    );
    return parseTaskCount(completed.taskCount);
  }

  Color getHighestCardColor() {
    if (statusCards.isEmpty) return Colors.grey;
    var highest = statusCards.reduce((a, b) =>
        parseTaskCount(a.taskCount) > parseTaskCount(b.taskCount) ? a : b);
    return highest.bgColor;
  }

  void calculatePercentage() {
    final total = getTotalTasks();
    final completed = getCompletedTasks();
    percentage = total > 0 ? completed / total : 0.0;
    notifyListeners();
  }

  void updateFilter(String newFilter) {
    selectedFilter = newFilter;
    calculatePercentage();
    notifyListeners();
  }

  void addTask(TaskModel newTask) {
    taskList.add(newTask);
    notifyListeners();
  }

  Map<String, double> get dataMap {
    return {
      for (var status in statusCards)
        status.title: parseTaskCount(status.taskCount).toDouble(),
    };
  }

  List<Color> get colorList {
    return statusCards.map((e) => e.bgColor).toList();
  }
}
