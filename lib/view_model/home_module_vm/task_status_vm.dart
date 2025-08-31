// TaskStatusVm with list only
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/dashboard/task_status_model.dart';

class TaskStatusVm extends ChangeNotifier {
  final String status;
  late List<TaskStatusModel> leads;

  TaskStatusVm({required this.status}) {
    leads = List.generate(
      20,
      (index) => TaskStatusModel(
        id: index + 1,
        name: '$status Lead ${index + 1}',
        status: status,
        description: 'Detailed description of lead ${index + 1}.',
        contact: 'contact${index + 1}@email.com',
        company: 'Company ${index + 1}',
      ),
    );
  }
}
