import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/provider/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  final List<String> _projects = ['Project 1', 'Project 2', 'Project 3'];
  final List<String> _tasks = ['Task A', 'Task B', 'Task C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: projectId,
                decoration: const InputDecoration(labelText: 'Project'),
                items:
                    _projects
                        .map(
                          (proj) =>
                              DropdownMenuItem(value: proj, child: Text(proj)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => projectId = value),
                validator: (val) => val == null ? 'Select a project' : null,
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                decoration: const InputDecoration(labelText: 'Task'),
                items:
                    _tasks
                        .map(
                          (task) =>
                              DropdownMenuItem(value: task, child: Text(task)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => taskId = value),
                validator: (val) => val == null ? 'Select a task' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Time (hours)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                onSaved: (value) => notes = value ?? '',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Date: ${date.toLocal()}'.split(' ')[0]),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(
                      context,
                      listen: false,
                    ).addTimeEntry(
                      TimeEntry(
                        id: DateTime.now().toString(),
                        projectId: projectId!,
                        taskId: taskId!,
                        totalTime: totalTime,
                        date: date,
                        notes: notes,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
