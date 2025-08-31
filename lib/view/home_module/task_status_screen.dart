// ListScreen with Provider and navigation passing model directly
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/dashboard/task_status_model.dart';
import 'package:petty_cash/view_model/home_module_vm/task_status_vm.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  final String status;

  const ListScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStatusVm(status: status),
      child: Scaffold(
        appBar: AppBar(title: Text('$status Leads')),
        body: Consumer<TaskStatusVm>(
          builder: (context, vm, _) => ListView.separated(
            itemCount: vm.leads.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lead = vm.leads[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(lead.name),
                subtitle: const Text('Click to view details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeadDetailScreen(lead: lead),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// LeadDetailScreen just uses the model, no VM needed
class LeadDetailScreen extends StatelessWidget {
  final TaskStatusModel lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lead Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lead.name, style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 8),
            Text('Status: ${lead.status}'),
            const SizedBox(height: 8),
            Text('Company: ${lead.company}'),
            const SizedBox(height: 8),
            Text('Contact: ${lead.contact}'),
            const SizedBox(height: 16),
            const Text('Description:'),
            const SizedBox(height: 8),
            Text(lead.description),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
